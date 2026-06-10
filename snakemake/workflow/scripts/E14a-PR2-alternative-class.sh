#!/usr/bin/env bash

#Reclassify with PR2
qiime feature-classifier classify-sklearn \
  --i-classifier ${snakemake_input[classifier]} \
  --i-reads ${snakemake_input[eukseqs]} \
  --o-classification ${snakemake_output[PR2classeuk]}

#Workaround for whitespace issue with PR2 https://forum.qiime2.org/t/qiime-taxa-filter-table-error/3947/10
qiime tools export \
  --input-path ${snakemake_output[PR2classeuk]} \
  --output-path ${snakemake_output[fixedtax]}

qiime metadata tabulate \
  --m-input-file ${snakemake_output[fixedtax]}/taxonomy.tsv \
  --o-visualization ${snakemake_output[taxasmetadata]} 

qiime tools export \
  --input-path ${snakemake_output[taxasmetadata]} \
  --output-path ${snakemake_output[taxasmetadatafolder]}

#remove line with #q2:types - is this a bug?
sed -i '/#q2:types/d' ${snakemake_output[taxasmetadatafolder]}/metadata.tsv

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-path  ${snakemake_output[taxasmetadatafolder]}/metadata.tsv \
  --output-path ${snakemake_output[taxwithoutspaces]}
