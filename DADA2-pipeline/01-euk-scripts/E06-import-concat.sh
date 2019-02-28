#!/bin/bash
source activate qiime2-2018.8

qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest-concat.csv \
  --output-path 18s-concat.qza \
  --input-format SingleEndFastqManifestPhred33

source deactivate
