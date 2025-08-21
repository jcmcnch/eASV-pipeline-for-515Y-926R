#!/usr/bin/env bash

qiime demux summarize \
--i-data ${snakemake_input[0]} \
--output-dir ${snakemake_output[0]} \
--verbose
