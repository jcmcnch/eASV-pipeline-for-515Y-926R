#!/bin/bash -i
conda activate qiime2-2019.4

qiime feature-classifier extract-reads \
  --i-sequences /home/db/SILVA_132/qiime_db/SILVA_132_99_OTUs.qza \
  --p-f-primer GGATTAGATACCCBRGTAGTC \
  --p-r-primer AGYTGDCGACRRCCRTGCA \
  --o-reads /home/db/SILVA_132/qiime_db/SILVA_132_99_OTUs_sliced_to_primers.qza

conda deactivate
