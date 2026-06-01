#!/usr/bin/env bash

qiime rescript cull-seqs \
    --i-sequences ${snakemake_input[0]} \
    --o-clean-sequences ${snakemake_output[0]}
