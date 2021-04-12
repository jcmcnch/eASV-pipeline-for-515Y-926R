#!/bin/bash -i

if [ -e samples-to-keep* ] ; then

        echo "samples-to-keep.tsv found, continuing with script."
else
        echo "samples-to-keep.tsv not found, please generate it manually. You can use the following command to create a template: \"echo \"SampleID\" > samples-to-keep.tsv && tail -n+2 manifest-concat.csv | cut -d, -f1 | sort | uniq >> samples-to-keep.tsv\""
        exit 0
fi

mkdir 18-customized-barplots/
mkdir 18-customized-barplots/subsetted-tables/

conda activate qiime2-2019.4 

#Use qiime feature-table filter-samples to modify the feature tables to include only the samples-to-keep (STK) 
for STK in `ls samples-to-keep*`; do

    for table in `ls 14-subsetting/split-tables/*qza && ls 08-DADA2d/table.qza`; do

        qiime feature-table filter-samples \
          --i-table $table \
          --m-metadata-file $STK \
          --o-filtered-table 18-customized-barplots/subsetted-tables/`basename $table _table.qza`.`basename $STK .tsv`

      done

done


#All 18S sequences using PR2 classifications
for item in `ls 18-customized-barplots/subsetted-tables/*qza | grep "table.qza"`; do

  name=`basename $item .qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-customized-barplots/all-18S-seqs-PR2

done


#All 18S sequences using SILVA138 classifications
for item in `ls 18-customized-barplots/subsetted-tables/*qza | grep "table.qza"`; do

  name=`basename $item .qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 10-classified/classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-customized-barplots/all-18S-seqs-SILVA138

done


#Subsetted tables (without metazoans or only metazoans) with PR2 classifcations  
for item in `ls 18-customized-barplots/subsetted-tables/*qza | grep "PR2"`; do

  name=`basename $item .qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 14-subsetting/reclassified-PR2/classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-customized-barplots/$name

done


#Subsetted tables (without metazoans or only metazoans) with SILVA138 classifications
for item in `ls 18-customized-barplots/subsetted-tables/*qza | grep "SILVA138"`; do

  name=`basename $item .qza`

  qiime taxa barplot \
    --i-table $item \
    --i-taxonomy 10-classified/classification.qza \
    --m-metadata-file sample-metadata.tsv \
    --output-dir 18-customized-barplots/$name

done


#Change .qza files to .qzv
for item in `ls 18-customized-barplots/*/visualization.qzv`; do

  name=`dirname $item | cut -d\/ -f2`
  mv $item 18-customized-barplots/$name.qzv
  rmdir `dirname $item`

done


conda deactivate
