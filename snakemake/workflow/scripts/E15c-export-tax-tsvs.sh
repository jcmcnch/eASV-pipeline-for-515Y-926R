#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

if [ -s ${snakemake_input[excludemetazoaSILVAtablebiomtax]} ] ; then

	biom convert -i ${snakemake_input[excludemetazoaSILVAtablebiomtax]} -o ${snakemake_output[excludemetazoaSILVAtablebiomtaxtsv]} --to-tsv --header-key taxonomy 
	
else
	
	touch ${snakemake_output[excludemetazoaSILVAtablebiomtaxtsv]}

fi


if [ -s ${snakemake_input[excludemetazoaPR2tablebiomtax]} ] ; then

	biom convert -i ${snakemake_input[excludemetazoaPR2tablebiomtax]} -o ${snakemake_output[excludemetazoaPR2tablebiomtaxtsv]} --to-tsv --header-key taxonomy 

else
	
	touch ${snakemake_output[excludemetazoaPR2tablebiomtaxtsv]}

fi


if [ -s ${snakemake_input[includemetazoaSILVAtablebiomtax]} ] ; then


	biom convert -i ${snakemake_input[includeemetazoaSILVAtablebiomtax]} -o ${snakemake_output[includeemetazoaSILVAtablebiomtaxtsv]} --to-tsv --header-key taxonomy

else
	
	touch ${snakemake_output[includemetazoaSILVAtablebiomtaxtsv]}

fi


if [ -s ${snakemake_input[includemetazoaPR2tablebiomtax]} ] ; then

	biom convert -i ${snakemake_input[includemetazoaPR2tablebiomtax]} -o ${snakemake_output[includemetazoaPR2tablebiomtaxtsv]} --to-tsv --header-key taxonomy 
	
else

	touch ${snakemake_output[includemetazoaPR2tablebiomtaxtsv]}

fi
