#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

mkdir 19-reclassified
mkdir 19-reclassified/SILVA
mkdir 19-reclassified/PR2 

#Classify all the 18S sequences with SILVA 138 at the [0.5] p-confidence level. 

qiime feature-classifier classify-sklearn \
  --i-classifier $SILVAdb \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.5 \
  --o-classification 19-reclassified/SILVA/SILVA-All-18S-seqs-point5-p-confidence-classification.qza

#Classify all the 18S sequences with SILVA 138 at the [0.3] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier $SILVAdb \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.3 \
  --o-classification 19-reclassified/SILVA/SILVA-All-18S-seqs-point3-p-confidence-classification.qza

#Classify all the 18S sequences with SILVA 138 and disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
  --i-classifier $SILVAdb \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence -1 \
  --o-classification 19-reclassified/SILVA/SILVA-All-18S-seqs-minus1-p-confidence-classification.qza

#############################

#Classify all the 18S sequences with PR2 at the [0.5] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier $PR2db \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.5 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-point5-p-confidence-classification.qza

#Classify all the 18S sequences with PR2 at the [0.3] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier $PR2db \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.3 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-point3-p-confidence-classification.qza

#Classify all the 18S sequences with PR2 and disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
  --i-classifier $PR2db \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence -1 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-minus1-p-confidence-classification.qza

conda deactivate
