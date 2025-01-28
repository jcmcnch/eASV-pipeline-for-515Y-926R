#!/bin/bash -i
#Note: I would normally run these steps semi-manually to inspect outputs at each step, but they are provided here together for clarity
#All scripts should be run from either the base directory (i.e. here) or the two subfolders created by the pipeline after splitting (i.e. "02-PROKs", and "02-EUKs")
#Raw data needs to be put in a folder named "00-raw"
./scripts/00-run-cutadapt-multiple-seq-runs.sh
./scripts/01-sort-16S-18S-bbsplit-multiple-seq-runs.sh
#files have now been split into 16S and 18S pools, and can be denoised separately

for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do

cp -r 02-PROKs/scripts 02-PROKs-$seqrun
cd 02-PROKs-$seqrun
./scripts/P00-create-manifest.sh
./scripts/P01-import.sh
./scripts/P02-visualize-quality_R1-R2.sh
./scripts/P03-DADA2.sh
#needed for merging script
./scripts/P04-export-DADA2-results.sh
cd ..

done

source 515Y-806RB.cfg
conda activate $qiime2version

#merge denoised prok data
mkdir -p 02-PROKs/03-DADA2d
for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do printf "02-PROKs-$seqrun/03-DADA2d/table.qza " ; done > prok-tables-to-merge.txt
for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do printf "02-PROKs-$seqrun/03-DADA2d/representative_sequences.qza " ; done > prok-seqs-to-merge.txt

#a bit hacky but it works ;-)
qiime feature-table merge --i-tables `cat prok-tables-to-merge.txt` --o-merged-table 02-PROKs/03-DADA2d/table.qza
qiime feature-table merge-seqs --i-data `cat prok-seqs-to-merge.txt` --o-merged-data 02-PROKs/03-DADA2d/representative_sequences.qza

#merge stats manually, first writing header
head -n2 -q 02-PROKs-*/03-DADA2d/*stats.tsv | sort -r | uniq > 02-PROKs/03-DADA2d/merged-stats.tsv
#then write headerless contents of stats files
tail -q -n+3 02-PROKs-*/03-DADA2d/*stats.tsv >> 02-PROKs/03-DADA2d/merged-stats.tsv

cd 02-PROKs

./scripts/P04-export-DADA2-results.sh
./scripts/P05-classify-eASVs.sh
./scripts/P06-make-sample-metadata-file.sh
./scripts/P07-make-barplot.sh
#did not cluster this time, seemed to confuse collaborators and adds too much data to CMAP
#./scripts/P08-optionally-cluster-eASVs.sh
./scripts/P09-split-mito-chloro-PR2-reclassify.sh
#These biom tables are then the input for merging scripts
./scripts/P10-generate-tsv-biom-tables-with-taxonomy.sh
#following step optional, gives you proportional data to play with
./scripts/P11-transform-tsv-to-proportions.sh
./scripts/P12a-remake-barplot-with-PR2-taxonomy.sh
#./scripts/P12-make-subsetted-barplots.sh
#./scripts/P13-exclude-samples-from-barplots.sh
#./scripts/P14-optional-reclassify-multiple-p-confidence.sh
#./scripts/P15-optional-new-generate-tsv-biom-tables-with-taxonomy.sh
#./scripts/P16-optional-transform-tsv-to-proportions.sh
#./scripts/P17-optional-merge-taxonomy.sh
cd ..

for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do

cp -r 02-EUKs/scripts 02-EUKs-$seqrun
cd 02-EUKs-$seqrun
#./scripts/E00-create-manifest-viz.sh
#./scripts/E01-import.sh
#./scripts/E02-visualize-quality_R1-R2.sh
./scripts/E03-bbduk-cut-reads.sh
./scripts/E04-fuse-EUKs-withoutNs.sh
./scripts/E05-create-manifest-concat.sh
./scripts/E06-import-concat.sh
./scripts/E07-visualize-quality-single-seqs.sh
#do not need trim length since using concatenated fwd+rev reads
./scripts/E08-DADA2.sh
./scripts/E09-export-DADA2-results.sh
cd ..

done

source 515Y-806RB.cfg
conda activate $qiime2version

#merge denoised euk data
mkdir -p 02-EUKs/08-DADA2d
for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do printf "02-EUKs-$seqrun/08-DADA2d/table.qza " ; done > euk-tables-to-merge.txt
for seqrun in `ls | grep 00-raw- | cut -f3 -d-`; do printf "02-EUKs-$seqrun/08-DADA2d/representative_sequences.qza " ; done > euk-seqs-to-merge.txt

#a bit hacky but it works ;-)
qiime feature-table merge --i-tables `cat euk-tables-to-merge.txt` --o-merged-table 02-EUKs/08-DADA2d/table.qza
qiime feature-table merge-seqs --i-data `cat euk-seqs-to-merge.txt` --o-merged-data 02-EUKs/08-DADA2d/representative_sequences.qza

#merge stats manually, first writing header
head -n2 -q 02-EUKs-*/08-DADA2d/*stats.tsv | sort -r | uniq > 02-EUKs/08-DADA2d/merged-stats.tsv
#then write headerless contents of stats files
tail -q -n+3 02-EUKs-*/08-DADA2d/*stats.tsv >> 02-EUKs/08-DADA2d/merged-stats.tsv

cd 02-EUKs

./scripts/E09-export-DADA2-results.sh
./scripts/E10-classify-seqs.sh
#see sample-metadata files in this directory
./scripts/E11-make-sample-metadata-file.sh
./scripts/E12-make-barplot.sh
#./scripts/E13-optionally-cluster-eASVs.sh
./scripts/E14-split-metazoans-PR2-alternative-class.sh
./scripts/E15-generate-tsv-biom-tables-with-taxonomy.sh
./scripts/E16-transform-tsv-to-proportions.sh
#./scripts/E17-make-subsetted-barplots.sh
#./scripts/E18-exclude-samples-from-barplots.sh
#./scripts/E19-optional-reclassify-multiple-p-confidence.sh
#./scripts/E20-optional-new-generate-tsv-biom-tables-with-taxonomy.sh
#./scripts/E21-optional-transform-tsv-to-proportions.sh
#./scripts/E22-optional-merge-taxonomy.sh
