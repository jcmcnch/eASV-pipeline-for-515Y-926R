#!/bin/bash -i
conda activate qiime2-2019.4

mkdir 17-subsetted-reclassified-barplots

for item in `ls */*/*table.qza | grep "PR2"`; do

  name=`basename $item _table.qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 17-subsetted-reclassified-barplots/$name

done

for item in `ls */*/*table.qza | grep "SILVA138"`; do

  name=`basename $item _table.qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 10-classified/classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 17-subsetted-reclassified-barplots/$name

done

for item in `ls */*table.qza`; do

  name="all-18S-seqs"

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 10-classified/classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 17-subsetted-reclassified-barplots/$name.SILVA138

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza  \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 17-subsetted-reclassified-barplots/$name.PR2

done

for item in `ls 17-subsetted-reclassified-barplots/*/visualization.qzv`; do

  name=`dirname $item | cut -d\/ -f2`
  mv $item 17-subsetted-reclassified-barplots/$name.qzv
  rmdir `dirname $item`

done

conda deactivate
