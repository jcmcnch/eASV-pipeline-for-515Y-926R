#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

#loop handles corner case where no chloro seqs exist
if [ -s ${snakemake_input[includechloroseqs]} ] ; then

#Reclassify chloroplasts with PR2, as SILVA classifications will call algae lemon trees and whatnot
qiime feature-classifier classify-sklearn \
  --i-classifier ${snakemake_input[PR2classifier]} \
  --i-reads ${snakemake_input[includechloroseqs]} \
  --o-classification ${snakemake_output[PR2classifiedchloroseqs]}

else

#create dummy output (empty file) so snakemake doesn't freak
touch ${snakemake_output[PR2classifiedchloroseqs]}

fi

#loop handles corner case where no chloro seqs exist
if [ -s ${snakemake_input[includechloroseqs]} ] ; then

#Merge taxonomies (the first one takes precedence so the PR2 classifications will overwrite the SILVA IDs)
qiime feature-table merge-taxa \
  --i-data ${snakemake_output[PR2classifiedchloroseqs]} \
  --i-data ${snakemake_input[proktax]} \
  --o-merged-data ${snakemake_output[mergedclass]} 

else

#create dummy output (just SILVA tax) where no chloroplasts
cp ${snakemake_input[proktax]} ${snakemake_output[mergedclass]}

fi

#Filter out Chloroplasts from overall table
qiime taxa filter-table \
    --i-table ${snakemake_input[proktable]} \
    --i-taxonomy ${snakemake_input[proktax]} \
    --p-exclude "o__Chloroplast" \
    --o-filtered-table ${snakemake_output[nochlorotable]} || touch ${snakemake_output[nochlorotable]}

#Create Mitochondria table
qiime taxa filter-table \
   --i-table ${snakemake_input[proktable]} \
   --i-taxonomy ${snakemake_input[proktax]} \
   --p-include "f__Mitochondria" \
   --o-filtered-table ${snakemake_output[onlymitotable]} || touch ${snakemake_output[onlymitotable]}

#Create Algae-only table
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-include "p__Cyanobacteria" \
  --o-filtered-table ${snakemake_output[onlyalgaetable]} || touch ${snakemake_output[onlyalgaetable]}

#Create Chloroplast-free Cyanobacteria table
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-include "p__Cyanobacteria" \
  --p-exclude "o__Chloroplast" \
  --o-filtered-table ${snakemake_output[onlycyanotable]} || touch ${snakemake_output[onlycyanotable]}

#Create Mitochondria-free table
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-exclude "f__Mitochondria" \
  --o-filtered-table ${snakemake_output[nomitotable]} || touch ${snakemake_output[nomitotable]}

#Create Mitochondria and Chloroplast-free table
qiime taxa filter-table \
    --i-table ${snakemake_input[proktable]} \
    --i-taxonomy ${snakemake_input[proktax]} \
    --p-exclude "f__Mitochondria,o__Chloroplast" \
    --o-filtered-table ${snakemake_output[nomitonochlorotable]} || touch ${snakemake_output[nomitonochlorotable]}

#Create Mitochondria and Cyanobacteria/Chloroplast-free table
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-exclude "f__Mitochondria,p__Cyanobacteria" \
  --o-filtered-table ${snakemake_output[nomitonochloronocyanotable]} || touch ${snakemake_output[nomitonochloronocyanotable]}

#Create Archaea-only table
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-include "d__Archaea" \
  --o-filtered-table ${snakemake_output[onlyarchaeatable]} || touch ${snakemake_output[onlyarchaeatable]}

#Create Archaea-free table
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-exclude "d__Archaea" \
  --o-filtered-table ${snakemake_output[noarchaeatable]} || touch ${snakemake_output[noarchaeatable]} 
