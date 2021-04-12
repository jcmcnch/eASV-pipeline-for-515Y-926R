#!/bin/bash -i

mkdir 20-exports
mkdir 20-exports/02-taxonomy-tsv
mkdir 20-exports/02-taxonomy-tsv/PR2
mkdir 20-exports/02-taxonomy-tsv/SILVA138

mkdir 20-exports/03-biom-tables-with-tax/
mkdir 20-exports/03-biom-tables-with-tax/PR2
mkdir 20-exports/03-biom-tables-with-tax/SILVA138

mkdir 20-exports/04-converted-biom-to-tsv
mkdir 20-exports/04-converted-biom-to-tsv/PR2
mkdir 20-exports/04-converted-biom-to-tsv/SILVA138

conda activate qiime2-2019.4

#####Part A: Convert the all 18S table.qza into a .biom table

qiime tools export --input-path 08-DADA2d/table.qza --output-path 20-exports/01-biom-table 

mv 20-exports/01-biom-table/feature-table.biom 20-exports/01-biom-table/All-18S-table.biom

#####Part B: PR2

#Part 1: Convert classification.qza files (19-reclassified directory) to taxonomy.tsv files. Then, use sed to add "#OTUID taxonomy confidence" to the taxonomy.tsv files as headers. 

for item in `ls 19-reclassified/PR2/*.qza`
	do
	filestem=`basename $item -classification.qza`
	qiime tools export --input-path $item --output-path 20-exports/02-taxonomy-tsv/PR2
	sed -i '1c#OTUID\ttaxonomy\tconfidence' 20-exports/02-taxonomy-tsv/PR2/taxonomy.tsv
	mv 20-exports/02-taxonomy-tsv/PR2/taxonomy.tsv 20-exports/02-taxonomy-tsv/PR2/$filestem\-taxonomy.tsv
done

#Part 2: Add the taxonomy.tsv information as "metadata" to the .biom table.

for item in `ls 20-exports/02-taxonomy-tsv/PR2/*.tsv`
	do
	filestem=`basename $item .tsv`
	biom add-metadata -i 20-exports/01-biom-table/All-18S-table.biom -o 20-exports/03-biom-tables-with-tax/PR2/$filestem.biom --observation-metadata-fp $item --sc-separated taxonomy
done

#Part 3: Convert the final .biom table into a .tsv file.

for item in `ls 20-exports/03-biom-tables-with-tax/PR2/*.biom`
	do 
	filestem=`basename $item -taxonomy.biom`
	biom convert -i $item -o 20-exports/04-converted-biom-to-tsv/PR2/$filestem\-converted-biom.tsv --to-tsv --header-key taxonomy
done


#####Part C: SILVA 138

#Part 1: Convert classification.qza files (19-reclassified directory) to taxonomy.tsv files. Then, use sed to add "#OTUID taxonomy confidence" to the taxonomy.tsv files as headers.

for item in `ls 19-reclassified/SILVA138/*.qza`
        do
        filestem=`basename $item -classification.qza`
        qiime tools export --input-path $item --output-path 20-exports/02-taxonomy-tsv/SILVA138
        sed -i '1c#OTUID\ttaxonomy\tconfidence' 20-exports/02-taxonomy-tsv/SILVA138/taxonomy.tsv
        mv 20-exports/02-taxonomy-tsv/SILVA138/taxonomy.tsv 20-exports/02-taxonomy-tsv/SILVA138/$filestem\-taxonomy.tsv
done

#Part 2: Add the taxonomy.tsv information as "metadata" to the .biom table.

for item in `ls 20-exports/02-taxonomy-tsv/SILVA138/*.tsv`
        do
        filestem=`basename $item .tsv`
        biom add-metadata -i 20-exports/01-biom-table/All-18S-table.biom -o 20-exports/03-biom-tables-with-tax/SILVA138/$filestem.biom --observation-metadata-fp $item --sc-separated taxonomy
done

#Part 3: Convert the final .biom table into a .tsv file.

for item in `ls 20-exports/03-biom-tables-with-tax/SILVA138/*.biom`
        do
        filestem=`basename $item -taxonomy.biom`
        biom convert -i $item -o 20-exports/04-converted-biom-to-tsv/SILVA138/$filestem\-converted-biom.tsv --to-tsv --header-key taxonomy
done

conda deactivate
