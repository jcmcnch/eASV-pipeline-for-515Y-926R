#!/bin/bash
source activate qiime2-2018.8

qiime taxa barplot \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 07-barplots

source deactivate
