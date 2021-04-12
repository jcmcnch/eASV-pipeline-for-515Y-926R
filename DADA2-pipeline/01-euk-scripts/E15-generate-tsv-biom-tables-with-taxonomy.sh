#!/bin/bash -i

mkdir 15-exports

conda activate qiime2-2019.4

for item in `ls */*table.qza && ls */*/*table.qza`
	do
	if [ `basename $item` = "table.qza" ] ; then name="all-18S-seqs" ; else name=`basename $item .qza`; fi
	qiime tools export --input-path $item --output-path 15-exports/$name
	mv 15-exports/$name/feature-table.biom 15-exports/$name.biom
	rmdir 15-exports/$name
done

qiime tools export --input-path 10-classified/classification.qza --output-path 15-exports/taxonomy-SILVA138
mv 15-exports/taxonomy-SILVA138/taxonomy.tsv  15-exports/taxonomy-SILVA138.tsv ; rmdir 15-exports/taxonomy-SILVA138/

qiime tools export --input-path 14-subsetting/reclassified-PR2/classification.qza --output-path 15-exports/taxonomy-PR2
mv 15-exports/taxonomy-PR2/taxonomy.tsv  15-exports/taxonomy-PR2.tsv ; rmdir 15-exports/taxonomy-PR2/

sed -i '1c#OTUID	taxonomy	confidence' 15-exports/taxonomy-SILVA138.tsv
sed -i '1c#OTUID	taxonomy	confidence' 15-exports/taxonomy-PR2.tsv

#Tutorial here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630

for item in `ls 15-exports/all-18S-seqs.biom`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 15-exports/$filestem.with-SILVA138-tax.biom --observation-metadata-fp 15-exports/taxonomy-SILVA138.tsv --sc-separated taxonomy
	biom add-metadata -i $item -o 15-exports/$filestem.with-PR2-tax.biom --observation-metadata-fp 15-exports/taxonomy-PR2.tsv --sc-separated taxonomy
done

for item in `ls 15-exports/*clude*table.biom | grep "SILVA138"`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 15-exports/$filestem.with-tax.biom --observation-metadata-fp 15-exports/taxonomy-SILVA138.tsv --sc-separated taxonomy
done

for item in `ls 15-exports/*clude*table.biom | grep "PR2"`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 15-exports/$filestem.with-tax.biom --observation-metadata-fp 15-exports/taxonomy-PR2.tsv --sc-separated taxonomy
done

for item in `ls 15-exports/*.with*tax.biom`
	do
	filestem=`basename $item .biom`
	biom convert -i $item -o 15-exports/$filestem.tsv --to-tsv --header-key taxonomy
done

conda deactivate
