#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

timestamp=`date +"%y%m%d-%H%M"`

qiime taxa barplot \
  --i-table 03-DADA2d/table.qza \
  --i-taxonomy 05-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 07-barplots

mv 07-barplots/visualization.qzv 07-barplots/$timestamp.$studyName.16S.barplot.qzv

conda deactivate
