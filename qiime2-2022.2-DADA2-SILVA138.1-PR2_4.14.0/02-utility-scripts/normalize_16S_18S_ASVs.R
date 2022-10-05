#!/usr/bin/env Rscript

#Purpose: normalize raw counts of 16S and 18S ASVs by dividing counts of proks and euks by the % passing DADA2, then converting to proportions and multiplying counts of euks by the bias against them (as user specifies).
#Required packages: Rscript, args 
#Output: This returns a file with ASV relative abundances out of (16S + 18S).
#Note: we recommend assuming a 2-fold bias against 18S sequences, which has been found with Illumina HiSeq or MiSeq data (Yeh et al. 2018)
#This script must be run from the base directory (the folder that contains 02-PROKs/ and 02-EUKs/)
#Author: Colette Fletcher-Hoppe 
#Final version: 04.19.2021

#0. Set up arguments to allow user to specify input file name, output file name, and bias-----
suppressMessages(library("optparse"))

option_list=list(
  make_option(c("--inputproks"), default="02-PROKs/10-exports/all-16S-seqs.with-tax.tsv", type="character", help="Input file for prokaryotic (16S) ASV counts, default='02-PROKs/10-exports/all-16S-seqs.with-tax.tsv'. If using another file, please specify the full filepath and make sure it matches the format of default, including '#Constructed from biom file'.", metavar="character", action="store_true"),
  make_option(c("--inputeuks"), default="02-EUKs/15-exports/all-18S-seqs.with-PR2-tax.tsv", type="character", help="Input file for eukaryotic (18S) ASV counts, default='02-EUKs/15-exports/all-18S-seqs.with-PR2-tax.tsv'. If using another file, please specify the full filepath and make sure it matches the format of default, including '#Constructed from biom file'.", metavar="character", action="store_true"),
  make_option(c("--prokstats"), default="02-PROKs/03-DADA2d/stats.tsv", type="character", help="Denoising statistics for 16S as output by qiime2, default='02-PROKs/03-DADA2d/stats.tsv'. If using another file, please specify the full filepath.", metavar="character", action="store_true"),
  make_option(c("--eukstats"), default="02-EUKs/08-DADA2d/stats.tsv", type="character", help="Denoising statistics for 18S as output by qiime2, default='02-EUKs/08-DADA2d/stats.tsv'. If using another file, please specify the full filepath.", metavar="character", action="store_true"),
  make_option(c("--outputfile"), type="character", help="Prefix name of output file", metavar="character", action="store_true"),
  make_option(c("--bias"), default=2, type="numeric", help="Bias against 18S sequences, 2 by default", metavar="numeric", action="store_true")
);

opt_parser=OptionParser(option_list=option_list);
opt=parse_args(opt_parser);

if(is.null(opt$outputfile)){
	print_help(opt_parser)
	stop("Please specify a name for your output files, e.g. 'output_file_[date]'.", call.=FALSE)
}

if(is.null(opt$bias)){
	print("A 2x bias will be applied to your 18S sequences by default.")
}

#1. Calculate percent of reads that passed DADA2 denoising for both proks and euks -----
print("1. Calculating DADA2 stats")
proks_stats <- read.table(opt$prokstats, sep="\t", header=T, stringsAsFactors = F)
proks_stats$perc.passed=proks_stats$non.chimeric/proks_stats$input

euks_stats <- read.table(opt$eukstats, sep="\t", header=T, stringsAsFactors = F)
euks_stats$perc.passed=euks_stats$non.chimeric/euks_stats$input

#2. Normalize ASV counts (divide counts of ASVs/ percent passed for each sample, multiply euks ASV counts by the bias you specified)------
print("2. Normalizing ASV counts for proks and euks")

#a. Proks--------
#Read in ASV counts data
#Fix "#OTU ID" and read in the counts table with taxonomy 
temp <- as.character(opt$inputproks)
colnames <- scan(text=readLines(temp, 2), what="", quiet=T)
colnames <- colnames[-c(1:7)]
proks_data <- read.table(temp, col.names=c("OTU_ID",colnames), sep="\t", stringsAsFactors = F)
colnames(proks_data)=c("OTU_ID", colnames) #removes the "X" before colnames 

#Subset matrix without taxonomy (only numerical values)
proks_subs <- proks_data[-grep("taxonomy", colnames(proks_data))]

