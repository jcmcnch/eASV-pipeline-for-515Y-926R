#!/bin/bash -i

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a memorable and informative name for your project (no spaces - use dashes or underscores instead). This name will be used to create an analysis directory and will be appended to output files.'
    exit 0
fi

studyName=$1

studyDir=/home/$USER/515FY-926R-pipeline/$studyName
mkdir -p $studyDir

cp config/qiime2-2022.8...blah $studyDir/515FY-926R.cfg

echo "studyName=$studyName" >> $studyDir/515FY-926R.cfg
