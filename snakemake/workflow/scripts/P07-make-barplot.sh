#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

qiime taxa barplot \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]}  \
  --m-metadata-file ${snakemake_input[prokmetadata]} \
  --output-dir ${snakemake_output[0]}

mv ${snakemake_output[0]}/visualization.qzv ${snakemake_output[0]}/$timestamp.${snakemake_params[studyName]}.16S.barplot.qzv
