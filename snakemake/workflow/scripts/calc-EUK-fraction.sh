#!/usr/bin/env bash

totalPROKseqs=`tail -n+2 ${snakemake_input[eukfracpersample]} | cut -f2 | paste -sd+ | bc`

totalEUKseqs=`tail -n+2 ${snakemake_input[eukfracpersample]} | cut -f3 | paste -sd+ | bc`

totalSeqs=$(python -c "print($totalEUKseqs + $totalPROKseqs)")
eukFrac=`bc <<< "scale=8; $totalEUKseqs/$totalSeqs"`

printf "PROK_reads\tEUK_reads\n" >> ${snakemake_output[eukfracall]}
printf "$totalPROKseqs\t$totalEUKseqs\n" >> ${snakemake_output[eukfracall]}
