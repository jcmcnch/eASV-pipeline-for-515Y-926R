#!/bin/bash -i

source 515FY-926R.cfg
timestamp=`date +"%y%m%d-%H%M"`
outDir=$HOME/515Y-926R-code-exports/${timestamp}_${studyName}_code-export

mkdir -p  $outDir/02-EUKs/ $outDir/02-PROKs
cp -r *cfg runscripts scripts $outDir/

#scripts
cp -r 02-PROKs/*tsv 02-PROKs/*txt 02-PROKs/scripts/ $outDir/02-PROKs
cp -r 02-EUKs/*tsv 02-EUKs/*txt 02-EUKs/scripts/ $outDir/02-EUKs

echo "This directory contains scripts from a custom pipeline for analyzing amplicons from the 515Y/926R primers (https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R). The configuration file included here specifies parameters that the user chose during the analysis." > $outDir/README.md
