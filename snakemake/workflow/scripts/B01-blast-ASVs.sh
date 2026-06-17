#!/usr/bin/env bash

#require 100% coverage, 99% ID which gives 1-2 mismatches for our amplicon region (515Y/926R), probably will work for most cases
db=config/intstd_fastas/`basename ${snakemake_input[BP]} .nhr`
blastn -query ${snakemake_input[latestseqs]} -db $db -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > ${snakemake_output[BPtsv]}
cut -f1 ${snakemake_output[BPtsv]} > ${snakemake_output[BPasvs]}

db=config/intstd_fastas/`basename ${snakemake_input[DR]} .nhr`
blastn -query ${snakemake_input[latestseqs]} -db $db -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > ${snakemake_output[DRtsv]}
cut -f1 ${snakemake_output[DRtsv]} > ${snakemake_output[DRasvs]}

db=config/intstd_fastas/`basename ${snakemake_input[TT]} .nhr`
blastn -query ${snakemake_input[latestseqs]} -db $db -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > ${snakemake_output[TTtsv]}
cut -f1 ${snakemake_output[TTtsv]} > ${snakemake_output[TTasvs]}
