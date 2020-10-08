#!/usr/bin/env python

import csv
import argparse
from collections import defaultdict

parser = argparse.ArgumentParser(description='This script takes a tab-separated UC file generated from VSEARCH and generates a tab-separated output file that records the cluster (OTU) centroid sequence (i.e. the seed or representative sequence for a cluster) and its children (i.e. those sequences that are collapsed into the cluster) in the following format: centroid	child1,child2,...childn')

parser.add_argument('--input', help='The tsv output from VSEARCH as wrapped in qiime2. As of Oct 1, 2018 it is not possible by default to generate this file in qiime2, though there is a workaround in the \"qiime2-2018.8-vsearch-hacked\" conda environment. Ask Jesse if you need help with this.')

parser.add_argument('--output_summary', help='Membership information with the first column representing the centroid (a dictionary with the centroid as the key and children as values; formatted as a plaintext tsv spreadsheet).')

parser.add_argument('--output_lookup', help='Membership information with the first column representing the child/cluster member (a dictionary with the child as the key and the corresponding centroid as a single lookup value; formatted as a plaintext tsv spreadsheet).')

args = parser.parse_args()

hashParentLookup = {} #simple dictionary
hashCentroidTable = defaultdict(list) #dictionary that contains lists as its value by default

for astrLine in csv.reader(open(args.input), csv.excel_tab):
	
	if astrLine[0] == "S": #If the line describes a centroid
		centroid = astrLine[8].split(";")[0]
		hashCentroidTable[centroid] #Create an empty record in the dictionary (covers singleton corner case as many are singletons even at very low similarity clustering)

	if astrLine[0] == "H": #If the line describes a hit to a cluster ("H")
		parent = astrLine[9].split(";")[0]
		child = astrLine[8].split(";")[0]
		hashParentLookup[child] = parent
		hashCentroidTable[parent].append(child)

with open(args.output_summary, 'w') as csvfile:
	filewriter = csv.writer(csvfile, delimiter="\t")
	for key, value in hashCentroidTable.items():
		csvlist = (',').join(value)
		filewriter.writerow([key, csvlist])

with open(args.output_lookup, 'w') as csvfile:
	filewriter = csv.writer(csvfile, delimiter="\t")
	for key, value in hashParentLookup.items():
		filewriter.writerow([key, value])
