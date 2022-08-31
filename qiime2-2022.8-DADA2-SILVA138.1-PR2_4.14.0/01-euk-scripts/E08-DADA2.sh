#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

qiime dada2 denoise-single \
  --i-demultiplexed-seqs 18s-concat.qza \
  --p-trim-left 0 \
  --p-trunc-len 0 \
  --output-dir 08-DADA2d \
  --p-n-threads 10 \
  --verbose

conda deactivate
