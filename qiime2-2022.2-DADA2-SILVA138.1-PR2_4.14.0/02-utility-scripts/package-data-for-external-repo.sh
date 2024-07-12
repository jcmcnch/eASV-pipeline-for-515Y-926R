#!/bin/bash -i

source 515FY-926R.cfg
timestamp=`date +"%y%m%d-%H%M"`
outDir=$HOME/515-926R-data-exports/${timestamp}_${studyName}_data-export

mkdir -p $outDir/eukfrac $outDir/16S/subsetted-ASV-tables $outDir/18S/subsetted-ASV-tables $outDir/merged $outDir/merged-qcd
cp 03-Merged/* $outDir/merged
cp 04-Formatted/* $outDir/merged-qcd
cp *EUKfrac* $outDir/eukfrac
cp -r *cfg logs runscripts scripts $outDir/

### 16S ###
#associated data
cp 02-PROKs/03-DADA2d/*16S*fasta $outDir/16S/
cp 02-PROKs/03-DADA2d/*16S*stats.tsv $outDir/16S/
cp 02-PROKs/10-exports/*taxonomy.tsv $outDir/16S/

#subsetted tables
cp 02-PROKs/10-exports/*filtered*biom $outDir/16S/subsetted-ASV-tables/
cp 02-PROKs/10-exports/*filtered*proportions.tsv $outDir/16S/subsetted-ASV-tables/
cp 02-PROKs/10-exports/*filtered*with-tax.tsv $outDir/16S/subsetted-ASV-tables/

#whole tables
cp 02-PROKs/10-exports/*all-16S*with*biom $outDir/16S/
cp 02-PROKs/10-exports/*all-16S*with-tax.tsv $outDir/16S/
cp 02-PROKs/10-exports/*all-16S*with-tax.proportions.tsv $outDir/16S/

### 18S ###
#associated data
cp 02-EUKs/08-DADA2d/*18S*fasta $outDir/18S/
cp 02-EUKs/08-DADA2d/*18S*stats.tsv $outDir/18S/
cp 02-EUKs/15-exports/*taxonomy*.tsv $outDir/18S/

#subsetted tables
cp 02-EUKs/15-exports/*filtered*biom $outDir/18S/subsetted-ASV-tables/
cp 02-EUKs/15-exports/*filtered*proportions.tsv $outDir/18S/subsetted-ASV-tables/
cp 02-EUKs/15-exports/*filtered*with-*tax.tsv $outDir/18S/subsetted-ASV-tables/

#whole tables
cp 02-EUKs/15-exports/*all-18S*with*biom $outDir/18S/
cp 02-EUKs/15-exports/*all-18S*with-*tax.tsv $outDir/18S/
cp 02-EUKs/15-exports/*all-18S*with-*tax.proportions.tsv $outDir/18S/

#scripts
cp -r 02-PROKs/scripts/ $outDir/16S
cp -r 02-EUKs/scripts/ $outDir/18S

#zip up files to save space
for item in `find $outDir/ -name "*fasta"`; do
	zip -m -j $item.zip $item
done

for item in `find $outDir/ -name "*tsv"`; do
        zip -m -j $item.zip $item
done

for item in `find $outDir/ -name "*biom"`; do
        zip -m -j $item.zip $item
done

echo "This repository contains scripts and data from a custom pipeline for analyzing amplicons from the 515Y/926R primers (https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R). The configuration file included here specifies parameters that the user chose during the analysis. The \`eukfrac\` folder indicates the fraction of eukaryotic sequences in each sample after primer trimming and before denoising. 16S and 18S data tables are presented separately and merged if the user has run the merging script. Depending on your research question, you may choose to analyze any of those tables in isolation but the merged table will give the most comprehensive picture of the community. Various ASV tables subsetted by taxonomy strings are also included by default (for example, if you wanted to exclude Metazoa, Chloroplasts, or Mitochondria from your ASV table). ASV sequences are exported in a file ending in \*dna-sequences.fasta and denoising statistics as a file ending with \*stats.tsv." > $outDir/README.md
