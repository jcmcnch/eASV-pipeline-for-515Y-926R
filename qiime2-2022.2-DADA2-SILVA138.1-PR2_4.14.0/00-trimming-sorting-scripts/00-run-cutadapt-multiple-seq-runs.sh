#!/bin/bash -i

source 515FY-926R.cfg

conda activate cutadapt-env

#loop across folders named 00-raw-$seqrun - naming must be exact
for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do

	mkdir -p 01-trimmed-$seqrun logs/01-trimmed-$seqrun/

for item in `ls 00-raw-$seqrun/*$rawFileEndingR1` ; do

	filestem=`basename $item $rawFileEndingR1`
	R1=00-raw-$seqrun/${filestem}$rawFileEndingR1
	R2=00-raw-$seqrun/${filestem}$rawFileEndingR2

        cutadapt --no-indels --pair-filter=any --error-rate=0.2 --discard-untrimmed \
	-g ^GTGYCAGCMGCCGCGGTAA -G ^CCGYCAATTYMTTTRAGTTT \
	-o 01-trimmed-$seqrun/${filestem}.R1.trimmed.fastq \
	-p 01-trimmed-$seqrun/${filestem}.R2.trimmed.fastq $R1 $R2 \
	2>&1 | tee -a logs/01-trimmed-$seqrun/${filestem}.cutadapt.stderrout

done

done

conda deactivate
