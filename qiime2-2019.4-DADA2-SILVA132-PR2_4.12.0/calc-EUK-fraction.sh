#!/bin/bash -i

rm eukrunfile.sh 2> /dev/null
rm prokrunfile.sh 2> /dev/null

for item in `ls 02-PROKs/00-fastq/*.SILVA_132_PROK.cdhit95pc_1.fastq | grep -vE "unknown|insilico"`; do 
	printf "cat $item\n"

done > prokrunfile.sh

chmod u+x prokrunfile.sh
totalPROKseqs=`./prokrunfile.sh | grep -c "^@"`

for item in `ls 02-EUKs/00-fastq/*EUK.cdhit95pc_1.fastq | grep -vE "unknown|insilico"`; do 

        printf "cat $item\n"

done > eukrunfile.sh
chmod u+x eukrunfile.sh
totalEUKseqs=`./eukrunfile.sh | grep -c "^@"`

totalSeqs=$(python -c "print($totalEUKseqs + $totalPROKseqs)")
eukFrac=`bc <<< "scale=8; $totalEUKseqs/$totalSeqs"` 
printf "There were $totalPROKseqs total PROK seqs.\n"
printf "There were $totalEUKseqs total EUK seqs.\n"
printf "The total run-specific EUK fraction is $eukFrac\n"

rm eukrunfile.sh
rm prokrunfile.sh