#Set up a new matrix for normalized data
proks_norm <- as.data.frame(matrix(nrow=nrow(proks_subs), ncol=ncol(proks_subs)))
proks_norm[,1]=proks_subs$OTU_ID
colnames(proks_norm)=colnames(proks_subs)

#Divide ASV count for each sample by percent passing, write into the new matrix
for(i in proks_stats$sample.id){
  if(proks_stats$perc.passed[grep(i, proks_stats$sample.id)]==0){
    proks_norm[,grep(i, colnames(proks_subs))]=0
  } else{
    proks_norm[,grep(i, colnames(proks_subs))]=proks_subs[,grep(i, colnames(proks_subs))]/proks_stats$perc.passed[grep(i, proks_stats$sample.id)]
  }
}

#b. Now repeat normalization for the euks, and also multiply by the bias you specified-----
#Read in files (use file with PR2 taxonomy)
temp <- as.character(opt$inputeuks)
colnames <- scan(text=readLines(temp, 2), what="", quiet=T)
colnames <- colnames[-c(1:7)] #Keep taxonomy in for now
euks_data <- read.table(temp, col.names=c("OTU_ID",colnames), sep="\t", stringsAsFactors = F)
colnames(euks_data)=c("OTU_ID", colnames)

#Subset matrix without taxonomy 
euks_subs <- euks_data[,-grep("taxonomy", colnames(euks_data))]

#Set up a new matrix for normalized data
euks_norm <- as.data.frame(matrix(nrow=nrow(euks_subs), ncol=ncol(euks_subs)))
euks_norm[,1]=euks_subs$OTU_ID
colnames(euks_norm)=colnames(euks_subs)

#Divide ASV count by percent passing DADA2 for each sample and multiply by the given bias to normalize ASV counts
euks_norm <- as.data.frame(matrix(nrow=nrow(euks_subs), ncol=ncol(euks_subs)))
euks_norm[,1]=euks_subs$OTU_ID
colnames(euks_norm)=colnames(euks_subs)

#Divide ASV count by percent passing DADA2 for each sample and multiply by the given bias to normalize ASV counts
for(i in euks_stats$sample.id){
  if(euks_stats$perc.passed[grep(i, euks_stats$sample.id)]==0){
    euks_norm[,grep(i, colnames(euks_subs))]=0
  } else{
    euks_norm[,grep(i, colnames(euks_subs))]=opt$bias*euks_subs[,grep(i, colnames(euks_subs))]/euks_stats$perc.passed[grep(i, euks_stats$sample.id)]
  }
}

#3. Combine proks and euks tables of normalized sequencing counts-------
#First, we need to format a little, because this next part only works if colnames for proks and euks data are the same.

#a. Add in dummy columns for samples missing from one matrix or the other (i.e. the mocks) ------
print("3a. Add missing samples to proks and euks matrices")
#1. First, check if there are any samples missing from proks spreadsheet, and if so, write them in 
missing_from_proks <- c()
for(i in colnames(euks_norm)){
  if(i %in% colnames(proks_norm)){
  } else{
    missing_from_proks <- c(missing_from_proks, i)
  }
}

#Add in dummy columns for these samples--Must create a new matrix to do so
norm_proks <- as.data.frame(matrix(nrow=nrow(proks_norm), ncol=(ncol(proks_norm)+length(missing_from_proks))))
colnames(norm_proks)=c(colnames(proks_norm), missing_from_proks)
norm_proks[,1:ncol(proks_norm)]=proks_norm
#Now add in dummy columns
if(length(missing_from_proks)<1){
  print("No columns missing from proks data")
}else{for(i in c(1:length(missing_from_proks))){
    norm_proks[,i+ncol(proks_norm)]=0
  }
}

#2. Then, check if there are columns missing in euks spreadsheet and if so, write them in
missing_from_euks <- c()
for(i in colnames(proks_norm)){
  if(i %in% colnames(euks_norm)){
  } else {
    missing_from_euks <- c(missing_from_euks, i)
  }
}

#Add dummy columns for these samples into normalized euks data
norm_euks <- as.data.frame(matrix(nrow=nrow(euks_norm), ncol=(ncol(euks_norm)+length(missing_from_euks))))
colnames(norm_euks)=c(colnames(euks_norm), missing_from_euks)
norm_euks[,1:ncol(euks_norm)]=euks_norm
#Now add in dummy columns 
if(length(missing_from_euks)<1){
  print("No columns missing from euks data")
  } else{
  for(i in c(1:length(missing_from_euks))){
    norm_euks[,i+ncol(euks_norm)]=0
  }
}

