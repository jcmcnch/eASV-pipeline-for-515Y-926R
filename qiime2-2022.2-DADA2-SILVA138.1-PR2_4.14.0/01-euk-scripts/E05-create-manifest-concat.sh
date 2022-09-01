#!/bin/bash -i

#shortcut for making manifests based on fasta file names
#script assumes you have the same number of FWD and REV reads and that they're named in a meaninful way (i.e. samplename.1.fastq.gz)

cutME=".trimmed.SILVA_132_and_PR2_EUK.cdhit95pc_concatenated.fastq" #the bit you want to cut from the file names, leaving only the sample name


printf "sample-id       forward-absolute-filepath       reverse-absolute-filepath\n" > manifest.tsv

for item in `ls 00-fastq/*1.fastq` ; do

        sampleID=`basename $item $cutME | sed 's/_/-/g'` #remove underscores before importing
        sampleIDstring=`basename $item $cutME`
        R1=`ls 00-fastq/$sampleIDstring*1.fastq`
        R2=`ls 00-fastq/$sampleIDstring*2.fastq`

        printf "$sampleID       \$PWD/$R1       \$PWD/$R2\n" >> manifest.tsv

done
