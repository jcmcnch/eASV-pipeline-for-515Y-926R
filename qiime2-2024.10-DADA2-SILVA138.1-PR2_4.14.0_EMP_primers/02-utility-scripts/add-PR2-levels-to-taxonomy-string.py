#!/usr/bin/env python3

import re
import csv
import sys
import argparse

parser = argparse.ArgumentParser(description='This hacky script adds in PR2 taxonomy levels givenan 8-level taxonomy plaintext file. Designed for PR2 4.14.0')

parser.add_argument('--input', help='A TSV spreadsheet where you want to amend PR2 taxonomy (8-levels). The taxonomy needs to be the second column.')

args = parser.parse_args()

hashTax = {}

aPR2levels = ["Kingdom_","Supergroup_","Division_","Class_","Order_","Family_","Genus_","Species_",]

for astrLine in csv.reader(open(args.input), csv.excel_tab):

    if astrLine[1].startswith("Eukaryota"):

        taxArray = astrLine[1].split(';')
        replacementArray = []

        for i in range(len(taxArray)):
            replacementArray.append(aPR2levels[i] + taxArray[i].strip())

        print("\t".join([astrLine[0], astrLine[1], ("; ").join(replacementArray)]))

    else:
        print("\t".join([astrLine[0], astrLine[1], astrLine[1]]))
