#!/bin/bash
source activate qiime2-2018.8

qiime demux summarize \
--i-data 04-QCd/filtered_sequences.qza \
--output-dir 05-QCd-quality \
--verbose

source deactivate
