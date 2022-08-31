#!/bin/bash -i

mkdir 22-taxonomy-lookup-table

#Objective: Merging taxonomies from the Transformed to Proportions TSV files (in 20-exports/04-converted-biom-to-tsv aka E21 output)


#Part 1: Cut the first two columns (eASV ID and default (0.7) taxonomy) from the transformed to proportions default PR2 .tsv file.

cut -f1,2 15-exports/all-18S-seqs.with-PR2-tax.proportions.tsv | sed '1s/taxonomy/taxonomy-PR2-default-point7/' > 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv

# Part 2: Add the taxonomy from all the other PR2 proportion TSV files, not including the default. 

for item in `ls 20-exports/04-converted-biom-to-tsv/PR2/*point5-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done

for item in `ls 20-exports/04-converted-biom-to-tsv/PR2/*point3-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done


for item in `ls 20-exports/04-converted-biom-to-tsv/PR2/*minus1-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done


#Part 3: Add the taxonomy from all the other SILVA138 proportion TSV files, including the default. 

for item in `ls 15-exports/*all-18S-seqs.with-SILVA138-tax.proportions.tsv`; do confidence=`basename $item | cut -d\- -f4` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-${confidence}-default-point7/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done

for item in `ls 20-exports/04-converted-biom-to-tsv/SILVA138/*point5-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done


for item in `ls 20-exports/04-converted-biom-to-tsv/SILVA138/*point3-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done

for item in `ls 20-exports/04-converted-biom-to-tsv/SILVA138/*minus1-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done

#Part 4: Add the remaining columns with sample information. 

cut -f3- 15-exports/all-18S-seqs.with-PR2-tax.proportions.tsv | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv
