#!/bin/bash -i

mkdir 16-exports

conda activate qiime2-2019.4

for item in `ls */*table.qza && ls */*/*table.qza`
	do
	if [ `basename $item` = "table.qza" ] ; then name="all-18S-seqs" ; else name=`basename $item .qza`; fi
	qiime tools export --input-path $item --output-path 16-exports/$name
	mv 16-exports/$name/feature-table.biom 16-exports/$name.biom
	rmdir 16-exports/$name
done

qiime tools export --input-path 11-classified/classification.qza --output-path 16-exports/taxonomy-SILVA132
mv 16-exports/taxonomy-SILVA132/taxonomy.tsv  16-exports/taxonomy-SILVA132.tsv ; rmdir 16-exports/taxonomy-SILVA132/

qiime tools export --input-path 15-subsetting/reclassified-PR2/classification.qza --output-path 16-exports/taxonomy-PR2
mv 16-exports/taxonomy-PR2/taxonomy.tsv  16-exports/taxonomy-PR2.tsv ; rmdir 16-exports/taxonomy-PR2/

sed -i '1c#OTUID	taxonomy	confidence' 16-exports/taxonomy-SILVA132.tsv
sed -i '1c#OTUID	taxonomy	confidence' 16-exports/taxonomy-PR2.tsv

#Tutorial here: https://forum.qiime2.org/t/exporting-and-modifying-biom-tables-e-g-adding-taxonomy-annotations/3630

for item in `ls 16-exports/all-18S-seqs.biom`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 16-exports/$filestem.with-SILVA132-tax.biom --observation-metadata-fp 16-exports/taxonomy-SILVA132.tsv --sc-separated taxonomy
	biom add-metadata -i $item -o 16-exports/$filestem.with-PR2-tax.biom --observation-metadata-fp 16-exports/taxonomy-PR2.tsv --sc-separated taxonomy
done

for item in `ls 16-exports/exclude*table.biom | grep "SILVA132"`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 16-exports/$filestem.with-tax.biom --observation-metadata-fp 16-exports/taxonomy-SILVA132.tsv --sc-separated taxonomy
done

for item in `ls 16-exports/exclude*table.biom | grep "PR2"`
	do
	filestem=`basename $item .biom`
	biom add-metadata -i $item -o 16-exports/$filestem.with-tax.biom --observation-metadata-fp 16-exports/taxonomy-PR2.tsv --sc-separated taxonomy
done

for item in `ls 16-exports/*.with*tax.biom`
	do
	filestem=`basename $item .biom`
	biom convert -i $item -o 16-exports/$filestem.tsv --to-tsv --header-key taxonomy
done

conda deactivate
