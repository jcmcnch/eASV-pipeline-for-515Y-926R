#!/bin/bash -i

mkdir -p 20-exports/02-taxonomy-tsv/PR2 
mkdir 20-exports/02-taxonomy-tsv/SILVA

mkdir -p 20-exports/03-biom-tables-with-tax/PR2
mkdir 20-exports/03-biom-tables-with-tax/SILVA

mkdir -p 20-exports/04-converted-biom-to-tsv/PR2
mkdir 20-exports/04-converted-biom-to-tsv/SILVA

source ../515FY-926R.cfg
conda activate $qiime2version

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

for item in `ls 19-reclassified/SILVA/*.qza`
        do
        filestem=`basename $item -classification.qza`
        qiime tools export --input-path $item --output-path 20-exports/02-taxonomy-tsv/SILVA
        sed -i '1c#OTUID\ttaxonomy\tconfidence' 20-exports/02-taxonomy-tsv/SILVA/taxonomy.tsv
        mv 20-exports/02-taxonomy-tsv/SILVA/taxonomy.tsv 20-exports/02-taxonomy-tsv/SILVA/$filestem\-taxonomy.tsv
done

#Part 2: Add the taxonomy.tsv information as "metadata" to the .biom table.

for item in `ls 20-exports/02-taxonomy-tsv/SILVA/*.tsv`
        do
        filestem=`basename $item .tsv`
        biom add-metadata -i 20-exports/01-biom-table/All-18S-table.biom -o 20-exports/03-biom-tables-with-tax/SILVA/$filestem.biom --observation-metadata-fp $item --sc-separated taxonomy
done

#Part 3: Convert the final .biom table into a .tsv file.

for item in `ls 20-exports/03-biom-tables-with-tax/SILVA/*.biom`
        do
        filestem=`basename $item -taxonomy.biom`
        biom convert -i $item -o 20-exports/04-converted-biom-to-tsv/SILVA/$filestem\-converted-biom.tsv --to-tsv --header-key taxonomy
done

conda deactivate
