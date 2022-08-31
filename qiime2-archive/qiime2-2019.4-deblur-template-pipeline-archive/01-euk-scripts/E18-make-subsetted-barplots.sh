#!/bin/bash -i
conda activate qiime2-2019.4

mkdir 18-subsetted-reclassified-barplots

for item in `ls */*/*table.qza | grep "PR2"`; do

  name=`basename $item _table.qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 15-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-subsetted-reclassified-barplots/$name

done

for item in `ls */*/*table.qza | grep "SILVA132"`; do

  name=`basename $item _table.qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 11-classified/classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-subsetted-reclassified-barplots/$name

done

for item in `ls */*table.qza`; do

  name="all-18S-seqs"

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 11-classified/classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-subsetted-reclassified-barplots/$name.SILVA132

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 15-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza  \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-subsetted-reclassified-barplots/$name.PR2

done

for item in `ls 18-subsetted-reclassified-barplots/*/visualization.qzv`; do

  name=`dirname $item | cut -d\/ -f2`
  mv $item 18-subsetted-reclassified-barplots/$name.qzv
  rmdir `dirname $item`

done

conda deactivate
