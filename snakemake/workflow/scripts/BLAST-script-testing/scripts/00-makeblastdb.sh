#!/bin/bash -i
conda activate blast-env

for item in intstd_fastas/*fasta ; do
	
	makeblastdb -dbtype nucl -in $item

done
