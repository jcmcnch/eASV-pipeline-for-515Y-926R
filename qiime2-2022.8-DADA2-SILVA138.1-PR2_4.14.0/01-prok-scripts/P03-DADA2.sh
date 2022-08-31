#!/bin/bash -i

conda activate qiime2-2019.4

mkdir logs/
mkdir logs/03-DADA2/

trunclenf=$1
trunclenr=$2

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a trim length for the left (R1) read as an integer separated with a space from the script name. e.g. P03-DADA2.sh 210 <right trim length>'
    exit 0
fi

if [[ ${#2} -eq 0 ]] ; then
    echo 'Please enter a trim length for the right (R2) read as an integer separated with a space from the script name. e.g. P03-DADA2.sh <left trim length> 180'
    exit 0
fi

echo "DADA2 truncation length for forward reads = ${trunclenf} bp" > DADA2_trunclengths.txt
echo "DADA2 truncation length for reverse reads = ${trunclenr} bp" >> DADA2_trunclengths.txt

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs 16s.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f $trunclenf \
  --p-trunc-len-r $trunclenr \
  --output-dir 03-DADA2d \
  --p-n-threads 10 \
  --verbose 2>&1 | tee -a logs/03-DADA2/DADA2.stderrout

conda deactivate
