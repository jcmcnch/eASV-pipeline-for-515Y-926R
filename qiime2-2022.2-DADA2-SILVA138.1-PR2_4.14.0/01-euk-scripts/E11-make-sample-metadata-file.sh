#!/bin/bash -i

if [ -e sample-metadata.tsv ] ; then

        echo "sample-metadata.tsv alreads exists. Please check the existing file to see if you want to regenerate a blank sample-metadata.tsv file from your manifest. If you do, please delete sample-metadata.tsv manually and rerun this script."
        exit 0
else
        echo "sample-metadata.tsv not found. For your convenience, this script will now generate a blank sample-metadata.tsv file which you can fill in with your metadata. Such metadata is very useful for making qiime2 plots that can be sorted and organized by your metadata."
fi

#print headers
printf "sample-id	Example1_categorical_change_me	Example2_numeric_change_me\n" > sample-metadata.tsv
printf "#q2:types	categorical	numeric\n" >> sample-metadata.tsv

#get sample IDs from manifest file
cut -f1 manifest-concat.tsv | tail -n+2 >> sample-metadata.tsv
