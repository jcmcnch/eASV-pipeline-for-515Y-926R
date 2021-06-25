#!/bin/bash -i

#shortcut for making manifests based on fasta file names
#script assumes you have the same number of FWD and REV reads and that they're named in a meaninful way (i.e. samplename.1.fastq.gz)

#remove empty files
find ./00-fastq -size  0 -print0 | xargs -0 rm --

#the bit you want to cut from the file names, leaving only the sample name
cutME=".trimmed.SILVA_132_PROK.cdhit95pc_1.fastq" 

for item in `ls 00-fastq/*1.fastq` ; do echo `basename $item $cutME` ; done > names
for item in `ls 00-fastq/*1.fastq` ; do echo `basename $item $cutME` ; done >> names

for item in `ls 00-fastq/*1.fastq` ; do printf \$PWD/$item'\n'; done > reads
for item in `ls 00-fastq/*2.fastq` ; do printf \$PWD/$item'\n'; done >> reads

for item in `ls 00-fastq/*1.fastq` ; do printf "forward\n" ; done > direction
for item in `ls 00-fastq/*2.fastq` ; do printf "reverse\n" ; done >> direction

printf "sample-id,absolute-filepath,direction\n" > manifest.csv
paste -d, names reads direction >> manifest.csv

rm names reads direction
