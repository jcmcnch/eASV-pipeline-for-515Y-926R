#!/usr/bin/env bash

qiime feature-classifier fit-classifier-naive-bayes \
    --i-reference-reads {snakemake_input[slicedDNAdereplicated]} \
    --i-reference-taxonomy {snakemake_input[dereplicatedTaxaSliced]} \
    --o-classifier {snakemake_output[0]} 

