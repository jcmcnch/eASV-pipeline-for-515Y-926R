#!/bin/bash -i
source ../515Y-806RB.cfg
conda activate $qiime2version

qiime feature-classifier classify-sklearn \
  --i-classifier $SILVAdb \
  --i-reads 03-DADA2d/representative_sequences.qza \
  --output-dir 05-classified

conda deactivate
