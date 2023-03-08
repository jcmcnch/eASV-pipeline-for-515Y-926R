#!/bin/bash -i

mkdir -p 22-taxonomy-lookup-table

#Objective: Merging taxonomies from the Transformed to Proportions TSV files (in 20-exports/04-converted-biom-to-tsv aka E21 output)

#Part 1: Cut the first two columns (eASV ID and default (0.7) taxonomy) from the transformed to proportions default PR2 .tsv file.

PR2export=`ls 15-exports/*all-18S-seqs.with-PR2-tax.proportions.tsv`
PR2output=`basename $PR2export | sed 's/.tsv/.multiple-taxonomy-confidences.tsv/'`

tail -n+2 $PR2export | cut -f1,2 | sed '1s/taxonomy/taxonomy-PR2-default-point7/' > 22-taxonomy-lookup-table/$PR2output

# Part 2: Add the taxonomy from all the other PR2 proportion TSV files, not including the default. 

for item in `ls 20-exports/04-converted-biom-to-tsv/PR2/*point5-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/$PR2output - | sponge 22-taxonomy-lookup-table/$PR2output ; done

for item in `ls 20-exports/04-converted-biom-to-tsv/PR2/*point3-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/$PR2output - | sponge 22-taxonomy-lookup-table/$PR2output ; done


for item in `ls 20-exports/04-converted-biom-to-tsv/PR2/*disable-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/$PR2output - | sponge 22-taxonomy-lookup-table/$PR2output ; done


#Part 3: Add the taxonomy from all the other SILVA proportion TSV files, including the default. 

SILVAexport=`ls 15-exports/*all-18S-seqs.with-SILVA-tax.proportions.tsv`
SILVAoutput=`basename $SILVAexport | sed 's/.tsv/.multiple-taxonomy-confidences.tsv/'`

tail -n+2 $SILVAexport | cut -f1,2 | sed '1s/taxonomy/taxonomy-SILVA-default-point7/' > 22-taxonomy-lookup-table/$SILVAoutput

#for item in $SILVAexport; do confidence=`basename $item | cut -d\- -f4` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-${confidence}-default-point7/" | paste 22-taxonomy-lookup-table/$SILVAoutput - | sponge 22-taxonomy-lookup-table/$SILVAoutput ; done

for item in `ls 20-exports/04-converted-biom-to-tsv/SILVA/*point5-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/$SILVAoutput - | sponge 22-taxonomy-lookup-table/$SILVAoutput ; done

for item in `ls 20-exports/04-converted-biom-to-tsv/SILVA/*point3-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/$SILVAoutput - | sponge 22-taxonomy-lookup-table/$SILVAoutput ; done

for item in `ls 20-exports/04-converted-biom-to-tsv/SILVA/*disable-p-confidence-converted-biom.proportions.tsv`; do confidence=`basename $item | cut -d\- -f1,5` &&  cut -f2 $item | sed "1s/taxonomy/taxonomy-$confidence/" | paste 22-taxonomy-lookup-table/$SILVAoutput - | sponge 22-taxonomy-lookup-table/$SILVAoutput ; done

#Part 4: Add the remaining columns with sample information. 

tail -n+2 $PR2export | cut -f3- | paste 22-taxonomy-lookup-table/$PR2output - | sponge 22-taxonomy-lookup-table/$PR2output

tail -n+2 $SILVAexport | cut -f3- | paste 22-taxonomy-lookup-table/$SILVAoutput - | sponge 22-taxonomy-lookup-table/$SILVAoutput
