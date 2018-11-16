#!/home/anaconda/miniconda2/envs/qiime2-2018.8/bin/python

#simple script to make an example sample-metadata.tsv file from existing data
#usage: python this_script manifest.csv > output

print("\t".join(["#SampleID","Example1_categorical_change_me","Example2_numeric_change_me"]))
print("\t".join(["#q2:types","categorical","numeric"]))

import csv
import sys

counter = 1

for astrLine in csv.reader(open(sys.argv[1])):
	counter -= 1
	if counter < 1:
		if astrLine[2] == "forward":
			print(astrLine[0])
