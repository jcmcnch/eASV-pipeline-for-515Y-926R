#!/usr/bin/env bash

qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path ${snakemake_input[0]} \
  --output-path ${snakemake_output[0]}
