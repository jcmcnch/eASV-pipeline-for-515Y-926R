#!/bin/bash -i

mkdir 17-taxonomy-lookup-table
mkdir 17-taxonomy-lookup-table/chloroplasts
mkdir 17-taxonomy-lookup-table/non-chloroplasts

#Part A: Merging taxonomies from the Transformed to Proportions TSV files (in 10-exports for default-0.7 and 15-exports (0.5, 0.3, -1 aka P16 output) 

#Chloroplasts 

#Part 1: Cut the first two columns (eASV ID and default (0.7) taxonomy) from the transformed to proportions PHYTOREF .tsv file.
cut -f1,2 10-exports/include_D_3__Chloroplast_filtered_table.with-tax.proportions.tsv | sed '1s/taxonomy/taxonomy-PhytoRef-default-point7/' > 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv

# Part 2: Add the taxonomy from all the other proportion TSV files, not including the default. 
for item in `ls 15-exports/04-converted-biom-to-tsv/chloroplasts/*point5-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,3` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv ; done

for item in `ls 15-exports/04-converted-biom-to-tsv/chloroplasts/*point3-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,3` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv ; done

for item in `ls 15-exports/04-converted-biom-to-tsv/chloroplasts/*minus1-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,3` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv ; done

#Part 3: Add the remaining columns with sample information. 

cut -f3- 10-exports/include_D_3__Chloroplast_filtered_table.with-tax.proportions.tsv | paste 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/chloroplasts/Chloroplasts-Lookup-Table.tsv


#Non-Chloroplasts

#Part 1:  Cut the first column two columns (eASV ID and default (0.7) taxonomy) from the transformed to proportions SILVA138 .tsv file.
cut -f1,2 10-exports/exclude_D_3__Chloroplast_filtered_table.with-tax.proportions.tsv | sed '1s/taxonomy/taxonomy-SILVA138-default-point7/' > 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv

#Part 2: Add the taxonomy from all other proportion TSV files, not including the default.
for item in `ls 15-exports/04-converted-biom-to-tsv/non-chloroplasts/*point5-p-confidence-converted-biom.proportions.tsv` ; do confidence=`basename $item | cut -d\- -f1,4` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv ; done

for item in `ls 15-exports/04-converted-biom-to-tsv/non-chloroplasts/*point3-p-confidence-converted-biom.proportions.tsv` ; do confidence=`basename $item | cut -d\- -f1,4` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv ; done

for item in `ls 15-exports/04-converted-biom-to-tsv/non-chloroplasts/*minus1-p-confidence-converted-biom.proportions.tsv` ; do confidence=`basename $item | cut -d\- -f1,4` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv ; done

#Part 3: Add the remaining columns with sample information.
cut -f3- 10-exports/exclude_D_3__Chloroplast_filtered_table.with-tax.proportions.tsv | paste 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv - | sponge 17-taxonomy-lookup-table/non-chloroplasts/Non-Chloroplasts-Lookup-Table.tsv
