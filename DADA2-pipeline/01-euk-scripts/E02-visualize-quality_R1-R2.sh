#!/bin/bash
source activate qiime2-2018.8

qiime demux summarize \
--i-data 18s-viz.qza \
--output-dir 02-quality-plots-R1-R2 \
--verbose

source deactivate
