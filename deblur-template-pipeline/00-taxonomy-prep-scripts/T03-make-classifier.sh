#!/bin/bash
source activate qiime2-2018.8

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ../SILVA_132_99_OTUs_sliced_to_primers.qza \
  --i-reference-taxonomy ../SILVA_132_99_tax.qza \
  --o-classifier ../SILVA_132_99_tax_sliced_to_primers_classifier.qza

source deactivate
