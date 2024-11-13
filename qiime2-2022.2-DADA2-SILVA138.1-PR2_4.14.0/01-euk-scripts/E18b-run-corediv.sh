#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

timestamp=`date +"%y%m%d-%H%M"`

read -r -p 'Please enter the minimum sampling depth for rarefaction >>> ' mindepth

#generated from samples-to-keep.tsv to remove low coverage samples
table=`ls 18-customized-barplots/subsetted-tables/*18S.table.qza.samples-to-keep.qza`

qiime diversity core-metrics --i-table $table \
       	--p-sampling-depth $mindepth \
	--m-metadata-file sample-metadata.tsv \
	--output-dir 18-core-diversity

for item in 18-core-diversity/* ; do

        mv $item 18-core-diversity/$timestamp.$studyName.18S.`basename $item`

done

conda deactivate
