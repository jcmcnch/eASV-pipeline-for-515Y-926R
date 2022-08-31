#!/bin/bash -i

source ../515FY-926R.cfg 2> /dev/null
source 515FY-926R.cfg 2> /dev/null

conda activate $qiime2version

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest-viz.csv \
  --output-path 18s-viz.qza \
  --input-format PairedEndFastqManifestPhred33

conda deactivate
