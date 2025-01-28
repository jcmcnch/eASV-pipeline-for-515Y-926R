#!/bin/bash -i
source ../515Y-806RB.cfg
conda activate $qiime2version

timestamp=`date +"%y%m%d-%H%M"`

qiime taxa barplot \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 09-subsetting/tax-merged/chloroplasts-PR2-reclassified-merged-classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 07-barplots-PR2-chloroplast-tax

mv 07-barplots-PR2-chloroplast-tax/visualization.qzv 07-barplots-PR2-chloroplast-tax/$timestamp.$studyName.16S.barplot-PR2-chloroplast-tax.qzv

conda deactivate
