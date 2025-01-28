#!/bin/bash -i
source ../515Y-806RB.cfg
conda activate $qiime2version

qiime demux summarize \
  --i-data 18s-concat.qza \
  --output-dir 07-quality-plots-concat \
  --verbose

conda deactivate
