#!/usr/bin/env python

#simple script to make an example sample-metadata.tsv file from existing data
#usage: python this_script manifest.tsv > sample-metadata.tsv

print("\t".join(["#SampleID","Example1_categorical_change_me","Example2_numeric_change_me"]))
print("\t".join(["#q2:types","categorical","numeric"]))

import csv
import sys

counter = 1

for astrLine in csv.reader(open(sys.argv[1]), csv.excel_tab):
        print(astrLine[0])
        if counter < 1:
            if astrLine[1] == "forward-absolute-filepath":
                print(astrLine[0])
