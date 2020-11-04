#!/bin/bash -i
conda activate qiime2-2019.4
qiime tools export --input-path 06-deblurred/representative_sequences.qza --output-path 06-deblurred/
qiime tools export --input-path 06-deblurred/stats.qza --output-path 06-deblurred/
qiime tools export --input-path 06-deblurred/table.qza --output-path 06-deblurred/
biom convert -i 06-deblurred/feature-table.biom -o 06-deblurred/feature-table.biom.tsv --to-tsv
conda deactivate
