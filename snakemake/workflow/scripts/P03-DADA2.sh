#!/usr/bin/env bash

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ${snakemake_input[0]} \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f ${snakemake_params[truncR1]} \
  --p-trunc-len-r ${snakemake_params[truncR2]} \
  --output-dir ${snakemake_output[1]} \
  --p-n-threads 1 \
  --verbose 2>&1 | tee -a ${snakemake_log[0]}
