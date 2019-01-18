#!/bin/bash

table=$1
taxon=$2

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a table to split.'
    exit 0
fi

if [[ ${#2} -eq 0 ]] ; then
    echo 'Please enter a taxonomic name to sort by. e.g. Chloroplast or Metazoa (Animalia). Make sure to put quotes around names with spaces.'
    exit 0
fi

source activate qiime2-2018.8

qiime taxa filter-table \
        --i-table $table \
        --i-taxonomy 05-classifications/classification.qza \
        --p-include $taxon \
        --output-dir ${table}_${taxon}-subset

source deactivate
