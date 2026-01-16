#!/usr/bin/env bash

qiime rescript dereplicate \
    --i-sequences ${snakemake_input[slicedDNA]} \
    --i-taxa silva-138.1-ssu-nr99-tax-derep-uniq.qza \
    --p-mode 'uniq' \
    --o-dereplicated-sequences ${snakemake_output[slicedDNAdereplicated]} \
    --o-dereplicated-taxa ${snakemake_output[dereplicatedTaxaSliced]} 
#   --p-rank-handles 'silva' #removed because 'silva' option apparently no longer works
