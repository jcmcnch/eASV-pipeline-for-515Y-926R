#!/bin/bash
source activate qiime2-2018.8
qiime tools export --input-path 08-DADA2d/representative_sequences.qza --output-path 08-DADA2d/
qiime tools export --input-path 08-DADA2d/denoising_stats.qza --output-path 08-DADA2d
qiime tools export --input-path 08-DADA2d/table.qza --output-path 08-DADA2d/ 
biom convert -i 08-DADA2d/feature-table.biom -o 08-DADA2d/feature-table.biom.tsv --to-tsv
source deactivate
