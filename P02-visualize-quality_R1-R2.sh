#!/bin/bash
source activate qiime2-2018.8
qiime demux summarize \
--i-data 16s.qza \
--output-dir 02-quality-plots-R1-R2 \
--verbose
