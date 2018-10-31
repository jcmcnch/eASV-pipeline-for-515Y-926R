#!/bin/bash
source activate qiime2-2018.8

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs 16s.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 214 \
  --p-trunc-len-r 187 \
  --output-dir 03a-DADA2d \
  --p-n-threads 10 \
  --verbose

source deactivate
