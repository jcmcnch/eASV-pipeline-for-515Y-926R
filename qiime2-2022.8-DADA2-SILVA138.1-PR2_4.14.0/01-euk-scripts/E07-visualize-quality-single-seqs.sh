#!/bin/bash -i
conda activate qiime2-2019.4

qiime demux summarize \
  --i-data 18s-concat.qza \
  --output-dir 07-quality-plots-concat \
  --verbose

conda deactivate
