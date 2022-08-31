#!/bin/bash -i
mkdir logs
mkdir logs/03-VSEARCH-merging

conda activate qiime2-2019.4

qiime vsearch join-pairs \
  --output-dir 03-merged \
  --i-demultiplexed-seqs 16s.qza \
  --verbose 2>&1 | tee -a logs/03-VSEARCH-merging/log.txt

conda deactivate
