#!/bin/bash -i

mkdir logs
mkdir logs/03-bbduk

conda activate bbmap-env

trimleft=$1
trimright=$2

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter your desired trim length on the left (R1) read. e.g. E03-bbduk-cut-reads.sh 210 <right trim length>'
    exit 0
fi

if [[ ${#2} -eq 0 ]] ; then
    echo 'Please enter your desired trim length on the right (R2) read. e.g. E03-bbduk-cut-reads.sh <left trim length> 170'
    exit 0
fi

echo "forward trim length = $trimleft bp" > trim_lengths.txt
echo "reverse trim length = $trimright bp" >> trim_lengths.txt

#slice and dice

for item in `ls 00-fastq/*.trimmed.SILVA_132_and_PR2_EUK.cdhit95pc_1.fastq`

	do

	indir="00-fastq"
	outdir="03-size-selected"

	filestem=`basename $item .trimmed.SILVA_132_and_PR2_EUK.cdhit95pc_1.fastq`

	R1in=$filestem.trimmed.SILVA_132_and_PR2_EUK.cdhit95pc_1.fastq
	R2in=$filestem.trimmed.SILVA_132_and_PR2_EUK.cdhit95pc_2.fastq

	bbduk.sh in=$indir/$R1in out=$outdir/`basename $R1in .fastq`.trimmed.fastq \
	minlength=$trimleft forcetrimright=$(($trimleft - 1)) 2>&1 | tee -a logs/03-bbduk/R1-bbduk.log
	bbduk.sh in=$indir/$R2in out=$outdir/`basename $R2in .fastq`.trimmed.fastq \
        minlength=$trimright forcetrimright=$(($trimright - 1)) 2>&1 | tee -a logs/03-bbduk/R2-bbduk.log

done

#stitch and fix

for item in `ls 03-size-selected/*1.trimmed.fastq`

	do

	filestem=`basename $item 1.trimmed.fastq`
	R1in=${filestem}1.trimmed.fastq
	R2in=${filestem}2.trimmed.fastq
	R1out=${filestem}repaired.1.fastq
	R2out=${filestem}repaired.2.fastq
	path="03-size-selected"

	repair.sh in=$path/$R1in in2=$path/$R2in out=$path/$R1out out2=$path/$R2out

done

#overwrite the old files with the repaired ones

for item in `ls 03-size-selected/*repaired.1.fastq`

	do

	path="03-size-selected"

	filestem=`basename $item repaired.1.fastq`
	
	repairedR1=${filestem}repaired.1.fastq
	repairedR2=${filestem}repaired.2.fastq

	R1=${filestem}1.trimmed.fastq
	R2=${filestem}2.trimmed.fastq

	mv $path/$repairedR1 $path/$R1
	mv $path/$repairedR2 $path/$R2
	
done

conda deactivate
