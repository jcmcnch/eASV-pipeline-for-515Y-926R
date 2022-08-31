#!/bin/bash -i

for item in 02-PROKs/00-fastq/*.SILVA_132_PROK.cdhit95pc_1.fastq; do 

	filestem=`basename $item .SILVA_132_PROK.cdhit95pc_1.fastq`
	prokCount=`grep -c "^@" $item`
	eukCount=`grep -c "^@" 02-EUKs/00-fastq/$filestem.SILVA_132_and_PR2_EUK.cdhit95pc_1.fastq` 
	totalSeqs=$(python -c "print($eukCount + $prokCount)") 
	eukFrac=`bc <<< "scale=8; $eukCount/$totalSeqs"` 
	printf "$filestem\t$eukFrac\n"

done
