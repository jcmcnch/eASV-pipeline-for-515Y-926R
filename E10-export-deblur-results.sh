#!/bin/bash
source activate qiime2-2018.8

qiime tools export --input-path 09-deblurred/representative_sequences.qza --output-path 09-deblurred/
qiime tools export --input-path 09-deblurred/stats.qza --output-path 09-deblurred/
qiime tools export --input-path 09-deblurred/table.qza --output-path 09-deblurred/
biom convert -i 09-deblurred/feature-table.biom -o 09-deblurred/feature-table.biom.tsv --to-tsv

source deactivate
