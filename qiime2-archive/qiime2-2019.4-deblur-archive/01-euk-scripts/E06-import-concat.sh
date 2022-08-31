#!/bin/bash -i
conda activate qiime2-2019.4

qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest-concat.csv \
  --output-path 18s-concat.qza \
  --input-format SingleEndFastqManifestPhred33

conda deactivate
