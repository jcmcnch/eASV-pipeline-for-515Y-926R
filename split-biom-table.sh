#!/bin/bash
source activate qiime2-2018.8

qiime taxa filter-table \
        --i-table 03-DADA2/table.qza \
        --i-taxonomy 05-classifications/classification.qza \
        --p-include Epsilonbacteraeota \
        --output-dir 12-Epsilonbacteraeota-subset

source deactivate
