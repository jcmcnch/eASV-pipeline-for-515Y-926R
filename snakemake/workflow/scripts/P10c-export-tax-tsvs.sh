#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`


biom convert -i  ${snakemake_input[all16Stable_biomtax]} -o ${snakemake_output[all16Stable_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[all16Stable_biomtaxtsv]}
biom convert -i  ${snakemake_input[noarch_biomtax]} -o ${snakemake_output[noarch_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[noarch_biomtaxtsv]}
biom convert -i  ${snakemake_input[nomito_biomtax]} -o ${snakemake_output[nomito_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[nomito_biomtaxtsv]}
biom convert -i  ${snakemake_input[nochloronomito_biomtax]} -o ${snakemake_output[nochloronomito_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[nochloronomito_biomtaxtsv]}
biom convert -i  ${snakemake_input[nochloro_biomtax]} -o ${snakemake_output[nochloro_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[nochloro_biomtaxtsv]}
biom convert -i  ${snakemake_input[nochloronocyanonomito_biomtax]} -o ${snakemake_output[nochloronocyanonomito_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[nochloronocyanonomito_biomtaxtsv]}
biom convert -i  ${snakemake_input[onlyarch_biomtax]} -o ${snakemake_output[onlyarch_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[onlyarch_biomtaxtsv]}
biom convert -i  ${snakemake_input[onlymito_biomtax]} -o ${snakemake_output[onlymito_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[onlymito_biomtaxtsv]}
biom convert -i  ${snakemake_input[onlychloro_biomtax]} -o ${snakemake_output[onlychloro_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[onlychloro_biomtaxtsv]}
biom convert -i  ${snakemake_input[onlycyano_biomtax]} -o ${snakemake_output[onlycyano_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[onlycyano_biomtaxtsv]}
biom convert -i  ${snakemake_input[onlyalgae_biomtax]} -o ${snakemake_output[onlyalgae_biomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[onlyalgae_biomtaxtsv]}
