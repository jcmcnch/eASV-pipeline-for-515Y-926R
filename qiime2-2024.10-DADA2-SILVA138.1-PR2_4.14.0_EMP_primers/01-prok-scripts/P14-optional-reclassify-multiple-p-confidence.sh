#!/bin/bash -i
source ../515Y-806RB.cfg
conda activate $qiime2version

mkdir 14-reclassified
mkdir 14-reclassified/chloroplasts
mkdir 14-reclassified/non-chloroplasts 

#Classify all the non-chloroplast 16S sequences with SILVA at the [0.5] p-confidence level

qiime feature-classifier classify-sklearn \
        --i-classifier $SILVAdb \
        --i-reads 09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza \
	--p-confidence 0.5 \
	--o-classification 14-reclassified/non-chloroplasts/SILVA-non-chloroplast-point5-p-confidence-classification.qza

#Classify all the non-chloroplast 16S sequences with SILVA at the [0.3] p-confidence level

qiime feature-classifier classify-sklearn \
	--i-classifier $SILVAdb \
        --i-reads 09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence 0.3 \
        --o-classification 14-reclassified/non-chloroplasts/SILVA-non-chloroplast-point3-p-confidence-classification.qza

#Classify all the non-chloroplast 16S sequences with SILVA and do not set a confidence disable the confidence calculation

qiime feature-classifier classify-sklearn \
        --i-classifier $SILVAdb \
        --i-reads 09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence "disable" \
        --o-classification 14-reclassified/non-chloroplasts/SILVA-non-chloroplast-disable-p-confidence-classification.qza

########################

#Classify all the chloroplast 16S sequences with PR2 at the [0.5] p-confidence level

qiime feature-classifier classify-sklearn \
        --i-classifier $PR2db \
        --i-reads 09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence 0.5 \
        --o-classification 14-reclassified/chloroplasts/PR2-chloroplast-point5-p-confidence-classification.qza

#Classify all the chloroplast 16S sequences with PR2 at the [0.3] p-confidence level

qiime feature-classifier classify-sklearn \
        --i-classifier $PR2db \
        --i-reads 09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence 0.3 \
        --o-classification 14-reclassified/chloroplasts/PR2-chloroplast-point3-p-confidence-classification.qza

#Classify all the chloroplast 16S sequences with PR2 and do not set a confidence disable the confidence calculation

qiime feature-classifier classify-sklearn \
        --i-classifier $PR2db \
        --i-reads 09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_seqs.qza \
        --p-confidence "disable" \
        --o-classification 14-reclassified/chloroplasts/PR2-chloroplast-disable-p-confidence-classification.qza
 
conda deactivate
