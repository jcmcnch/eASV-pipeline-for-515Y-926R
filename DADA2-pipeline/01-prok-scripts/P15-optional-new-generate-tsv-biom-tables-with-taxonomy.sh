#!/bin/bash -i

mkdir 15-exports
mkdir 15-exports/02-taxonomy-tsv
mkdir 15-exports/02-taxonomy-tsv/non-chloroplasts
mkdir 15-exports/02-taxonomy-tsv/chloroplasts

mkdir 15-exports/03-biom-tables-with-tax/
mkdir 15-exports/03-biom-tables-with-tax/non-chloroplasts
mkdir 15-exports/03-biom-tables-with-tax/chloroplasts

mkdir 15-exports/04-converted-biom-to-tsv
mkdir 15-exports/04-converted-biom-to-tsv/non-chloroplasts
mkdir 15-exports/04-converted-biom-to-tsv/chloroplasts

conda activate qiime2-2019.4 

############
#Part A: Non-chloroplasts

#Part 1: Convert the exclude-chloroplasts filtered table into a .biom table  

qiime tools export --input-path 09-subsetting/split-tables/exclude_D_3__Chloroplast_filtered_table.qza --output-path 15-exports/01-biom-tables

mv 15-exports/01-biom-tables/feature-table.biom 15-exports/01-biom-tables/exclude_D_3__Chloroplast_filtered_table.biom
 

#Part 2: Convert classification.qza files (14-reclassfied directory) to taxonomy.tsv files. Then, use sed to add "#OTUID taxonomy confidence" to the taxonomy.tsv files as headers. 

for item in `ls 14-reclassified/non-chloroplasts/*.qza`
	do
	filestem=`basename $item -classification.qza`
	qiime tools export --input-path $item --output-path 15-exports/02-taxonomy-tsv/non-chloroplasts/
	sed -i '1c#OTUID\ttaxonomy\tconfidence' 15-exports/02-taxonomy-tsv/non-chloroplasts/taxonomy.tsv
	mv 15-exports/02-taxonomy-tsv/non-chloroplasts/taxonomy.tsv 15-exports/02-taxonomy-tsv/non-chloroplasts/$filestem\-taxonomy.tsv
done
	
#Part 3: Add the taxonomy.tsv information as "metadata" to the .biom tables

for item in `ls 15-exports/02-taxonomy-tsv/non-chloroplasts/*.tsv`
        do
        filestem=`basename $item .tsv`
        biom add-metadata -i 15-exports/01-biom-tables/exclude_D_3__Chloroplast_filtered_table.biom -o 15-exports/03-biom-tables-with-tax/non-chloroplasts/$filestem.biom --observation-metadata-fp $item --sc-separated taxonomy
done 

#Part 4: Convert the final (taxonomy with metadata) .biom table into a .tsv file. 

for item in `ls 15-exports/03-biom-tables-with-tax/non-chloroplasts/*.biom`
	do
	filestem=`basename $item -taxonomy.biom`
	biom convert -i $item -o 15-exports/04-converted-biom-to-tsv/non-chloroplasts/$filestem\-converted-biom.tsv --to-tsv --header-key taxonomy
done

################
#Part B: Chloroplasts

#Part 1: Convert the chloroplasts-ONLY filtered table into a .biom table

qiime tools export --input-path 09-subsetting/split-tables/include_D_3__Chloroplast_filtered_table.qza --output-path 15-exports/01-biom-tables

mv 15-exports/01-biom-tables/feature-table.biom 15-exports/01-biom-tables/include_D_3__Chloroplast_filtered_table.biom

#Part 2: Convert classification.qza files (14-reclassfied directory) to taxonomy.tsv files. Then, use sed to add "#OTUID taxonomy confidence" to the taxonomy.tsv files as headers.

for item in `ls 14-reclassified/chloroplasts/*.qza`
        do
        filestem=`basename $item -classification.qza`
        qiime tools export --input-path $item --output-path 15-exports/02-taxonomy-tsv/chloroplasts/
        sed -i '1c#OTUID\ttaxonomy\tconfidence' 15-exports/02-taxonomy-tsv/chloroplasts/taxonomy.tsv
        mv 15-exports/02-taxonomy-tsv/chloroplasts/taxonomy.tsv 15-exports/02-taxonomy-tsv/chloroplasts/$filestem\-taxonomy.tsv
done

#Part 3: Add the taxonomy.tsv information as "metadata" to the .biom tables

for item in `ls 15-exports/02-taxonomy-tsv/chloroplasts/*.tsv`
        do
        filestem=`basename $item .tsv`
        biom add-metadata -i 15-exports/01-biom-tables/include_D_3__Chloroplast_filtered_table.biom -o 15-exports/03-biom-tables-with-tax/chloroplasts/$filestem.biom --observation-metadata-fp $item --sc-separated taxonomy
done

#Part 4: Convert the final (taxonomy with metadata) .biom table into a .tsv file.

for item in `ls 15-exports/03-biom-tables-with-tax/chloroplasts/*.biom`
        do
        filestem=`basename $item -taxonomy.biom`
        biom convert -i $item -o 15-exports/04-converted-biom-to-tsv/chloroplasts/$filestem\-converted-biom.tsv --to-tsv --header-key taxonomy
done

conda deactivate
