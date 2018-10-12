#!/bin/bash
mkdir logs/06-deblur
source activate qiime2-2018.8
qiime deblur denoise-16S \
  --i-demultiplexed-seqs 04-QCd/filtered_sequences.qza \
  --p-trim-length 364 \
  --p-sample-stats \
  --output-dir 06-deblurred \
  --verbose 2>&1 | tee -a logs/06-deblur/deblur.txt
  
mv deblur.log logs/06-deblur
source deactivate
