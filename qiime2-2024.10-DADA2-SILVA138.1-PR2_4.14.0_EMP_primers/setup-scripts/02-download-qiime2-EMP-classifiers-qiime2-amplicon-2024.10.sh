#!/bin/bash -i

currdir=$PWD

mkdir -p /home/$USER/databases/qiime2-classification-db ; cd /home/$USER/databases/qiime2-classification-db 

#download pre-trained classifiers from qiime2 folks
wget https://data.qiime2.org/classifiers/sklearn-1.4.2/silva/silva-138-99-nb-classifier.qza

cd $currdir

echo ""
echo "Your classifiers are stored at /home/$USER/databases/qiime2-classification-db/"
echo "Make sure the path to these classifiers is correctly specified in your config file."
echo "See https://osf.io/z8arq/ and https://github.com/jcmcnch/515F-Y_926R_database_construction for more info, including template scripts which you could modify to generate classifiers for a different qiime2 version."
