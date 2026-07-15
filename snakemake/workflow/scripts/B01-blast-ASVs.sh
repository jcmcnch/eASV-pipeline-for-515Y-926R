#!/usr/bin/env bash

#require 100% coverage, 99% ID which gives 1-2 mismatches for our amplicon region (515Y/926R), probably will work for most cases
db=config/intstd_fastas/`basename ${snakemake_input[intstd1]} .nhr`
echo blastn -query ${snakemake_input[latestseqs]} -db $db -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > ${snakemake_output[intstd1tsv]}
blastn -query ${snakemake_input[latestseqs]} -db $db -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > ${snakemake_output[intstd1tsv]}
cut -f1 ${snakemake_output[intstd1tsv]} > ${snakemake_output[intstd1asvs]}

db=config/intstd_fastas/`basename ${snakemake_input[intstd2]} .nhr`
blastn -query ${snakemake_input[latestseqs]} -db $db -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > ${snakemake_output[intstd2tsv]}
cut -f1 ${snakemake_output[intstd2tsv]} > ${snakemake_output[intstd2asvs]}

db=config/intstd_fastas/`basename ${snakemake_input[intstd3]} .nhr`
blastn -query ${snakemake_input[latestseqs]} -db $db -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > ${snakemake_output[intstd3tsv]}
cut -f1 ${snakemake_output[intstd3tsv]} > ${snakemake_output[intstd3asvs]}
