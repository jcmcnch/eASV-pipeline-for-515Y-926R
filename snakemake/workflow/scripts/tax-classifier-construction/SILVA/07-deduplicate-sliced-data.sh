#!/usr/bin/env bash

qiime rescript dereplicate \
    --i-sequences {snakemake_input[slicedDNA]} \
    --i-taxa silva-138.1-ssu-nr99-tax-derep-uniq.qza \
    --p-rank-handles 'silva' \
    --p-mode 'uniq' \
    --o-dereplicated-sequences silva-138.1-ssu-nr99-seqs-515FY-926R-uniq.qza \
    --o-dereplicated-taxa  silva-138.1-ssu-nr99-tax-515FY-926R-derep-uniq.qza

qiime feature-classifier extract-reads \
    --i-sequences {snakemake_input[dereplicatedDNA]} \
    --p-f-primer {snakemake_params[fwdPrimer]} \
    --p-r-primer {snakemake_params[revPrimer]} \
    --p-n-jobs 2 \
    --p-read-orientation 'forward' \
    --o-reads {snakemake_output[0]} 
