#!/bin/bash -i
conda activate qiime2-2022.8

qiime rescript cull-seqs \
    --i-sequences silva-138.1-ssu-nr99-seqs.qza \
    --o-clean-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza

qiime rescript filter-seqs-length-by-taxon \
    --i-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza \
    --i-taxonomy silva-138.1-ssu-nr99-tax.qza \
    --p-labels Archaea Bacteria Eukaryota \
    --p-min-lens 900 1200 1400 \
    --o-filtered-seqs silva-138.1-ssu-nr99-seqs-filt.qza \
    --o-discarded-seqs silva-138.1-ssu-nr99-seqs-discard.qza

qiime rescript dereplicate \
    --i-sequences silva-138.1-ssu-nr99-seqs-filt.qza  \
    --i-taxa silva-138.1-ssu-nr99-tax.qza \
    --p-rank-handles 'silva' \
    --p-mode 'uniq' \
    --o-dereplicated-sequences silva-138.1-ssu-nr99-seqs-derep-uniq.qza \
    --o-dereplicated-taxa silva-138.1-ssu-nr99-tax-derep-uniq.qza
