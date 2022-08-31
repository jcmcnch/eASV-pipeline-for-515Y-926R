#!/bin/bash -i

#update conda to avoid weird problems
conda update conda

#install mamba which is way faster than conda at solving environments
conda install -c conda-forge mamba

#download yaml config file from qiime2 peeps
wget https://data.qiime2.org/distro/core/qiime2-2022.8-py38-linux-conda.yml

#create environment using mamba
mamba env create -n qiime2-2022.8 --file qiime2-2022.8-py38-linux-conda.yml

# OPTIONAL CLEANUP
rm qiime2-2022.8-py38-linux-conda.yml
