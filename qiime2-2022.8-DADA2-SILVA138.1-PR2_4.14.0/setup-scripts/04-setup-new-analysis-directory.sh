#!/bin/bash -i

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a memorable and informative name for your project (no spaces - use dashes or underscores instead). This name will be used to create an analysis directory and will be appended to output files.'
    exit 0
fi

studyName=$1

studyDir=/home/$USER/515FY-926R-pipeline/$studyName
mkdir -p $studyDir/scripts $studyDir/runscripts $studyDir/01-trimmed $studyDir/02-PROKs/scripts $studyDir/02-EUKs/scripts

cp 00-trimming-sorting-scripts/* 02-utility-scripts/* $studyDir/scripts
cp 01-prok-scripts/* $studyDir/02-PROKs/scripts
cp 01-euk-scripts/* $studyDir/02-EUKs/scripts

cp config/qiime2-2022.8-SILVA.1-PR2-4.14.0.cfg $studyDir/515FY-926R.cfg
echo "studyName=$studyName" >> $studyDir/515FY-926R.cfg
