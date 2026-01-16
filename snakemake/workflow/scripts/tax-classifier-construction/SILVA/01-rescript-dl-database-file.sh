#!/usr/bin/env bash

qiime rescript get-silva-data \
    --p-version ${snakemake_params[SILVAversion]} \
    --p-target 'SSURef_NR99' \
    --p-include-species-labels \
    --o-silva-sequences ${snakemake_output[seqs]} \
    --o-silva-taxonomy ${snakemake_output[taxonomy]}
