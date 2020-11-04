#!/bin/bash -i
conda activate qiime2-2019.4

qiime taxa barplot \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 10-barplots

conda deactivate
