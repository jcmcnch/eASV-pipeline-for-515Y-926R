#!/bin/bash -i
conda activate qiime2-2019.4
mkdir 12-subsetting
mkdir 12-subsetting/split-tables
mkdir 12-subsetting/split-seqs
mkdir 12-subsetting/reclassified
mkdir 12-subsetting/tax-merged

#Filter only Chloroplast eASVs from overall table
qiime taxa filter-table \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-include "D_3__Chloroplast" \
  --o-filtered-table 12-subsetting/split-tables/include_D_3__Chloroplast_filtered_table.qza

#Filter only Chloroplast sequences from representative_sequences using default SILVA132 classification
qiime taxa filter-seqs \
  --i-sequences 06-deblurred/representative_sequences.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-include "D_3__Chloroplast" \
  --o-filtered-sequences 12-subsetting/split-seqs/include_D_3__Chloroplast_subset_filtered_seqs.qza

#Reclassify with PhytoRef
qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PhytoRef/Phyto_16S_plastid_sliced_to_Fuhrman_primers_classifier.qza \
  --i-reads 12-subsetting/split-seqs/include_D_3__Chloroplast_subset_filtered_seqs.qza \
  --o-classification 12-subsetting/reclassified/include_D_3__Chloroplast_subset_reclassified_PhytoRef.qza

#Merge taxonomies (the first one takes precedence so the PhytoRef classifications will overwrite the SILVA132 IDs)
qiime feature-table merge-taxa \
  --i-data 12-subsetting/reclassified/include_D_3__Chloroplast_subset_reclassified_PhytoRef.qza \
  --i-data 07-classified/classification.qza \
  --o-merged-data 12-subsetting/tax-merged/chloroplasts-PhytoRef-reclassified-merged-classification.qza

#Filter out Chloroplasts from overall table
qiime taxa filter-table \
    --i-table 06-deblurred/table.qza \
    --i-taxonomy 07-classified/classification.qza \
    --p-exclude "D_3__Chloroplast" \
    --o-filtered-table 12-subsetting/split-tables/exclude_D_3__Chloroplast_filtered_table.qza

#Create Mitochondria table
qiime taxa filter-table \
   --i-table 06-deblurred/table.qza \
   --i-taxonomy 07-classified/classification.qza \
   --p-include "D_4__Mitochondria" \
   --o-filtered-table 12-subsetting/split-tables/include_D_4__Mitochondria_filtered_table.qza

#Create Algae-only table
qiime taxa filter-table \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-include "D_1__Cyanobacteria" \
  --o-filtered-table 12-subsetting/split-tables/include_D_1__Cyanobacteria_filtered_table.qza

#Create Chloroplast-free Cyanobacteria table
qiime taxa filter-table \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-include "D_1__Cyanobacteria" \
  --p-exclude "D_3__Chloroplast" \
  --o-filtered-table 12-subsetting/split-tables/include_D_1__Cyanobacteria_exclude_D_3__Chloroplast_filtered_table.qza

#Create Mitochondria-free table
qiime taxa filter-table \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-exclude "D_4__Mitochondria" \
  --o-filtered-table 12-subsetting/split-tables/exclude_D_4__Mitochondria_filtered_table.qza

#Create Mitochondria and Chloroplast-free table
qiime taxa filter-table \
    --i-table 06-deblurred/table.qza \
    --i-taxonomy 07-classified/classification.qza \
    --p-exclude "D_4__Mitochondria,D_3__Chloroplast" \
    --o-filtered-table 12-subsetting/split-tables/exclude_D_3__Chloroplast_exclude_D_4__Mitochondria_filtered_table.qza

#Create Mitochondria and Cyanobacteria/Chloroplast-free table
qiime taxa filter-table \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-exclude "D_4__Mitochondria,D_1__Cyanobacteria" \
  --o-filtered-table 12-subsetting/split-tables/exclude_D_1__Cyanobacteria_exclude_D_4__Mitochondria_filtered_table.qza

#Create Archaea-only table
qiime taxa filter-table \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-include "D_0__Archaea" \
  --o-filtered-table 12-subsetting/split-tables/include_D_0__Archaea_filtered_table.qza

#Create Archaea-free table
qiime taxa filter-table \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --p-exclude "D_0__Archaea" \
  --o-filtered-table 12-subsetting/split-tables/exclude_D_0__Archaea_filtered_table.qza

conda deactivate
