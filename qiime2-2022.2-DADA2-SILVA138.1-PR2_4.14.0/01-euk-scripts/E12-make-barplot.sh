#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

timestamp=`date +"%y%m%d-%H%M"`

qiime taxa barplot \
  --i-table 08-DADA2d/table.qza \
  --i-taxonomy 10-classified/classification.qza \
  --m-metadata-file sample-metadata.tsv \
  --output-dir 12-barplots

conda deactivate

mv 12-barplots/visualization.qzv 12-barplots/$timestamp.$studyName.18S.barplot.qzv
