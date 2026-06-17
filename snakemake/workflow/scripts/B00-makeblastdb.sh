#!/usr/bin/env bash

makeblastdb -dbtype nucl -in ${snakemake_input[BP]}
touch ${snakemake_output[BP]}

makeblastdb -dbtype nucl -in ${snakemake_input[DR]}
touch ${snakemake_output[DR]}

makeblastdb -dbtype nucl -in ${snakemake_input[TT]}
touch ${snakemake_output[TT]}
