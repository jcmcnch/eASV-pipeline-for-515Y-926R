#!/usr/bin/env python

import pandas as pd
import sys

#read in previously produced manifest
manifestDF = pd.read_csv(sys.argv[2], sep='\t', header=0)
manifestDF.set_index("sample-id", inplace=True) #This makes the first column the index

#samples.tsv, provided by user, containing metadata
samplesDF = pd.read_csv(sys.argv[1], sep='\t', header=0)
samplesDF.set_index("sample", inplace=True) #This makes the first column the index

#import qiime2 stats from DADA2, get only "non-chimeric" which is
#the number of reads remaining after DADA2 pipeline
denoisingStatsDF = pd.read_csv(sys.argv[3], sep='\t', header=0)
denoisingStatsDF.set_index("sample-id", inplace=True)
denoisingStatsDF = denoisingStatsDF.filter(["non-chimeric"])

#merge all into one file, removing file paths specified in configs
mergedDF = pd.merge(manifestDF, samplesDF, left_index=True, right_index=True) 
mergedDF = mergedDF.drop(["read1","read2","forward-absolute-filepath","reverse-absolute-filepath"], axis=1)
mergedDF = pd.merge(mergedDF, denoisingStatsDF, left_index=True, right_index=True)

#export as tsv
mergedDF.to_csv("foo.tsv", encoding='utf-8', sep="\t", index=True)

