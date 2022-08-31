#!/bin/bash -i
conda activate qiime2-2019.4

qiime tools export --input-path 09-deblurred/representative_sequences.qza --output-path 09-deblurred/
qiime tools export --input-path 09-deblurred/stats.qza --output-path 09-deblurred/
qiime tools export --input-path 09-deblurred/table.qza --output-path 09-deblurred/
biom convert -i 09-deblurred/feature-table.biom -o 09-deblurred/feature-table.biom.tsv --to-tsv

conda deactivate
