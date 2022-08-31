#!/bin/bash -i

mkdir -p 04-Formatted

mergedNorm=`ls 03-Merged/*normalized*tsv`
mergedProp=`ls 03-Merged/*proportions.tsv`
filestem=`basename $mergedNorm _normalized_sequence_counts.tsv`
#user provides these
mergedNormLastColumn=242
mergedPropLastColumn=242
#to remove blanks, controls, station 02 that lacks any metadata
mergedNormFirstSample=43
mergedPropFirstSample=43
#calculate second last
mergedNormSecondLast=$((mergedNormLastColumn-1))
mergedPropSecondLast=$((mergedPropLastColumn-1))

#rearrange columns to put taxonomy at beginning
cut -f1,$mergedNormLastColumn $mergedNorm > 04-Formatted/tmp1
cut -f$mergedNormFirstSample-$mergedNormSecondLast $mergedNorm > 04-Formatted/tmp2
paste 04-Formatted/tmp1 04-Formatted/tmp2 > 04-Formatted/${filestem}_normalized_sequence_counts_reordered.tsv
rm 04-Formatted/tmp* 2> /dev/null

#same but for proportions file
cut -f1,$mergedPropLastColumn $mergedProp > 04-Formatted/tmp1
cut -f$mergedPropFirstSample-$mergedPropSecondLast $mergedProp > 04-Formatted/tmp2
paste 04-Formatted/tmp1 04-Formatted/tmp2 > 04-Formatted/${filestem}_proportions_reordered.tsv
rm 04-Formatted/tmp* 2> /dev/null

conda activate opedia-env

#ahead of time, create file to specify which samples have <5000 QC'd sequences for the 16S fraction, e.g.
#touch lt5000seq-samples.txt
#then edit manually to add in appropriate sample IDs

#remove empty rows with pandas, passing empty-file as sys.argv[1]
./eASV-pipeline-for-515Y-926R/DADA2-pipeline/02-utility-scripts/remove-bad-columns-and-empty-rows.py lt5000seq-samples.txt 04-Formatted/${filestem}_normalized_sequence_counts_reordered.tsv 04-Formatted/${filestem}_normalized_sequence_counts_reordered.empty-rows-removed.tsv

./eASV-pipeline-for-515Y-926R/DADA2-pipeline/02-utility-scripts/remove-bad-columns-and-empty-rows.py lt5000seq-samples.txt 04-Formatted/${filestem}_proportions_reordered.tsv 04-Formatted/${filestem}_proportions_reordered.empty-rows-removed.tsv

