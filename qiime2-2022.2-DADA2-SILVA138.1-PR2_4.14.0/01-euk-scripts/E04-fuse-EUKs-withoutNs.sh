#!/bin/bash -i

conda activate bbmap-env

mkdir 04-concatenated

for item in `ls 03-size-selected/*1.trimmed.fastq`

	do

	inpath="03-size-selected"
	outpath="04-concatenated"
	filestem=`basename $item 1.trimmed.fastq`
	R1=$inpath/${filestem}1.trimmed.fastq
	R2=$inpath/${filestem}2.trimmed.fastq
	fuse.sh in=$R1 in2=$R2 fusepairs=t pad=0 out=$outpath/${filestem}concatenated.fastq

done

conda deactivate
