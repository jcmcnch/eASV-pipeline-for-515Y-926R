#!/bin/bash -i

#shortcut for making manifests based on fasta file names
#script assumes you have the same number of FWD and REV reads and that they're named in a meaninful way (i.e. samplename.1.fastq.gz)

cutME=".trimmed.SILVA_132_and_PR2_EUK.cdhit95pc_concatenated.fastq" #the bit you want to cut from the file names, leaving only the sample name

for item in `ls 04-concatenated/*concatenated.fastq` ; do echo `basename $item $cutME | sed 's/\_/\-/g'` ; done > names

for item in `ls 04-concatenated/*concatenated.fastq` ; do printf "$PWD/${item}\n"; done > reads

for item in `ls 04-concatenated/*concatenated.fastq` ; do printf "forward\n" ; done > direction

printf "sample-id,absolute-filepath,direction\n" > manifest-concat.csv
paste -d, names reads direction >> manifest-concat.csv

rm names reads direction
