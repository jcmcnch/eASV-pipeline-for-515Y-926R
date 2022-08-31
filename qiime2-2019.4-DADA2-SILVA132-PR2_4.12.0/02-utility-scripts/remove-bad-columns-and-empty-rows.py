#!/usr/bin/env python3

import sys
import pandas as pd

#create array of bad sample IDs
aBadSamples = []
for line in open(sys.argv[1]):
    aBadSamples.append(line.strip())

#read in tsv as df
df = pd.read_csv(sys.argv[2], sep='\t')

#iterate over array and drop bad columns
for sampleID in aBadSamples:
    if sampleID in list(df.columns):
        df = df.drop(sampleID, axis=1)

#sort by max value, and remove rows or columns with a max value of 0 (i.e. ASVs only present in bad samples)
aMax=[]
for index, row in df.iterrows():
    rowMax = row[2:].max()
    aMax.append(rowMax)

seMax = pd.Series(aMax)
df["rowmax"] = seMax.values
df = df.sort_values("rowmax", axis=0, ascending=False)
df = df[df.rowmax != 0]
df = df.drop("rowmax", axis=1)

#export as tsv
df.to_csv(sys.argv[3], sep='\t', index=False)
