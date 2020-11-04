#!/bin/bash -i
conda activate qiime2-2019.4

qiime taxa barplot \
  --i-table 08-DADA2d/table.qza \
  --i-taxonomy 10-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 12-barplots

conda deactivate
