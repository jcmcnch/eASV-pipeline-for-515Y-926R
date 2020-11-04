#!/bin/bash -i
mkdir logs/09-deblur
conda activate qiime2-2019.4

qiime deblur denoise-other \
  --i-reference-seqs /home/db/bbsplit-db/SILVA_132_and_PR2_EUK.cdhit95pc.qza \
  --i-demultiplexed-seqs 08-QCd-seqs/filtered_sequences.qza \
  --p-trim-length -1 \
  --p-sample-stats \
  --output-dir 09-deblurred 2>&1 | tee -a logs/09-deblur/deblur.txt
  
mv deblur.log logs/09-deblur

conda deactivate
