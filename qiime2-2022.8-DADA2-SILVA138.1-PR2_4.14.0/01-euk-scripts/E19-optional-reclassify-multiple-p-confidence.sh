#!/bin/bash -i

conda activate qiime2-2019.4

mkdir 19-reclassified
mkdir 19-reclassified/SILVA138
mkdir 19-reclassified/PR2 

#Classify all the 18S sequences with SILVA 138 at the [0.5] p-confidence level. 

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_138/210309_SILVA138_nr99_sliced_to_Fuhrman_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.5 \
  --o-classification 19-reclassified/SILVA138/SILVA138-All-18S-seqs-point5-p-confidence-classification.qza

#Classify all the 18S sequences with SILVA 138 at the [0.3] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_138/210309_SILVA138_nr99_sliced_to_Fuhrman_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.3 \
  --o-classification 19-reclassified/SILVA138/SILVA138-All-18S-seqs-point3-p-confidence-classification.qza

#Classify all the 18S sequences with SILVA 138 and disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_138/210309_SILVA138_nr99_sliced_to_Fuhrman_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence -1 \
  --o-classification 19-reclassified/SILVA138/SILVA138-All-18S-seqs-minus1-p-confidence-classification.qza

#############################

#Classify all the 18S sequences with PR2 at the [0.5] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/v4.12.0/qiime2/pr2_version_4.12.0_18S_mothur.seqs.sliced_515-926.classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.5 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-point5-p-confidence-classification.qza

#Classify all the 18S sequences with PR2 at the [0.3] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/v4.12.0/qiime2/pr2_version_4.12.0_18S_mothur.seqs.sliced_515-926.classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.3 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-point3-p-confidence-classification.qza

#Classify all the 18S sequences with PR2 and disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/v4.12.0/qiime2/pr2_version_4.12.0_18S_mothur.seqs.sliced_515-926.classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence -1 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-minus1-p-confidence-classification.qza

conda deactivate
