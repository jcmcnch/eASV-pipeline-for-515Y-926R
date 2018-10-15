#!/bin/bash
source activate qiime2-2018.8

qiime taxa barplot \
  --i-table 09-deblurred/table.qza \
  --i-taxonomy 11-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 13-barplots

source deactivate
