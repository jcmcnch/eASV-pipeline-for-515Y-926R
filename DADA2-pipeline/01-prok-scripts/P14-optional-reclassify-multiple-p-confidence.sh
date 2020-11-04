#!/bin/bash -i
conda activate qiime2-2019.4

mkdir 14-reclassified
mkdir 14-reclassified/chloroplasts
mkdir 14-reclassified/non-chloroplasts 

#Classify all the non-chloroplast 16S sequences with SILVA 132 at the [0.5] p-confidence level

qiime feature-classifier classify-sklearn \
        --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
        --i-reads 09-subsetting/split-seqs/exclude_D_3__Chloroplast_subset_filtered_seqs.qza \
	--p-confidence 0.5 \
	--o-classification 14-reclassified/non-chloroplasts/SILVA132-non-chloroplast-point5-p-confidence-classification.qza

#Classify all the non-chloroplast 16S sequences with SILVA 132 at the [0.3] p-confidence level

qiime feature-classifier classify-sklearn \
	--i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
        --i-reads 09-subsetting/split-seqs/exclude_D_3__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence 0.3 \
        --o-classification 14-reclassified/non-chloroplasts/SILVA132-non-chloroplast-point3-p-confidence-classification.qza

#Classify all the non-chloroplast 16S sequences with SILVA 132 and do not set a confidence disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
        --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
        --i-reads 09-subsetting/split-seqs/exclude_D_3__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence -1 \
        --o-classification 14-reclassified/non-chloroplasts/SILVA132-non-chloroplast-minus1-p-confidence-classification.qza

########################

#Classify all the chloroplast 16S sequences with PhytoRef at the [0.5] p-confidence level

qiime feature-classifier classify-sklearn \
        --i-classifier /home/db/PhytoRef/Phyto_16S_plastid_sliced_to_Fuhrman_primers_classifier.qza \
        --i-reads 09-subsetting/split-seqs/include_D_3__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence 0.5 \
        --o-classification 14-reclassified/chloroplasts/PhytoRef-chloroplast-point5-p-confidence-classification.qza

#Classify all the chloroplast 16S sequences with PhytoRef at the [0.3] p-confidence level

qiime feature-classifier classify-sklearn \
        --i-classifier /home/db/PhytoRef/Phyto_16S_plastid_sliced_to_Fuhrman_primers_classifier.qza \
        --i-reads 09-subsetting/split-seqs/include_D_3__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence 0.3 \
        --o-classification 14-reclassified/chloroplasts/PhytoRef-chloroplast-point3-p-confidence-classification.qza

#Classify all the chloroplast 16S sequences with PhytoRef and do not set a confidence disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
        --i-classifier /home/db/PhytoRef/Phyto_16S_plastid_sliced_to_Fuhrman_primers_classifier.qza \
        --i-reads 09-subsetting/split-seqs/include_D_3__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence -1 \
        --o-classification 14-reclassified/chloroplasts/PhytoRef-chloroplast-minus1-p-confidence-classification.qza
 
conda deactivate
