#!/bin/bash -i

#Automated script for adding Proportal classifications to an ASV table

#clone into external repo
git clone git@github.com:jcmcnch/ProPortal-ASV-Annotation.git
mkdir -p ProPortal-intermediates

#get ASV table names
counts=`ls 04-Formatted/*counts.QCd.tsv`
proportions=`ls 04-Formatted/*proportions.QCd.tsv`

#get DNA sequence file name for denoised 16S
dnaseqs=`ls 02-PROKs/03-DADA2d/*dna-sequences.fasta`

#get ASV ids from denoised data
grep "Synechococcales" $counts | cut -f1 > ProPortal-intermediates/Synechococcales.ids
seqtk subseq $dnaseqs ProPortal-intermediates/Synechococcales.ids > ProPortal-intermediates/Synechococcales.fasta

#enter repo
cd ProPortal-ASV-Annotation
cp ../ProPortal-intermediates/Synechococcales.fasta ASVs-2-classify
./scripts/07-blast-all-datasets.sh
./scripts/08-classify-ASVs-with-ProPortal.py blast-results/Synechococcales.blastout.tsv > ../ProPortal-intermediates/Synechococcales.Proportal-classified.tsv

#add into ASV table as additional taxonomy column after SILVA/PR2 taxonomy
./scripts/09-add-Proportal-to-TSV-table.py ../ProPortal-intermediates/Synechococcales.Proportal-classified.tsv ../$counts > ../04-Formatted/`basename $counts .tsv`.ProPortal.tsv

./scripts/09-add-Proportal-to-TSV-table.py ../ProPortal-intermediates/Synechococcales.Proportal-classified.tsv ../$proportions > ../04-Formatted/`basename $proportions .tsv`.ProPortal.tsv
