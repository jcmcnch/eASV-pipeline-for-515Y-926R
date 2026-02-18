#!/bin/bash -i
conda activate blast-env

mkdir -p blast-results

query=asv_fasta/251015-1510.AMT30-DNA.16S.dna-sequences.fasta

for item in intstd_fastas/*fasta ; do

	#blast results
	outname=blast-results/`basename $item .fasta`.asvs.outfmt6.tsv
	#hashes for input into correction script
	outhash=blast-results/`basename $item .fasta`.asvs.txt

	#require 100% coverage, 99% ID which gives 1-2 mismatches for our amplicon region (515Y/926R), probably will work for most cases
	blastn -query $query -db $item -outfmt 6 -perc_identity 99 -qcov_hsp_perc 100 > $outname
	cut -f1 $outname > $outhash

done
