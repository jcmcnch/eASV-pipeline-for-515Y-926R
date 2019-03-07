#!/bin/bash
source activate qiime2-2018.8

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest-viz.csv \
  --output-path 18s-viz.qza \
  --input-format PairedEndFastqManifestPhred33

source deactivate
