#!/usr/bin/env bash

#shortcut for making manifests based on fasta file names
#modified for snakemake

#remove empty files
find ./results/01-split/*prok* -size 0 -print0 | xargs -0 rm -- 2> /dev/null

#the bit you want to cut from the file names, leaving only the sample name
cutME=".prok.R1.fastq.gz" 

printf "sample-id	forward-absolute-filepath	reverse-absolute-filepath\n" > ${snakemake_output[0]}

for item in ${snakemake_input[0]}; do

	sampleID=`basename $item $cutME | sed 's/_/-/g'` #remove underscores before importing
	sampleIDstring=`basename $item $cutME`
	R1=`ls results/01-split/$sampleIDstring.prok.R1.fastq.gz`
	R2=`ls results/01-split/$sampleIDstring.prok.R2.fastq.gz`

	printf "$sampleID	\$PWD/$R1	\$PWD/$R2\n" >> ${snakemake_output[0]}

done
