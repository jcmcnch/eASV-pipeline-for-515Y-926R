#!/bin/bash -i
conda activate qiime2-2019.4

mkdir 12-subsetted-reclassified-barplots

for item in `ls */*/*table.qza`; do

  name=`basename $item _table.qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 09-subsetting/tax-merged/chloroplasts-PhytoRef-reclassified-merged-classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 12-subsetted-reclassified-barplots/$name

done

for item in `ls 12-subsetted-reclassified-barplots/*/visualization.qzv`; do

  name=`dirname $item | cut -d\/ -f2`
  mv $item 12-subsetted-reclassified-barplots/$name.qzv
  rmdir `dirname $item`

done

conda deactivate
