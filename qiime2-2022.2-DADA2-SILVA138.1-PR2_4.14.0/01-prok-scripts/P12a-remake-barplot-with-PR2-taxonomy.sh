#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

qiime taxa barplot \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 09-subsetting/tax-merged/chloroplasts-PR2-reclassified-merged-classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 07-barplots-PR2-chloroplast-tax

conda deactivate
