#!/bin/bash -i
conda activate qiime2-2019.4

qiime taxa barplot \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 09-subsetting/tax-merged/chloroplasts-PhytoRef-reclassified-merged-classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 07-barplots-PhytoRef-chloroplast-tax

conda deactivate
