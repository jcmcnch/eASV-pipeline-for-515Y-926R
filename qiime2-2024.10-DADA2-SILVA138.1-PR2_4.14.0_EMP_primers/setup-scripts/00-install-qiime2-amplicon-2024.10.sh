#!/bin/bash -i

#update conda to avoid weird problems
conda update conda

#install mamba which is way faster than conda at solving environments
#conda install -c conda-forge mamba

#download yaml config file from qiime2 peeps and install, now in a one-liner!
conda env create -n qiime2-amplicon-2024.10 --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml


# OPTIONAL CLEANUP
rm qiime2-amplicon-2024.10-py310-linux-conda.yml 
