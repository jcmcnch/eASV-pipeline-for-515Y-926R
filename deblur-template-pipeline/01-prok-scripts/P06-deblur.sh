#!/bin/bash -i

mkdir logs/06-deblur

conda activate qiime2-2019.4

trimlength=$1

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a trim length for deblur (keep this consistent between different runs if you want to intercompare data). Example P06-deblur.sh 363'
    exit 0
fi

echo "Deblur trim length = ${trimlength} bp" > deblur_trim_length.txt

qiime deblur denoise-16S \
  --i-demultiplexed-seqs 04-QCd/filtered_sequences.qza \
  --p-trim-length $trimlength \
  --p-sample-stats \
  --output-dir 06-deblurred \
  --verbose 2>&1 | tee -a logs/06-deblur/deblur.txt
  
mv deblur.log logs/06-deblur
conda deactivate
