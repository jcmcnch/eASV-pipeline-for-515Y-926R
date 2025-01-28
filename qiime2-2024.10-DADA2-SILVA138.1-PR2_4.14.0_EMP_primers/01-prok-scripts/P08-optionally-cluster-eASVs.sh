#!/bin/bash -i

conda activate /home/$USER/miniconda3/envs/qiime2-dev/

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a clustering level for VSEARCH. e.g. P08-optionally-cluster-eASVs.sh 99'
    exit 0
fi

clusteringlevel=$1

qiime vsearch cluster-features-de-novo \
	--i-sequences 03-DADA2d/representative_sequences.qza \
	--i-table 03-DADA2d/table.qza \
	--p-perc-identity 0.$clusteringlevel \
	--p-threads 10 \
	--output-dir clustered-eASVs-${clusteringlevel}pc \
	--verbose

conda deactivate 

echo "Don't forget to copy your UC file manually as noted in the protocol documentation. This information may come in handy later!"


