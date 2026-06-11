#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

biom convert -i ${snakemake_input[all18StablebiomSILVAtax]} -o ${snakemake_output[all18StablebiomSILVAtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[all18StablebiomSILVAtaxtsv]}

biom convert -i ${snakemake_input[all18StablebiomPR2tax]} -o ${snakemake_output[all18StablebiomPR2taxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[all18StablebiomPR2taxtsv]}

biom convert -i ${snakemake_input[excludemetazoaSILVAtablebiomtax]} -o ${snakemake_output[excludemetazoaSILVAtablebiomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[excludemetazoaSILVAtablebiomtaxtsv]}

biom convert -i ${snakemake_input[excludemetazoaPR2tablebiomtax]} -o ${snakemake_output[excludemetazoaPR2tablebiomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[excludemetazoaPR2tablebiomtaxtsv]}

biom convert -i ${snakemake_input[includeemetazoaSILVAtablebiomtax]} -o ${snakemake_output[includeemetazoaSILVAtablebiomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[includemetazoaSILVAtablebiomtaxtsv]}

biom convert -i ${snakemake_input[includemetazoaPR2tablebiomtax]} -o ${snakemake_output[includemetazoaPR2tablebiomtaxtsv]} --to-tsv --header-key taxonomy || touch ${snakemake_output[includemetazoaPR2tablebiomtaxtsv]}
