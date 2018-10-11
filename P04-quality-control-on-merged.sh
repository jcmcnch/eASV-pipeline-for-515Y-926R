#!/bin/bash
source activate qiime2-2018.8
qiime quality-filter q-score-joined \
  --i-demux 03-merged/joined_sequences.qza \
  --output-dir 04-QCd \
  --verbose

qiime tools export --input-path 04-QCd/filter_stats.qza --output-path 04-QCd/
