#!/bin/bash
source activate qiime2-2018.8

qiime taxa barplot \
  --i-table 08-DADA2d/table.qza \
  --i-taxonomy 10-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 12-barplots

source deactivate
