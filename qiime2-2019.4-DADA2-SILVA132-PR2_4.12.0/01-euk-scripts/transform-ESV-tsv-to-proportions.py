#!/usr/bin/env python

import pandas as pd
import argparse

parser = argparse.ArgumentParser(description='This script normalizes an ASV spreadsheet generated from QIIME2. It ain\'t pretty, but it works. Ask Jesse if you need help. Make sure your spreadsheet is in this format: col[0]="#OTU ID",col[-1]="taxonomy",col[1:-1]=ASV/OTU counts.')

parser.add_argument('--input', help='Your tsv output from your biom spreadsheet, including taxonomy as the last column. Jesse has a script that generates this semi-automatically so ask him about this if you haven\'t already.')

parser.add_argument('--output', help='Your normalized tsv spreadsheet.')

parser.add_argument('--minimum_abundance_filtered_output', help='OPTIONAL: a spreadsheet that has been filtered by abundance to remove consistently rare ASVs.')

parser.add_argument('--minimum_abundance_threshold',help='Your desired abundance cut-off. Default: 0.001 aka 0.1 percent. ASVs/OTUs must never be greater than this proportion in any one sample in your spreadsheet in order to be discarded.',default='0.001')

parser.add_argument('--cumulative_abundance_filtered_output', help='OPTIONAL: a spreadsheet that has been filtered to retain only a subset of ASVs that comprise more than a given fraction of all abundances across all samples.')

parser.add_argument('--cumulative_abundance_threshold',help='Your desired cumulative abundance cut-off. Default: 0.99 aka 99 percent (i.e. the subset that is output will represent at least 99 percent of ASVs/OTUs across all samples in your spreadsheet.',default='0.99')

args = parser.parse_args()

biomDF = pd.read_csv(args.input, skiprows=[0], sep='\t', header=0)
biomDF.set_index("#OTU ID", inplace=True) #This makes the first column the index
cols = list(biomDF)[0:-1] #take only numeric columns, ignoring the final column (non-numeric, taxonomy)

normbiomDF = biomDF.loc[:,cols].div(biomDF.loc[:,cols].sum()) #ignoring taxonomy column, normalize cells to proportions
normbiomDF.set_index(biomDF.index) #reset the index
normbiomDF.insert(loc=0, column='taxonomy', value=biomDF['taxonomy']) #put the taxonomy column back in

aMax = []
for index, row in normbiomDF.iterrows():
	rowMax = row[1:].max()
	aMax.append(rowMax)

seMax = pd.Series(aMax)
normbiomDF["max"] = seMax.values
normbiomDF = normbiomDF.sort_values("max", axis=0, ascending=False)
normbiomDF = normbiomDF.drop("max", axis=1)

normbiomDF.to_csv(args.output, encoding='utf-8', sep="\t", index=True)

if args.minimum_abundance_filtered_output is not None:
	aMax = []
	minabundDF = normbiomDF
	for index, row in minabundDF.iterrows():
		if float(row[1:].max()) < float(args.minimum_abundance_threshold):
			minabundDF = minabundDF.drop(index)
		else:
			rowMax = row[1:].max()
			aMax.append(rowMax)

	seMax = pd.Series(aMax)
	minabundDF["max"] = seMax.values
	minabundDF = minabundDF.sort_values("max", axis=0, ascending=False)
	minabundDF = minabundDF.drop("max", axis=1)
	minabundDF.to_csv(args.minimum_abundance_filtered_output, encoding='utf-8', sep="\t", index=True)

if args.cumulative_abundance_filtered_output is not None:
	nonredundantASVs = set()
	for column in list(normbiomDF)[2:]:
		tempDF = normbiomDF[column].copy() #Make temporary dataframe with just one column
		tempDF = tempDF.sort_values(ascending=False) #Sort by abundance, in descending order
		tempDF = tempDF.cumsum() #Transform column into cumulative sum
		finalASV = tempDF[tempDF > float(args.cumulative_abundance_threshold)].index[0] #Grab location where we reach cumulative sum		
		aIndex = list(tempDF.index.values) #create list from index
		end = aIndex.index(finalASV) #Find integer location of final ASV in list
		subsetIndex = aIndex[0:end] #Take only that part of the list
		nonredundantASVs.update(subsetIndex) #Add to set (which is non-redundant)

	nonredundantASVs = list(nonredundantASVs) #Convert set to list
	cumabundDF = normbiomDF.loc[nonredundantASVs, :]
	cumabundDF.to_csv(args.cumulative_abundance_filtered_output, encoding='utf-8', sep="\t", index=True)
