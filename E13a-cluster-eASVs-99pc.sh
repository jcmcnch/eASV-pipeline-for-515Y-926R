#!/bin/bash

source activate qiime2-2018.8-vsearch-hacked

qiime vsearch cluster-features-de-novo \
	--i-sequences 09-deblurred/representative_sequences.qza \
	--i-table 09-deblurred/table.qza \
	--p-perc-identity 0.99 \
	--p-threads 10 \
	--output-dir clustered-eASVs-99pc \
	--verbose

source deactivate 
