#!/bin/bash -i

source 515FY-926R.cfg
timestamp=`date +"%y%m%d-%H%M"`
outDir=$HOME/515Y-926R-code-exports/${timestamp}_${studyName}_code-export
mkdir $outDir

#copy basic info and overall runscripts
cp -r *cfg runscripts scripts $outDir/

#loops added to capture scripts for analyses with multiple sequencing runs where there will be more than one "02-PROKs" or "02-EUKs" directories per runscript that handles multiple sequencing runs

#loop through multiple analysis directories, if present
for item in 02-PROKs* ; do

	mkdir -p $outDir/$item
	cp -r $item/*tsv $item/*txt $item/scripts/ $outDir/$item 2> /dev/null

done

#loop through multiple analysis directories, if present
for item in 02-EUKs* ; do

        mkdir -p $outDir/$item
	cp -r $item/*tsv $item/*txt $item/scripts/ $outDir/$item 2> /dev/null

done

echo "This directory contains scripts from a custom pipeline for analyzing amplicons from the 515Y/926R primers (https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R). The configuration file included here specifies parameters that the user chose during the analysis." > $outDir/README.md
