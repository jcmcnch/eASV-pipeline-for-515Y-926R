#!/bin/bash -i

if [ -e samples-to-keep* ] ; then

        echo "samples-to-keep.tsv found, continuing with script."
else
        echo "samples-to-keep.tsv not found, please generate it manually. You can use the following command to create a template: \"echo \"SampleID\" > samples-to-keep.tsv && tail -n+2 manifest.csv | cut -d, -f1 | sort | uniq >> samples-to-keep.tsv\""
        exit 0
fi

mkdir 13-customized-barplots/
mkdir 13-customized-barplots/subsetted-tables/

conda activate qiime2-2019.4

for STK in `ls samples-to-keep*`; do

    for table in `ls 09-subsetting/split-tables/*qza && ls 03-DADA2d/table.qza`; do

        qiime feature-table filter-samples \
          --i-table $table \
          --m-metadata-file $STK \
          --o-filtered-table 13-customized-barplots/subsetted-tables/`basename $table _table.qza`.`basename $STK .tsv`

      done

done


for item in `ls 13-customized-barplots/subsetted-tables/*qza`; do

  name=`basename $item .qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 09-subsetting/tax-merged/chloroplasts-PhytoRef-reclassified-merged-classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 13-customized-barplots/$name

done

for item in `ls 13-customized-barplots/*/visualization.qzv`; do

  name=`dirname $item | cut -d\/ -f2`
  mv $item 13-customized-barplots/$name.qzv
  rmdir `dirname $item`

done

conda deactivate
