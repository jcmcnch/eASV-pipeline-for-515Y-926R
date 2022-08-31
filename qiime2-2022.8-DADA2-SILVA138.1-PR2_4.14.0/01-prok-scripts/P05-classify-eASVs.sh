#!/bin/bash -i
conda activate $qiime2version
source ../515FY-926R.cfg 2> /dev/null
source 515FY-926R.cfg 2> /dev/null

qiime feature-classifier classify-sklearn \
  --i-classifier $SILVAdb \
  --i-reads 03-DADA2d/representative_sequences.qza \
  --output-dir 05-classified

conda deactivate
