#!/usr/bin/env bash

#NOTE: double-pipe at bottom of rules prevents filtering to fail in cases where no choloroplasts are present in your dataset

#Make subset of the biom tables that include only Chloroplast eASVs
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-include "o__Chloroplast" \
  --o-filtered-table ${snakemake_output[includechlorotable]} || touch ${snakemake_output[includechlorotable]}
  
#Make subset of the biom tables that exclude Chloroplast eASVs
qiime taxa filter-table \
  --i-table ${snakemake_input[proktable]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-exclude "o__Chloroplast" \
  --o-filtered-table ${snakemake_output[excludechlorotable]} || touch ${snakemake_output[excludechlorotable]}

#Filter only Chloroplast sequences from representative_sequences using default SILVA classification
qiime taxa filter-seqs \
  --i-sequences ${snakemake_input[prokseqs]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-include "o__Chloroplast" \
  --o-filtered-sequences ${snakemake_output[includechloroseqs]} || touch ${snakemake_output[includechloroseqs]}

#Filter Chloroplast sequences out from representative_sequences using default SILVA classification
qiime taxa filter-seqs \
  --i-sequences ${snakemake_input[prokseqs]} \
  --i-taxonomy ${snakemake_input[proktax]} \
  --p-exclude "o__Chloroplast" \
  --o-filtered-sequences ${snakemake_output[excludechloroseqs]} || touch ${snakemake_output[excludechloroseqs]}
