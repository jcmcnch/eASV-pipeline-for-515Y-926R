#!/bin/bash -i
conda activate qiime2-2019.4
qiime tools export --input-path 03-DADA2d/representative_sequences.qza --output-path 03-DADA2d/
qiime tools export --input-path 03-DADA2d/denoising_stats.qza --output-path 03-DADA2d/
qiime tools export --input-path 03-DADA2d/table.qza --output-path 03-DADA2d/
biom convert -i 03-DADA2d/feature-table.biom -o 03-DADA2d/feature-table.biom.tsv --to-tsv
conda deactivate
