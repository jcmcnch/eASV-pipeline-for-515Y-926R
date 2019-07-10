#!/bin/bash

mkdir 22-taxonomy-lookup-table

#Objective: Merging taxonomies from the Transformed to Proportions TSV files (in 20-exports/04-converted-biom-to-tsv aka E21 output)


#Part 1: Cut the first two columns (eASV ID and default (0.7) taxonomy) from the transformed to proportions default PR2 .tsv file.

cut -f1,2 20-exports/04-converted-biom-to-tsv/PR2/PR2-All-18S-seqs-default-p-confidence-converted-biom.proportions.tsv | sed '1s/taxonomy/taxonomy-PR2-default/' > 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv

# Part 2: Add the taxonomy from all the other PR2 proportion TSV files, not including the default. 

for item in `ls 20-exports/04-converted-biom-to-tsv/PR2/*proportions.tsv | grep -v "default"`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done

#Part 3: Add the taxonomy from all the other SILVA132 proportion TSV files, including the default. 

for item in `ls 20-exports/04-converted-biom-to-tsv/SILVA132/*proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv ; done

#Part 4: Add the remaining columns with sample information. 

cut -f3- 20-exports/04-converted-biom-to-tsv/PR2/PR2-All-18S-seqs-default-p-confidence-converted-biom.proportions.tsv | paste 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv - | sponge 22-taxonomy-lookup-table/All-18S-Lookup-Table.tsv
