#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

biom add-metadata -i ${snakemake_input[excludemetazoaSILVAtablebiom]} -o ${snakemake_output[excludemetazoaSILVAtablebiomtax]} --observation-metadata-fp ${snakemake_input[SILVAtaxfile]} --sc-separated taxonomy || touch ${snakemake_output[excludemetazoaSILVAtablebiomtax]}

biom add-metadata -i ${snakemake_input[excludemetazoaPR2tablebiom]} -o ${snakemake_output[excludemetazoaPR2tablebiomtax]} --observation-metadata-fp ${snakemake_input[PR2taxfile]} --sc-separated taxonomy || touch ${snakemake_output[excludemetazoaPR2tablebiomtax]}

biom add-metadata -i ${snakemake_input[includemetazoaSILVAtablebiom]} -o ${snakemake_output[includemetazoaSILVAtablebiomtax]} --observation-metadata-fp ${snakemake_input[SILVAtaxfile]} --sc-separated taxonomy || touch ${snakemake_output[includemetazoaSILVAtablebiomtax]}

biom add-metadata -i ${snakemake_input[includemetazoaPR2tablebiom]} -o ${snakemake_output[includemetazoaPR2tablebiomtax]} --observation-metadata-fp ${snakemake_input[PR2taxfile]} --sc-separated taxonomy || touch ${snakemake_output[includemetazoaPR2tablebiomtax]}
