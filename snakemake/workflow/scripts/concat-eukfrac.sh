#!/usr/bin/env bash

if [ -s ${snakemake_output[eukfracall]} ] ; then

#if not empty, fill lines
cat ${snakemake_input[eukfrac]} >> ${snakemake_output[eukfracall]}

else

#if file empty, add header
printf "sample\tprok_seqs_split\teuk_seqs_split\ttotal_seqs_split\teukfrac_split\n" >>  ${snakemake_output[eukfracall]}
cat ${snakemake_input[eukfrac]} >> ${snakemake_output[eukfracall]}

fi
