#!/bin/bash -i
source ../515FY-926R.cfg
conda activate $qiime2version

timestamp=`date +"%y%m%d-%H%M"`

mkdir 10-exports

for item in `ls */*table.qza && ls */*/*table.qza`
	do
	if [ `basename $item` = "table.qza" ] ; then name="all-16S-seqs" ; else name=`basename $item .qza`; fi
	qiime tools export --input-path $item --output-path 10-exports/$name
	mv 10-exports/$name/feature-table.biom 10-exports/$name.biom
	rmdir 10-exports/$name
done

qiime tools export --input-path 09-subsetting/tax-merged/chloroplasts-PR2-reclassified-merged-classification.qza --output-path 10-exports/

sed -i '1c#OTUID	taxonomy	confidence' 10-exports/taxonomy.tsv

#Tutorial here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630
for item in `ls 10-exports/*biom`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 10-exports/$filestem.with-tax.biom --observation-metadata-fp 10-exports/taxonomy.tsv --sc-separated taxonomy
done

for item in `ls 10-exports/*.with-tax.biom`
	do
	filestem=`basename $item .biom`
	biom convert -i $item -o 10-exports/$filestem.tsv --to-tsv --header-key taxonomy
done

for item in 10-exports/* ; do

        mv $item 10-exports/$timestamp.$studyName.16S.`basename $item`

done

conda deactivate
