#!/usr/bin/env bash

#230904 added in --p-trunc-q 0
qiime dada2 denoise-single \
  --i-demultiplexed-seqs ${snakemake_input[0]} \
  --p-trim-left 0 \
  --p-trunc-len 0 \
  --p-trunc-q 0 \
  --o-table ${snakemake_output[euktable]} \
  --o-representative-sequences ${snakemake_output[eukrepseqs]} \
  --o-denoising-stats ${snakemake_output[eukstats]} \
  --verbose
