#!/bin/bash
source activate qiime2-2019.4
mkdir 14-subsetting
mkdir 14-subsetting/split-tables
mkdir 14-subsetting/split-seqs
mkdir 14-subsetting/reclassified-PR2
mkdir 14-subsetting/reclassified-PR2/fixed
mkdir 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata

#Reclassify with PR2
qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/Oceanic_database/PR2/PR2_for_qiime2_515Y_926R_sliced_classifier.qza \
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
qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-path 14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata/metadata.tsv \
  --output-path 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza

#Split out Metazoans based on SILVA132

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 10-classified/classification.qza \
    --p-exclude "D_3__Metazoa (Animalia)" \
    --o-filtered-table 14-subsetting/split-tables/exclude_D_3__Metazoa_Animalia_SILVA132_filtered_table.qza

#Split out Metazoans based on PR2

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza \
    --p-exclude "division_Metazoa" \
    --o-filtered-table 14-subsetting/split-tables/exclude_division_Metazoa_PR2_filtered_table.qza

#Create metazoan-only table based on SILVA132

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 10-classified/classification.qza \
    --p-include "D_3__Metazoa (Animalia)" \
    --o-filtered-table 14-subsetting/split-tables/include_D_3__Metazoa_Animalia_SILVA132_filtered_table.qza

#Create metazoan-only table based on PR2

qiime taxa filter-table \
    --i-table 08-DADA2d/table.qza \
    --i-taxonomy 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza \
    --p-include "division_Metazoa" \
    --o-filtered-table 14-subsetting/split-tables/include_division_Metazoa_PR2_filtered_table.qza

conda deactivate
