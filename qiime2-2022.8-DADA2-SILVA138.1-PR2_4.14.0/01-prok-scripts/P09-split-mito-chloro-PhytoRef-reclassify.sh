#!/bin/bash -i
conda activate qiime2-2019.4
mkdir 09-subsetting
mkdir 09-subsetting/split-tables
mkdir 09-subsetting/split-seqs
mkdir 09-subsetting/reclassified
mkdir 09-subsetting/tax-merged

#Make subset of the biom tables that include only Chloroplast eASVs
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-include "o__Chloroplast" \
  --o-filtered-table 09-subsetting/split-tables/include_o__Chloroplast_filtered_table.qza
  
#Make subset of the biom tables that exclude Chloroplast eASVs
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-exclude "o__Chloroplast" \
  --o-filtered-table 09-subsetting/split-tables/exclude_o__Chloroplast_filtered_table.qza

#Filter only Chloroplast sequences from representative_sequences using default SILVA138 classification
qiime taxa filter-seqs \
  --i-sequences 03-DADA2d/representative_sequences.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-include "o__Chloroplast" \
  --o-filtered-sequences 09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_seqs.qza

#Filter Chloroplast sequences out from representative_sequences using default SILVA138 classification
qiime taxa filter-seqs \
  --i-sequences 03-DADA2d/representative_sequences.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-exclude "o__Chloroplast" \
  --o-filtered-sequences 09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza

#Reclassify with PhytoRef
qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/v4.12.0/qiime2/pr2_version_4.12.0_16S_mothur.seqs.sliced_515-926.classifier.qza \
  --i-reads 09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_seqs.qza \
  --o-classification 09-subsetting/reclassified/include_o__Chloroplast_subset_reclassified_PhytoRef.qza

#Merge taxonomies (the first one takes precedence so the PhytoRef classifications will overwrite the SILVA138 IDs)
qiime feature-table merge-taxa \
  --i-data 09-subsetting/reclassified/include_o__Chloroplast_subset_reclassified_PhytoRef.qza \
  --i-data 05-classified/classification.qza \
  --o-merged-data 09-subsetting/tax-merged/chloroplasts-PhytoRef-reclassified-merged-classification.qza

#Filter out Chloroplasts from overall table
qiime taxa filter-table \
    --i-table 03-DADA2d/table.qza \
    --i-taxonomy 05-classified/classification.qza \
    --p-exclude "o__Chloroplast" \
    --o-filtered-table 09-subsetting/split-tables/exclude_o__Chloroplast_filtered_table.qza

#Create Mitochondria table
qiime taxa filter-table \
   --i-table 03-DADA2d/table.qza \
   --i-taxonomy 05-classified/classification.qza \
   --p-include "f__Mitochondria" \
   --o-filtered-table 09-subsetting/split-tables/include_f__Mitochondria_filtered_table.qza

#Create Algae-only table
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-include "p__Cyanobacteria" \
  --o-filtered-table 09-subsetting/split-tables/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza

#Create Chloroplast-free Cyanobacteria table
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-include "p__Cyanobacteria" \
  --p-exclude "o__Chloroplast" \
  --o-filtered-table 09-subsetting/split-tables/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.qza

#Create Mitochondria-free table
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-exclude "f__Mitochondria" \
  --o-filtered-table 09-subsetting/split-tables/exclude_f__Mitochondria_filtered_table.qza

#Create Mitochondria and Chloroplast-free table
qiime taxa filter-table \
    --i-table 03-DADA2d/table.qza \
    --i-taxonomy 05-classified/classification.qza \
    --p-exclude "f__Mitochondria,o__Chloroplast" \
    --o-filtered-table 09-subsetting/split-tables/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.qza

#Create Mitochondria and Cyanobacteria/Chloroplast-free table
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-exclude "f__Mitochondria,p__Cyanobacteria" \
  --o-filtered-table 09-subsetting/split-tables/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.qza

#Create Archaea-only table
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-include "d__Archaea" \
  --o-filtered-table 09-subsetting/split-tables/include_d__Archaea_filtered_table.qza

#Create Archaea-free table
qiime taxa filter-table \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --p-exclude "d__Archaea" \
  --o-filtered-table 09-subsetting/split-tables/exclude_d__Archaea_filtered_table.qza

conda deactivate
