#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

#export plaintext taxonomy from merged PR2 and SILVA taxonomy file
qiime tools export --input-path ${snakemake_input[mergedtax]} --output-path results/02-proks/10-exports/
mv results/02-proks/10-exports/taxonomy.tsv ${snakemake_output[mergedtaxtsv]}
sed -i '1c#OTUID	taxonomy	confidence' ${snakemake_output[mergedtaxtsv]}

#next, export biom files for all artifacts, add tax, then export as tsv

#add in "all-16S-seqs" for non-subsetted table
#qiime tools export --input-path $item --output-path 10-exports/$name
qiime tools export --input-path ${snakemake_input[all16Stable]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[all16Stable_biom]} || touch ${snakemake_output[all16Stable_biom]}
qiime tools export --input-path ${snakemake_input[noarch]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[noarch_biom]} || touch ${snakemake_output[noarch_biom]}
qiime tools export --input-path ${snakemake_input[nomito]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[nomito_biom]} || touch ${snakemake_output[nomito_biom]}
qiime tools export --input-path ${snakemake_input[nochloronomito]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[nochloronomito_biom]} || touch ${snakemake_output[nochloronomito_biom]}
qiime tools export --input-path ${snakemake_input[nochloro]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[nochloro_biom]} || touch ${snakemake_output[nochloro_biom]}
qiime tools export --input-path ${snakemake_input[nochloronocyanonomito]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[nochloronocyanonomito_biom]} || touch ${snakemake_output[nochloronocyanonomito_biom]}
qiime tools export --input-path ${snakemake_input[onlyarch]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[onlyarch_biom]} || touch ${snakemake_output[onlyarch_biom]}
qiime tools export --input-path ${snakemake_input[onlymito]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[onlymito_biom]} || touch ${snakemake_output[onlymito_biom]}
qiime tools export --input-path ${snakemake_input[onlychloro]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[onlychloro_biom]} || touch ${snakemake_output[onlychloro_biom]}
qiime tools export --input-path ${snakemake_input[onlycyano]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[onlycyano_biom]} || touch ${snakemake_output[onlycyano_biom]}
qiime tools export --input-path ${snakemake_input[onlyalgae]} --output-path results/02-proks/10-exports ; mv results/02-proks/10-exports/feature-table.biom ${snakemake_output[onlyalgae_biom]} || touch ${snakemake_output[onlyalgae_biom]}
