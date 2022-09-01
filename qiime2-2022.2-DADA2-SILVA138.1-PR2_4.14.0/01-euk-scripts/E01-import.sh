#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest-viz.tsv \
  --output-path 18s-viz.qza \
  --input-format PairedEndFastqManifestPhred33V2

conda deactivate
