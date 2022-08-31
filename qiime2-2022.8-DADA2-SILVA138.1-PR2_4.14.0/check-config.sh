#!/bin/bash -i
#you probably want to run this to check for spelling errors or other issues before running the pipeline

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter the path to your config file. e.g. check-config.sh template.cfg'
    exit 0
fi

configFile=$1
echo "Reading config...." >&2
source $1
echo "Study name entered is: $studyName" >&2
