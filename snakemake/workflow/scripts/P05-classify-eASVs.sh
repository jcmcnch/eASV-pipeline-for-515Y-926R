#!/usr/bin/env bash

qiime feature-classifier classify-sklearn \
  --i-classifier ${snakemake_params[classDB]} \
  --i-reads ${snakemake_input[0]} \
  --output-dir ${snakemake_output[0]}
