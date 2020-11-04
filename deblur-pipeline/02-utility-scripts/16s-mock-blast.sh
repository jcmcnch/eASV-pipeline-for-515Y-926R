#!/bin/bash -i

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a query fasta file as the second argument (after this scripts name).'
    exit 0
fi

if [[ ${#2} -eq 0 ]] ; then
    echo 'Please enter an output file name for your BLAST results (will be tsv-formatted) as the third argument.'
    exit 0
fi


blastn -qcov_hsp_perc 100 -outfmt 6 -query $1 -db /home/db/in-silico-mocks/BLAST-db/16s/mocks_all_non-redundant-renamed-ref.fasta > $2

cat /home/db/other/outfmt6-headers | cat - $2 > temp && mv temp $2
