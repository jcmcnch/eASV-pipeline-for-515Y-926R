#!/bin/bash -i

mkdir classification-db ; cd classification-db

#download database files from OSF, raw artifacts, and scripts
for item in w32ac nvgru ; do curl -O -J -L https://osf.io/$item/download ; done

cd ..

echo "See https://osf.io/z8arq/ for more info, including template scripts which you could modify to generate classifiers for a different qiime2 version."
