# eASV-pipeline-for-515Y-926R
This is a collection of basic scripts for analyzing mixed 16S/18S amplicon sequences using bbtools, qiime2, deblur, biom, BLAST, and other tools. They are basically wrappers of a wrapper (qiime2), and are designed to make the in silico workflow for the 515Y/926R primer set easier, reproducible, and more accessible.

Scripts are either python or bash scripts, and are designed for the pre-set conda environments on kraken.usc.edu. However, they could easily be used elsewhere by installing the conda environment for qiime2 specified in the scripts and a separate environment (called bbmap-env) that has Brian Bushnell's Bestus Bioinformaticus Tools installed.

An associated protocol that describes the steps in more detail can be found here:

https://www.protocols.io/private/6C81EC4BC2074A76D7ACF80E2F0603B7
