#!/bin/bash

mkdir exports

source activate qiime2-2018.8

for item in `ls */*table.qza`
	do
	name=`echo $item | cut -d\/ -f1`
	qiime tools export --input-path $item --output-path exports/$name
	mv exports/$name/feature-table.biom exports/$name.biom
	rmdir exports/$name
done

qiime tools export --input-path 10-classified/classification.qza --output-path exports/

sed -i '1c#OTUID	taxonomy	confidence' exports/taxonomy.tsv

#Tutorial here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630
for item in `ls exports/*biom`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o exports/$filestem.with-tax.biom --observation-metadata-fp exports/taxonomy.tsv --sc-separated taxonomy
done

for item in `ls exports/*.with-tax.biom`
	do
	filestem=`basename $item .biom`
	biom convert -i $item -o exports/$filestem.tsv --to-tsv --header-key taxonomy
done

source deactivate
