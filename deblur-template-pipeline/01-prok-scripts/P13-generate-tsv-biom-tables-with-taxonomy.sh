#!/bin/bash -i

mkdir 13-exports

conda activate qiime2-2019.4

for item in `ls */*table.qza && ls */*/*table.qza`
	do
	if [ `basename $item` = "table.qza" ] ; then name="all-16S-seqs" ; else name=`basename $item .qza`; fi
	qiime tools export --input-path $item --output-path 13-exports/$name
	mv 13-exports/$name/feature-table.biom 13-exports/$name.biom
	rmdir 13-exports/$name
done

qiime tools export --input-path 12-subsetting/tax-merged/chloroplasts-PhytoRef-reclassified-merged-classification.qza --output-path 13-exports/

sed -i '1c#OTUID	taxonomy	confidence' 13-exports/taxonomy.tsv

#Tutorial here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630
for item in `ls 13-exports/*biom`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 13-exports/$filestem.with-tax.biom --observation-metadata-fp 13-exports/taxonomy.tsv --sc-separated taxonomy
done

for item in `ls 13-exports/*.with-tax.biom`
	do
	filestem=`basename $item .biom`
	biom convert -i $item -o 13-exports/$filestem.tsv --to-tsv --header-key taxonomy
done

conda deactivate
