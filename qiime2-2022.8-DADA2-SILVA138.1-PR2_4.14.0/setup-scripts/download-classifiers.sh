#!/bin/bash -i

mkdir classification-db ; cd classification-db

#download database files from OSF, raw artifacts, and scripts
for item in pxfnj p4279 axjgf ; do curl -O -J -L https://osf.io/$item/download ; done

mkdir rawArtifacts ; cd rawArtifacts

for item in trp7w dvmhu fm6g2 xctd4 au8wz 2hg6s ; do curl -O -J -L https://osf.io/$item/download ; done

cd ..

echo "See https://osf.io/z8arq/ for more info, including template scripts which you could modify to generate classifiers for a different qiime2 version." 2>&1 | tee README.txt

cd ..
