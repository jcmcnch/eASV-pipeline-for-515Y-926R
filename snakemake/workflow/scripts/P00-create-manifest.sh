#!/usr/bin/env bash

#shortcut for making manifests based on fasta file names
#modified for snakemake

#remove empty files
#find ./results/01-split/*prok* -size 0 -print0 | xargs -0 rm -- 2> /dev/null

#the bit you want to cut from the file names, leaving only the sample name
cutME=".prok.R1.fastq.gz" 

printf "sample-id	forward-absolute-filepath	reverse-absolute-filepath\n" > ${snakemake_output[0]}
	
sampleID=`echo ${snakemake_wildcards[sample]} $cutME | sed 's/_/-/g'` #remove underscores before importing
R1=${snakemake_input[0]}
R2=${snakemake_input[1]}

printf "$sampleID	\$PWD/$R1	\$PWD/$R2\n" >> ${snakemake_output[0]}

