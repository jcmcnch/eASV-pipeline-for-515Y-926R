#!/bin/bash -i
conda activate qiime2-2019.4

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_132/qiime_db/SILVA_132_97_tax_sliced_to_Parada_primers_classifier.qza \
  --i-reads 03-DADA2d/representative_sequences.qza \
  --output-dir 05-classified

conda deactivate
