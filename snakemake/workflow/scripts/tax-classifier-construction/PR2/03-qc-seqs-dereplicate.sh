#!/usr/bin/env bash

qiime rescript dereplicate \
    --i-sequences ${snakemake_input[culled]} \
    --i-taxa ${snakemake_input[taxonomy]} \
    --p-mode 'uniq' \
    --p-rank-handles 'disable'\
    --o-dereplicated-sequences ${snakemake_output[derepseqs]} \
    --o-dereplicated-taxa ${snakemake_output[dereptaxa]}
