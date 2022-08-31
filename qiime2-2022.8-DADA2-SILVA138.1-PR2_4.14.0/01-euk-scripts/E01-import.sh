#!/bin/bash -i
conda activate $qiime2version

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest-viz.csv \
  --output-path 18s-viz.qza \
  --input-format PairedEndFastqManifestPhred33

conda deactivate
