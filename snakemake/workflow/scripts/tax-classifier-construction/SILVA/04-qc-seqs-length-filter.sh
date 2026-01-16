#!/usr/bin/env bash

qiime rescript filter-seqs-length-by-taxon \
    --i-sequences ${snakemake_input[cleanDNA]} \
    --i-taxonomy ${snakemake_input[taxonomy]} \
    --p-labels Archaea Bacteria Eukaryota \
    --p-min-lens 900 1200 1400 \
    --o-filtered-seqs ${snakemake_output[filteredDNA]} \
    --o-discarded-seqs ${snakemake_output[discardedDNA]}
