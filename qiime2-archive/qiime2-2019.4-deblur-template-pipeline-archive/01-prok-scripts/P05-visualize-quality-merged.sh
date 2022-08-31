#!/bin/bash -i
conda activate qiime2-2019.4

qiime demux summarize \
--i-data 04-QCd/filtered_sequences.qza \
--output-dir 05-QCd-quality \
--verbose

conda deactivate
