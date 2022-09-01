#!/bin/bash -i

source ../515FY-926R.cfg
conda activate $qiime2version

qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest-concat.tsv \
  --output-path 18s-concat.qza \
  --input-format SingleEndFastqManifestPhred33V2

conda deactivate
