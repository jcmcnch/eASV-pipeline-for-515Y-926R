#!/bin/bash -i
conda activate qiime2-2019.4
qiime quality-filter q-score-joined \
  --i-demux 03-merged/joined_sequences.qza \
  --output-dir 04-QCd \
  --verbose

qiime tools export --input-path 04-QCd/filter_stats.qza --output-path 04-QCd/

conda deactivate
