#!/usr/bin/env bash

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path ${snakemake_input[0]} \
  --output-path ${snakemake_output[0]} \
  --input-format PairedEndFastqManifestPhred33V2
