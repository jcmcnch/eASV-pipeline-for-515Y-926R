#!/usr/bin/env bash

qiime rescript dereplicate \
    --i-sequences ${snakemake_input[filteredDNA]} \
    --i-taxa ${snakemake_input[taxonomy]} \
    --p-mode 'uniq' \
    --o-dereplicated-sequences ${snakemake_output[dereplicatedDNA]} \
    --o-dereplicated-taxa ${snakemake_output[dereplicatedTaxa]}
#   --p-rank-handles 'silva' #removed because 'silva' option apparently no longer works
