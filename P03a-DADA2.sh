#!/bin/bash

source activate qiime2-2018.8

trunclenf=$1
trunclenr=$2

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a trim length for the left (R1) read as an integer separated with a space from the script name. e.g. P03a-DADA2.sh 210 <right trim length>'
    exit 0
fi

if [[ ${#2} -eq 0 ]] ; then
    echo 'Please enter a trim length for the right (R2) read as an integer separated with a space from the script name. e.g. P03a-DADA2.sh <left trim length> 180'
    exit 0
fi

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs 16s.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f $trunclenf \
  --p-trunc-len-r $trunclenr \
  --output-dir 03a-DADA2d \
  --p-n-threads 10 \
  --verbose

source deactivate
