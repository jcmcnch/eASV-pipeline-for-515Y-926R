#!/bin/bash
source activate qiime2-2018.8
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest.csv \
  --output-path 16s.qza \
  --input-format PairedEndFastqManifestPhred33
  
source deactivate
