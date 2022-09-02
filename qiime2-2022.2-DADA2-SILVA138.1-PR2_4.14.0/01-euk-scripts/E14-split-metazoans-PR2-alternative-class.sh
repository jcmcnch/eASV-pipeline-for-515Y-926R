#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

mkdir -p 14-subsetting/split-tables
mkdir 14-subsetting/split-seqs
mkdir -p 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata

#Reclassify with PR2
qiime feature-classifier classify-sklearn \
  --i-classifier $PR2db \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --o-classification 14-subsetting/reclassified-PR2/classification.qza

#Workaround for whitespace issue with PR2 https://forum.qiime2.org/t/qiime-taxa-filter-table-error/3947/10
qiime tools export \
  --input-path 14-subsetting/reclassified-PR2/classification.qza \
  --output-path 14-subsetting/reclassified-PR2/fixed

qiime metadata tabulate \
  --m-input-file 14-subsetting/reclassified-PR2/fixed/taxonomy.tsv  \
  --o-visualization 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata.qzv

qiime tools export \
  --input-path 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata.qzv \
  --output-path 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata

#remove line with #q2:types - is this a bug?
sed -i '/#q2:types/d' 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata/metadata.tsv

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-path 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata/metadata.tsv \
  --output-path 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza

#Split out Metazoans based on SILVA

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 10-classified/classification.qza \
    --p-exclude "p__Annelida,p__Apicomplexa,p__Arthropoda,p__Cnidaria,p__Ctenophora,p__Echinodermata,p__Holozoa,p__Mollusca,p__Porifera,p__Tunicata,p__Vertebrata" \
    --o-filtered-table 14-subsetting/split-tables/exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.qza

#Split out Metazoans based on PR2

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza \
    --p-exclude "Metazoa" \
    --o-filtered-table 14-subsetting/split-tables/exclude_Metazoa_PR2_filtered_table.qza

#Create metazoan-only table based on SILVA

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 10-classified/classification.qza \
    --p-include "p__Annelida,p__Apicomplexa,p__Arthropoda,p__Cnidaria,p__Ctenophora,p__Echinodermata,p__Holozoa,p__Mollusca,p__Porifera,p__Tunicata,p__Vertebrata" \
    --o-filtered-table 14-subsetting/split-tables/include_D_3__Metazoa_Animalia_SILVA_filtered_table.qza

#Create metazoan-only table based on PR2

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza \
    --p-include "Metazoa" \
    --o-filtered-table 14-subsetting/split-tables/include_Metazoa_PR2_filtered_table.qza

conda deactivate
