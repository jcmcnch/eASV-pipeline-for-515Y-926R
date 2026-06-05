#!/usr/bin/env bash

#shortcut for making manifests based on fasta file names
#modified for snakemake

#the bit you want to cut from the file names, leaving only the sample name
cutME=".euk.concatenated.fastq" 

printf "sample-id	absolute-filepath\n" > ${snakemake_output[0]}

for item in ${snakemake_input[files]}; do

	sampleID=`basename $item $cutME | sed 's/_/-/g'` #remove underscores before importing
	sampleIDstring=`basename $item $cutME`
	R1=`ls results/02-euks/04-concatenated/$sampleIDstring.euk.concatenated.fastq`

	printf "$sampleID	\$PWD/$R1\n" >> ${snakemake_output[0]}

done
