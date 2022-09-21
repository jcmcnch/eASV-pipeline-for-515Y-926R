#!/bin/bash -i

conda activate bbmap-env

source 515FY-926R.cfg

#optionally add in in-silico mocks to denoising pipeline
if [[ $inSilicoMocks = "true" ]] ; then
	cp $inSilicoMockLocation/*fastq 01-trimmed/
fi

mkdir -p 02-PROKs/00-fastq
mkdir -p 02-EUKs/00-fastq

mkdir logs/02-bbsplit

for item in `ls 01-trimmed/*.R1.trimmed.fastq`

	do

	filestem=`basename $item .R1.trimmed.fastq`
	R1in=01-trimmed/$filestem.R1.trimmed.fastq
	R2in=01-trimmed/$filestem.R2.trimmed.fastq

	bbsplit.sh usequality=f qtrim=f minratio=0.30 minid=0.30 pairedonly=f threads=20 -Xmx100g \
	path=$bbsplitdb \
	in=$R1in in2=$R2in basename=$filestem.trimmed.%_#.fastq \
	2>&1 | tee -a logs/02-bbsplit/$filestem.bbsplit_log

done

mv *EUK*fastq 02-EUKs/00-fastq
mv *PROK*fastq 02-PROKs/00-fastq

rm -rf ref

timestamp=`date +"%y%m%d-%H%M"`

./scripts/calc-EUK-fraction-per-sample.sh > $timestamp.$studyName.EUKfrac-per-sample-after-bbpsplit.tsv
./scripts/calc-EUK-fraction.sh > $timestamp.$studyName.EUKfrac-whole-dataset-after-bbpsplit.tsv

conda deactivate
