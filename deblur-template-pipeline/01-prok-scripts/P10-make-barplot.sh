#!/bin/bash
source activate qiime2-2018.8

qiime taxa barplot \
  --i-table 06-deblurred/table.qza \
  --i-taxonomy 07-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 10-barplots

source deactivate
