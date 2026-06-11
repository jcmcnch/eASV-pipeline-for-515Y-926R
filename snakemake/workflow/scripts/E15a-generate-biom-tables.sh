#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

#export plaintext taxonomy from both PR2 and SILVA

qiime tools export --input-path ${snakemake_input[SILVAclassified]} --output-path ${snakemake_output[SILVAtaxdir]}
mv ${snakemake_output[SILVAtaxdir]}/taxonomy.tsv ${snakemake_output[SILVAtaxfile]}

qiime tools export --input-path ${snakemake_input[SILVAclassified]} --output-path ${snakemake_output[PR2taxdir]}
mv ${snakemake_output[PR2taxdir]}/taxonomy.tsv ${snakemake_output[PR2taxfile]}

sed -i '1c#OTUID        taxonomy        confidence' ${snakemake_output[SILVAtaxfile]} 
sed -i '1c#OTUID        taxonomy        confidence' ${snakemake_output[PR2taxfile]}

#next, export biom files for all artifacts

qiime tools export --input-path ${snakemake_input[all18Stable]} --output-path results/02-euks/15-exports/ ; mv results/02-euks/15-exports/feature-table.biom ${snakemake_output[all18Stablebiom]} || touch ${snakemake_output[all18Stablebiom]}

qiime tools export --input-path ${snakemake_input[excludemetazoaSILVAtable]} --output-path results/02-euks/15-exports/ ; mv results/02-euks/15-exports/feature-table.biom ${snakemake_output[excludemetazoaSILVAtablebiom]} || touch ${snakemake_output[excludemetazoaSILVAtablebiom]} 

qiime tools export --input-path ${snakemake_input[excludemetazoaPR2table]} --output-path results/02-euks/15-exports/ ; mv results/02-euks/15-exports/feature-table.biom ${snakemake_output[excludemetazoaPR2tablebiom]} || touch ${snakemake_output[excludemetazoaPR2tablebiom]}

qiime tools export --input-path ${snakemake_input[includemetazoaSILVAtable]} --output-path results/02-euks/15-exports/ ; mv results/02-euks/15-exports/feature-table.biom ${snakemake_output[includemetazoaSILVAtablebiom]} || touch ${snakemake_output[includemetazoaSILVAtablebiom]}

qiime tools export --input-path ${snakemake_input[includemetazoaPR2table]} --output-path results/02-euks/15-exports/ ; mv results/02-euks/15-exports/feature-table.biom ${snakemake_output[includemetazoaPR2tablebiom]} || touch ${snakemake_output[includemetazoaPR2tablebiom]}
