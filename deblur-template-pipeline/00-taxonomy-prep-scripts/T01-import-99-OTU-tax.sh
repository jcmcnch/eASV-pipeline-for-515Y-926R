#!/bin/bash -i
conda activate qiime2-2019.4

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --source-format HeaderlessTSVTaxonomyFormat \
  --input-path /home/db/SILVA_132/qiime_db/SILVA_132_QIIME_release/taxonomy/taxonomy_all/99/consensus_taxonomy_7_levels.txt \
  --output-path /home/db/SILVA_132/qiime_db/SILVA_132_99_tax.qza

conda deactivate
