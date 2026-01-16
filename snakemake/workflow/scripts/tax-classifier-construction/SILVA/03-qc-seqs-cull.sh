#!/usr/bin/env bash

qiime rescript cull-seqs \
    --i-sequences ${snakemake_input[rawDNA]} \
    --o-clean-sequences ${snakemake_output[cleanDNA]}
