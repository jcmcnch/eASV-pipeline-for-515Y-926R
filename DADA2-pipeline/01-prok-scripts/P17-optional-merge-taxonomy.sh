#!/bin/bash

mkdir 17-taxonomy-lookup-table
mkdir 17-taxonomy-lookup-table/chloroplasts
mkdir 17-taxonomy-lookup-table/non-chloroplasts

#Part A: Merging taxonomies from the Transformed to Proportions TSV files (in 15-exports/ aka P16 output) 

#Chloroplasts 

#Part 1: Cut the first two columns (OTU ID and default (0.7) taxonomy) from the transformed to proportions .tsv file.
cut -f1,2 15-exports/04-converted-biom-to-tsv/chloroplasts/PhytoRef-chloroplast-default-p-confidence-converted-biom.proportions.tsv | sed '1s/taxonomy/taxonomy-default-point7/' > 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv

# Part 2: Add the taxonomy from all the other TSV files, not including the default. 
for item in `ls 15-exports/04-converted-biom-to-tsv/chloroplasts/*proportions.tsv | grep -v "default"`; do confidence=`basename $item | cut -d\- -f1,3` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv ; done

#Part 3: Add the remaining columns with sample information. 
cut -f3- 15-exports/04-converted-biom-to-tsv/chloroplasts/PhytoRef-chloroplast-default-p-confidence-converted-biom.proportions.tsv | sed '1s/taxonomy/taxonomy-default-point7/' | paste 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv


#Non-Chloroplasts

#Part 1:  Cut the first columns (OTU ID) from the transformed to proportions SILVA132 .tsv file (an arbituary choice, just want the OTU ID).
cut -f1 15-exports/04-converted-biom-to-tsv/non-chloroplasts/SILVA132-non-chloroplast-default-p-confidence-converted-biom.proportions.tsv > 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv

#Part 2: Add the taxonomy from all the proportion TSV files.
for item in `ls 15-exports/04-converted-biom-to-tsv/non-chloroplasts/*proportions.tsv` ; do confidence=`basename $item | cut -d\- -f1,4` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv ; done

#Part 3: Add the remaining columns with sample information.
cut -f3- 15-exports/04-converted-biom-to-tsv/non-chloroplasts/SILVA132-non-chloroplast-default-p-confidence-converted-biom.proportions.tsv | paste 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv

