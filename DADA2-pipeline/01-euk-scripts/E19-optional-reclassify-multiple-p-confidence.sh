#!/bin/bash -i

conda activate qiime2-2019.4

mkdir 19-reclassified
mkdir 19-reclassified/SILVA132
mkdir 19-reclassified/PR2 

#Classify all the 18S sequences with SILVA 132 at the [0.5] p-confidence level. 

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.5 \
  --o-classification 19-reclassified/SILVA132/SILVA132-All-18S-seqs-point5-p-confidence-classification.qza

#Classify all the 18S sequences with SILVA 132 at the [0.3] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.3 \
  --o-classification 19-reclassified/SILVA132/SILVA132-All-18S-seqs-point3-p-confidence-classification.qza

#Classify all the 18S sequences with SILVA 132 and disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence -1 \
  --o-classification 19-reclassified/SILVA132/SILVA132-All-18S-seqs-minus1-p-confidence-classification.qza

#############################

#Classify all the 18S sequences with PR2 at the [0.5] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/Oceanic_database/PR2/PR2_for_qiime2_515Y_926R_sliced_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.5 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-point5-p-confidence-classification.qza

#Classify all the 18S sequences with PR2 at the [0.3] p-confidence level.

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/Oceanic_database/PR2/PR2_for_qiime2_515Y_926R_sliced_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence 0.3 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-point3-p-confidence-classification.qza

#Classify all the 18S sequences with PR2 and disable the confidence calculation [-1]

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/PR2/Oceanic_database/PR2/PR2_for_qiime2_515Y_926R_sliced_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --p-confidence -1 \
  --o-classification 19-reclassified/PR2/PR2-All-18S-seqs-minus1-p-confidence-classification.qza

conda deactivate
