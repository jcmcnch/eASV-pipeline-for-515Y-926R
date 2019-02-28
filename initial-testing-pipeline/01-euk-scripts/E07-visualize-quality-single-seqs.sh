#!/bin/bash
source activate qiime2-2018.8

qiime demux summarize \
  --i-data 18s-concat.qza \
  --output-dir 07-quality-plots-concat \
  --verbose

source deactivate
