#!/bin/bash -i
conda activate qiime2-2019.4

qiime quality-filter q-score \
  --i-demux 18s-concat.qza \
  --output-dir 08-QCd-seqs \
  --p-min-length-fraction 1.0 \
  --verbose

qiime tools export --input-path 08-QCd-seqs/filter_stats.qza --output-path 08-QCd-seqs/

conda deactivate
