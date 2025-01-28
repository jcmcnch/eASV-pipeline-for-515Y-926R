#!/bin/bash -i
source ../515Y-806RB.cfg
conda activate $qiime2version

#230904 added in --p-trunc-q 0
qiime dada2 denoise-single \
  --i-demultiplexed-seqs 18s-concat.qza \
  --p-trim-left 0 \
  --p-trunc-len 0 \
  --p-trunc-q 0 \
  --output-dir 08-DADA2d \
  --p-n-threads 10 \
  --verbose

conda deactivate
