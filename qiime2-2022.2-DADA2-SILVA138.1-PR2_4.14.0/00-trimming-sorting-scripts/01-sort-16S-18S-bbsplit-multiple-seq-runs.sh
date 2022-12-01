#!/bin/bash -i

conda activate bbmap-env

source 515FY-926R.cfg

#optionally add in in-silico mocks to denoising pipeline
if [[ $inSilicoMocks = "true" ]] ; then
	cp $inSilicoMockLocation/*fastq 01-trimmed/
fi

#loop across folders named 00-raw-$seqrun - naming must be exact
for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do

mkdir -p 02-PROKs-$seqrun/00-fastq 02-EUKs-$seqrun/00-fastq logs/02-bbsplit-$seqrun

for item in `ls 01-trimmed-$seqrun/*.R1.trimmed.fastq`

	do

	filestem=`basename $item .R1.trimmed.fastq`
	R1in=01-trimmed-$seqrun/$filestem.R1.trimmed.fastq
	R2in=01-trimmed-$seqrun/$filestem.R2.trimmed.fastq

	bbsplit.sh usequality=f qtrim=f minratio=0.30 minid=0.30 pairedonly=f threads=20 -Xmx100g \
	path=$bbsplitdb \
	in=$R1in in2=$R2in basename=$filestem.trimmed.%_#.fastq \
	2>&1 | tee -a logs/02-bbsplit-$seqrun/$filestem.bbsplit_log

done

mv *EUK*fastq 02-EUKs-$seqrun/00-fastq
mv *PROK*fastq 02-PROKs-$seqrun/00-fastq

rm -rf ref

done

timestamp=`date +"%y%m%d-%H%M"`

#hack to get overall eukfrac by soft-linking to 01-trimmed folder
mkdir -p 01-trimmed ; for item in `ls $PWD/01-trimmed-*/*fastq` ; do ln -s $item $PWD/01-trimmed/ ; done

./scripts/calc-EUK-fraction-per-sample.sh > $timestamp.$studyName.EUKfrac-per-sample-after-bbpsplit.tsv
./scripts/calc-EUK-fraction.sh > $timestamp.$studyName.EUKfrac-whole-dataset-after-bbpsplit.tsv

conda deactivate
