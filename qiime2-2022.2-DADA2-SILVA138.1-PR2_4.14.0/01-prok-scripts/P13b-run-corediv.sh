#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

timestamp=`date +"%y%m%d-%H%M"`

read -r -p 'Please enter the minimum sampling depth for rarefaction >>> ' mindepth

#generated from samples-to-keep.tsv to remove low coverage samples
table=`ls 13-customized-barplots/subsetted-tables/*16S.table.qza.samples-to-keep.qza`

qiime diversity core-metrics --i-table $table \
       	--p-sampling-depth $mindepth \
	--m-metadata-file sample-metadata.tsv \
	--output-dir 13-core-diversity

for item in 13-core-diversity/* ; do

        mv $item 13-core-diversity/$timestamp.$studyName.16S.`basename $item`

done

conda deactivate
