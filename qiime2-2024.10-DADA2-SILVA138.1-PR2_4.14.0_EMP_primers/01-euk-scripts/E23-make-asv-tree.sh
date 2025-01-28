#!/bin/bash -i
conda activate qiime2-2022.2

qiime phylogeny align-to-tree-mafft-fasttree \
	--i-sequences 08-DADA2d/representative_sequences.qza \
	--output-dir 23-trees
