#!/usr/bin/env bash

timestamp=`date +"%y%m%d-%H%M"`

qiime taxa barplot \
  --i-table ${snakemake_input[euktable]} \
  --i-taxonomy ${snakemake_input[euktax]} \
  --m-metadata-file ${snakemake_input[eukmetadata]} \
  --output-dir ${snakemake_output[0]}

cp ${snakemake_output[0]}/visualization.qzv ${snakemake_output[0]}/$timestamp.$studyName.18S.barplot.qzv
