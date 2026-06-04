#!/usr/bin/env bash

qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path ${snakemake_input[0]} \
  --output-path ${snakemake_output[0]} \
  --input-format SingleEndFastqManifestPhred33V2
