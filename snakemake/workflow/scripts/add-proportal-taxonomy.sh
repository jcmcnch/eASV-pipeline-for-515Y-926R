#!/usr/bin/env bash

#Automated script for adding Proportal classifications to an ASV table

#clone into external repo
git clone https://github.com/jcmcnch/ProPortal-ASV-Annotation.git workflow/scripts/ProPortal-ASV-Annotation
intermediatedir=workflow/scripts/ProPortal-ASV-Annotation/ProPortal-intermediates
mkdir -p $intermediatedir

#get ASV table names
counts=${snakemake_input[proktable]}

#get DNA sequence file name for denoised 16S
dnaseqs=${snakemake_input[dnaseqs]}

#get ASV ids from denoised data
grep "Synechococcales" $counts | cut -f1 > $intermediatedir/Synechococcales.ids
seqtk subseq $dnaseqs $intermediatedir/Synechococcales.ids > $intermediatedir/Synechococcales.fasta

#enter repo
cp $intermediatedir/Synechococcales.fasta workflow/scripts/ProPortal-ASV-Annotation/ASVs-2-classify
cd workflow/scripts/ProPortal-ASV-Annotation
blastn -query ASVs-2-classify/Synechococcales.fasta -db blast-db/220123.ProPortal16Sdb.fasta -outfmt 6 -perc_identity 100 -qcov_hsp_perc 100 > blast-results/Synechococcales.blastout.tsv 
./scripts/08-classify-ASVs-with-ProPortal.py blast-results/Synechococcales.blastout.tsv > ../../../${snakemake_output[taxonomy]}
