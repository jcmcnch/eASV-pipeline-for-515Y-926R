#!/usr/bin/env bash

qiime rescript reverse-transcribe \
    --i-rna-sequences ${snakemake_input[0]} \
    --o-dna-sequences ${snakemake_output[0]} 
