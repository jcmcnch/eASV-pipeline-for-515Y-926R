#!/bin/bash -i
conda activate qiime2-2019.4

qiime feature-classifier classify-sklearn \
  --i-classifier /home/db/SILVA_138/210309_SILVA138_nr99_sliced_to_Fuhrman_primers_classifier.qza \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --output-dir 10-classified

conda deactivate
