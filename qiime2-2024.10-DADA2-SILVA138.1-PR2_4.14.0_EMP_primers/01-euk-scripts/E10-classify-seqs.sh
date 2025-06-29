#!/bin/bash -i
source ../515Y-806RB.cfg
conda activate $qiime2version

qiime feature-classifier classify-sklearn \
  --i-classifier $SILVAdb \
  --i-reads 08-DADA2d/representative_sequences.qza \
  --output-dir 10-classified

conda deactivate
