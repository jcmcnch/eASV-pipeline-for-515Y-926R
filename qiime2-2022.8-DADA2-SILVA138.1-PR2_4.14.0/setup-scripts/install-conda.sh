#!/bin/bash -i
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
chmod +x Miniconda3-py39_4.12.0-Linux-x86_64.sh
./Miniconda3-py39_4.12.0-Linux-x86_64.sh
conda init bash
rm -f Miniconda3-py39_4.12.0-Linux-x86_64.sh
source ~/.bashrc
