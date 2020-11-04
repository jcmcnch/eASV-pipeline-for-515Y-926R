#!/bin/bash -i
#cleanup pipeline to save space
#please also gzip your raw files if applicable

rm -f 01-trimmed/*fastq
rm -f 02-PROKs/00-fastq/*fastq
#rm -f 02-EUKs/00-fastq/*fastq
rm -f 02-EUKs/03-size-selected/*fastq
rm -f 02-EUKs/04-concatenated/*fastq
