#!/bin/bash -i
#activate conda env specified in Colette's repo
conda activate r-optparse-env

#get variables
source 515FY-926R.cfg
timestamp=`date +"%y%m%d-%H%M"`

### 2022-10-05: The sed regex replacement is no longer needed since PR2 update includes this by default in their taxonomy strings as ":plas" ###

#Change taxonomy string to clarify these sequences are derived from Eukaryotes but represent 16S rRNA instead of 18S rRNA
#sed 's/Eukaryota\;/Eukaryota-Chloroplast-16S\;/' 02-PROKs/10-exports/all-16S-seqs.with-tax.tsv > tmp.16S.chloroplast.renamed.tsv

mkdir -p 03-Merged

#these `ls` expressions will generate more than one file name if you export your data more than once!
inProks=`ls 02-PROKs/10-exports/*$studyName.16S.all-16S-seqs.with-tax.tsv`
inEuks=`ls 02-EUKs/15-exports/*$studyName.18S.all-18S-seqs.with-PR2-tax.tsv`
prokStats=`ls 02-PROKs/03-DADA2d/*stats.tsv`
eukStats=`ls 02-EUKs/08-DADA2d/*stats.tsv`

#correction factor for 18S, as determined empirically
### Change this to reflect your dataset! Placeholder value of 3.84 is for P16N-S. ###
bias=3.84

#run script
./scripts/normalize_16S_18S_ASVs.R \
  --inputproks $inProks --prokstats $prokStats \
  --inputeuks $inEuks --eukstats $eukStats \
  --outputfile ${timestamp}_${studyName}_$bias-fold-18S-correction \
  --bias $bias 

#move output files to subfolder
mv ${timestamp}_${studyName}_$bias-fold-18S-correction* 03-Merged/
