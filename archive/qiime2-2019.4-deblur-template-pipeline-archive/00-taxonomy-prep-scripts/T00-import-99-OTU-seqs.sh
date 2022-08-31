#!/bin/bash -i
conda activate qiime2-2019.4

qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path /home/db/SILVA_132/qiime_db/SILVA_132_QIIME_release/rep_set/rep_set_all/99/silva132_99.fna \
  --output-path /home/db/SILVA_132/qiime_db/SILVA_132_99_OTUs.qza

conda deactivate
