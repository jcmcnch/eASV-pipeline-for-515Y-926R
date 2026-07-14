#!/usr/bin/env bash

sample=${snakemake_params[0]}
totalPROKseqs=`zgrep -c "^@" ${snakemake_input[prok]}`
totalEUKseqs=`zgrep -c "^@" ${snakemake_input[euk]}`

totalSeqs=$(python -c "print($totalEUKseqs + $totalPROKseqs)")
eukFrac=`bc <<< "scale=8; $totalEUKseqs/$totalSeqs"` 

printf "$sample\t$totalPROKseqs\t$totalEUKseqs\t$totalSeqs\t$eukFrac\n" >> ${snakemake_output[eukfrac]}
