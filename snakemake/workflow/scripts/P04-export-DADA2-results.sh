#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

qiime tools export --input-path ${snakemake_input[0]}/representative_sequences.qza --output-path ${snakemake_output[0]} 2>&1 | tee -a ${snakemake_log[0]}

qiime tools export --input-path ${snakemake_input[0]}/denoising_stats.qza --output-path ${snakemake_output[0]} 2>&1 | tee -a ${snakemake_log[0]}

qiime tools export --input-path ${snakemake_input[0]}/table.qza --output-path ${snakemake_output[0]} 2>&1 | tee -a ${snakemake_log[0]}

biom convert -i ${snakemake_output[0]}/feature-table.biom -o ${snakemake_output[0]}/feature-table.biom.tsv --to-tsv 2>&1 | tee -a ${snakemake_log[0]}

for item in ${snakemake_output[0]}/*fasta ${snakemake_output[0]}/*tsv ; do

	mv $item ${snakemake_output[0]}/$timestamp.${snakemake_params[studyName]}.16S.`basename $item`

done 2>&1 | tee -a ${snakemake_log[0]}
