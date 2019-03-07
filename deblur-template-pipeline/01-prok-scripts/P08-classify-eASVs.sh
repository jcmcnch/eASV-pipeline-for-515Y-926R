#!/bin/bash
source activate qiime2-2018.8

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
  --i-reads 06-deblurred/representative_sequences.qza \
  --output-dir 07-classified

source deactivate
