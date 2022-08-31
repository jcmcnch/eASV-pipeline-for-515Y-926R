#!/bin/bash -i
conda activate qiime2-2019.4

qiime dada2 denoise-single \
  --i-demultiplexed-seqs 18s-concat.qza \
  --p-trim-left 0 \
  --p-trunc-len 0 \
  --output-dir 08-DADA2d \
  --p-n-threads 10 \
  --verbose

conda deactivate
