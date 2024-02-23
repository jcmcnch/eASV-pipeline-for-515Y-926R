#!/bin/bash -i

source 515FY-926R.cfg

mkdir -p 05-${studyName}_CMAP
cd 05-P16N-S_CMAP
git clone https://github.com/jcmcnch/OTUandMetadata2CMAP.git
git clone https://github.com/simonscmap/c-microbial-map.git
mkdir -p 00-input-subsetted 00-input-tables 00-metadata
cp ../04-Formatted/*_proportions_reordered.tsv 00-input-tables
cp ../02-PROKs/210917_sample-metadata-P16N-S_PROK.tsv 00-metadata/sample-metadata.tsv
#take top 1000 ASVs
for item in 00-input-tables/*tsv ; do head -n1001 $item > 00-input-subsetted/`basename $item .tsv`.head1001.tsv ; done
