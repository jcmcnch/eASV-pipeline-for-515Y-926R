#!/bin/bash -i
source ../515Y-806RB.cfg
conda activate $qiime2version

qiime demux summarize \
--i-data 16s.qza \
--output-dir 02-quality-plots-R1-R2 \
--verbose

conda deactivate
