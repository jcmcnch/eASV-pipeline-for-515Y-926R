#!/usr/bin/env bash

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path ${snakemake_input[0]} \
  --output-path ${snakemake_output[0]}
