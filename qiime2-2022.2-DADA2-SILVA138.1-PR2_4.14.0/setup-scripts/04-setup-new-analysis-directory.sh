#!/bin/bash -i

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a memorable and informative name for your project as an argument after this script < e.g. ./setup-scripts/04-setup-new-analysis-directory.sh EXAMPLENAME > (make sure the name does not include any spaces - use dashes or underscores instead). This name will be used to create an analysis directory and will be appended to output files.'
    exit 0
fi

if [[ ! ${#1} -eq 0 ]] ; then
	echo "An analysis directory has been created for you at /home/$USER/515FY-926R-pipeline/$1 . It contains all the scripts needed to run the pipeline. The only two things you need to do are: 1) Add your input files into the "00-raw" folder and 2) modify the configuration file to suit these input files. The pipeline assumes your input files are untrimmed fastq.gz files."
fi

studyName=$1

studyDir=/home/$USER/515FY-926R-pipeline/$studyName
mkdir -p $studyDir/scripts $studyDir/runscripts $studyDir/01-trimmed $studyDir/02-PROKs/scripts $studyDir/02-EUKs/scripts $studyDir/00-raw

cp 00-trimming-sorting-scripts/* 02-utility-scripts/* $studyDir/scripts
cp 01-prok-scripts/* $studyDir/02-PROKs/scripts
cp 01-euk-scripts/* $studyDir/02-EUKs/scripts

cp config/qiime2-2022.2-SILVA138.1-PR2-4.14.0.cfg $studyDir/515FY-926R.cfg
echo "studyName=$studyName" >> $studyDir/515FY-926R.cfg
