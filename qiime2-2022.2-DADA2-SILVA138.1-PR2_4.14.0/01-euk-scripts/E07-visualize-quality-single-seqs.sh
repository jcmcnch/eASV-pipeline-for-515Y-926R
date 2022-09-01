#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

qiime demux summarize \
  --i-data 18s-concat.qza \
  --output-dir 07-quality-plots-concat \
  --verbose

conda deactivate
