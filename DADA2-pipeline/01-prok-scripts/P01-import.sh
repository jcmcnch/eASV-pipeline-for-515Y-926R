#!/bin/bash -i
conda activate qiime2-2019.4
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest.csv \
  --output-path 16s.qza \
  --input-format PairedEndFastqManifestPhred33
  
conda deactivate
