#!/bin/bash -i
conda activate qiime2-2019.4
qiime demux summarize \
--i-data 16s.qza \
--output-dir 02-quality-plots-R1-R2 \
--verbose

conda deactivate
