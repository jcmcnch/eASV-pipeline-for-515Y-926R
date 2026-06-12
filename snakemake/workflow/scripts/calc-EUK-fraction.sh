#!/usr/bin/env bash

rm eukrunfile.sh 2> /dev/null
rm prokrunfile.sh 2> /dev/null

for item in `ls ${snakemake_input[splitdir]}/*prok*R1.fastq.gz | grep -vE "unknown|insilico"`; do 
	printf "zcat $item\n"

done > prokrunfile.sh

chmod u+x prokrunfile.sh
totalPROKseqs=`./prokrunfile.sh | grep -c "^@"`

for item in `ls ${snakemake_input[splitdir]}/*euk*R1.fastq.gz | grep -vE "unknown|insilico"`; do 

        printf "zcat $item\n"

done > eukrunfile.sh
chmod u+x eukrunfile.sh
totalEUKseqs=`./eukrunfile.sh | grep -c "^@"`

totalSeqs=$(python -c "print($totalEUKseqs + $totalPROKseqs)")
eukFrac=`bc <<< "scale=8; $totalEUKseqs/$totalSeqs"` 

printf "PROK_reads\tEUK_reads\n" >> ${snakemake_output[eukfracall]}
printf "$totalPROKseqs\t$totalEUKseqs\n" >> ${snakemake_output[eukfracall]}
#printf "The total run-specific EUK fraction is $eukFrac\n"

rm eukrunfile.sh
rm prokrunfile.sh