#b. Make sure normalized proks and euks data are in the same order, but OTU ID comes first------
print("3b. Re-ordering samples")
#Proks first
proks_ordered <- as.data.frame(matrix(nrow=nrow(norm_proks), ncol=ncol(norm_proks)))
proks_ordered[,1]=norm_proks$OTU_ID 
colnames(proks_ordered)[1]="OTU_ID"
proks_ordered[,2:ncol(proks_ordered)]=norm_proks[,order(colnames(norm_proks))][-grep("OTU_ID", colnames(norm_proks)[order(colnames(norm_proks))])]
colnames(proks_ordered)[2:ncol(proks_ordered)]=colnames(norm_proks)[order(colnames(norm_proks))][-grep("OTU_ID", colnames(norm_proks)[order(colnames(norm_proks))])]

#Now euks second
euks_ordered <- as.data.frame(matrix(nrow=nrow(norm_euks), ncol=ncol(norm_euks)))
euks_ordered[,1]=norm_euks$OTU_ID
colnames(euks_ordered)[1]="OTU_ID"
euks_ordered[,2:ncol(euks_ordered)]=norm_euks[,order(colnames(norm_euks))][-grep("OTU_ID", colnames(norm_euks)[order(colnames(norm_euks))])]
colnames(euks_ordered)[2:ncol(euks_ordered)]=colnames(norm_euks)[order(colnames(norm_euks))][-grep("OTU_ID", colnames(norm_euks)[order(colnames(norm_euks))])]

#c. Merge normalized proks and euks data-----
print("3c. Merging proks and euks data")
norm_ordered_proks_euks <- rbind(proks_ordered, euks_ordered, stringsAsFactors=F)

#d. Write this table out, then convert to proportions next-----
print("3d. Writing out table of normalized sequence counts")
#Set up a new dataframe for adding in taxonomy
norm_ordered_proks_euks_w_tax=norm_ordered_proks_euks

#Write in taxonomy 
#First write in a dummy taxonomy
norm_ordered_proks_euks_w_tax$taxonomy="SAR--11"
#Then write over it with real taxonomy from proks_data and euks_data
norm_ordered_proks_euks_w_tax$taxonomy[c(1:nrow(proks_ordered))]=proks_data$taxonomy 
norm_ordered_proks_euks_w_tax$taxonomy[c((nrow(proks_ordered)+1):nrow(norm_ordered_proks_euks_w_tax))]=euks_data$taxonomy

#Now write it out
write.table(norm_ordered_proks_euks_w_tax, file=paste(opt$outputfile, "normalized_sequence_counts.tsv", sep="_"), sep="\t", row.names=F, quote=F)

#4. Convert normalized sequence counts to proportions-----
print("4. Converting normalized ASV counts to proportions")

#Sum up the ASV counts in each sample (16S + 18S)
colsums <- c()
for(i in c(2:ncol(norm_ordered_proks_euks))){
  colsums <- c(colsums, sum(norm_ordered_proks_euks[,i]))
}

#Set up a new dataframe for relative abundance data
relabun_proks_euks=as.data.frame(matrix(nrow=nrow(norm_ordered_proks_euks), ncol=ncol(norm_ordered_proks_euks)))
colnames(relabun_proks_euks)=colnames(norm_ordered_proks_euks)
relabun_proks_euks$OTU_ID=norm_ordered_proks_euks$OTU_ID

#Write in normalized data
for(i in c(2:ncol(relabun_proks_euks))){
  relabun_proks_euks[,i]=norm_ordered_proks_euks[,i]/colsums[(i-1)]
}

#5. Add in taxonomy and write it out!-----
print("5. Writing out the final file!")

#Write in taxonomy 
#First write in a dummy taxonomy
relabun_proks_euks$taxonomy="SAR--11"
#Then write over it with real taxonomy from proks_data and euks_data
relabun_proks_euks$taxonomy[c(1:nrow(proks_ordered))]=proks_data$taxonomy 
relabun_proks_euks$taxonomy[c((nrow(proks_ordered)+1):nrow(relabun_proks_euks))]=euks_data$taxonomy

#Write out file
write.table(file=paste(opt$outputfile, "_proportions.tsv", sep=""), x=relabun_proks_euks, sep="\t", row.names=F, quote=F)



