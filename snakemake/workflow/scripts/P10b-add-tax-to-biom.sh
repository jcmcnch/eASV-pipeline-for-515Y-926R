#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

biom add-metadata -i ${snakemake_input[all16Stable_biom]} -o ${snakemake_output[all16Stable_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[all16Stable_biomtax]}
biom add-metadata -i ${snakemake_input[noarch_biom]} -o ${snakemake_output[noarch_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[noarch_biomtax]}
biom add-metadata -i ${snakemake_input[nomito_biom]} -o ${snakemake_output[nomito_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[nomito_biomtax]}
biom add-metadata -i ${snakemake_input[nochloronomito_biom]} -o ${snakemake_output[nochloronomito_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[nochloronomito_biomtax]}
biom add-metadata -i ${snakemake_input[nochloro_biom]} -o ${snakemake_output[nochloro_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[nochloro_biomtax]}
biom add-metadata -i ${snakemake_input[nochloronocyanonomito_biom]} -o ${snakemake_output[nochloronocyanonomito_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[nochloronocyanonomito_biomtax]}
biom add-metadata -i ${snakemake_input[onlyarch_biom]} -o ${snakemake_output[onlyarch_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[onlyarch_biomtax]}
biom add-metadata -i ${snakemake_input[onlymito_biom]} -o ${snakemake_output[onlymito_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[onlymito_biomtax]}
biom add-metadata -i ${snakemake_input[onlychloro_biom]} -o ${snakemake_output[onlychloro_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[onlychloro_biomtax]}
biom add-metadata -i ${snakemake_input[onlycyano_biom]} -o ${snakemake_output[onlycyano_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[onlycyano_biomtax]}
biom add-metadata -i ${snakemake_input[onlyalgae_biom]} -o ${snakemake_output[onlyalgae_biomtax]} --observation-metadata-fp ${snakemake_input[mergedtaxtsv]} --sc-separated taxonomy || touch ${snakemake_output[onlyalgae_biomtax]}
