#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

mkdir -p logs/03-DADA2/

echo "DADA2 truncation length for forward reads = $trimR1 bp" > DADA2_trunclengths.txt
echo "DADA2 truncation length for reverse reads = $trimR2 bp" >> DADA2_trunclengths.txt

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs 16s.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f $trimR1 \
  --p-trunc-len-r $trimR2 \
  --output-dir 03-DADA2d \
  --p-n-threads 10 \
  --verbose 2>&1 | tee -a logs/03-DADA2/DADA2.stderrout

conda deactivate
