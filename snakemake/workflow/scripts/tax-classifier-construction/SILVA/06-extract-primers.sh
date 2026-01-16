#!/usr/bin/env bash

qiime feature-classifier extract-reads \
    --i-sequences ${snakemake_input[dereplicatedDNA]} \
    --p-f-primer ${snakemake_params[fwdPrimer]} \
    --p-r-primer ${snakemake_params[revPrimer]} \
    --p-n-jobs 2 \
    --p-read-orientation 'forward' \
    --o-reads ${snakemake_output[0]} 
