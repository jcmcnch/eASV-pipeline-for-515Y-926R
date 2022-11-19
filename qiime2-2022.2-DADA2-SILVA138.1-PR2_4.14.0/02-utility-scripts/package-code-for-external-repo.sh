#!/bin/bash -i
mkdir -p  code-export/02-EUKs/ code-export/02-PROKs
cp -r *cfg runscripts scripts code-export/

#scripts
cp -r 02-PROKs/*tsv 02-PROKs/*txt 02-PROKs/scripts/ code-export/02-PROKs
cp -r 02-EUKs/*tsv 02-EUKs/*txt 02-EUKs/scripts/ code-export/02-EUKs

echo "This directory contains scripts from a custom pipeline for analyzing amplicons from the 515Y/926R primers (https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R). The configuration file included here specifies parameters that the user chose during the analysis." > code-export/README.md
