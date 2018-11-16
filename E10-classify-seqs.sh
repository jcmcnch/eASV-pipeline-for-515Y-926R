#!/bin/bash
source activate qiime2-2018.8

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --output-dir 10-classified

source deactivate
