#!/bin/bash -i

source 515FY-926R.cfg

conda activate cutadapt-env

mkdir -p 01-trimmed logs/01-trimmed/

for item in `ls 00-raw/*$rawFileEndingR1` 

	do

	filestem=`basename $item $rawFileEndingR1`
	R1=00-raw/${filestem}$rawFileEndingR1
	R2=00-raw/${filestem}$rawFileEndingR2

        cutadapt --no-indels --pair-filter=any --error-rate=0.2 --discard-untrimmed \
	-g ^GTGYCAGCMGCCGCGGTAA -G ^CCGYCAATTYMTTTRAGTTT \
	-o 01-trimmed/${filestem}.R1.trimmed.fastq \
	-p 01-trimmed/${filestem}.R2.trimmed.fastq $R1 $R2 \
	2>&1 | tee -a logs/01-trimmed/${filestem}.cutadapt.stderrout

done

conda deactivate
