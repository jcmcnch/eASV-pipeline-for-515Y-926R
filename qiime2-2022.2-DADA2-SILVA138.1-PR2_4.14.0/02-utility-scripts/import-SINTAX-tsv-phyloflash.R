#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(ggplot2)

#A function to import cleaned TSV output from VSEARCH's implementation of the SINTAX classification algorithm into a phyloseq object (most code from: https://mvuko.github.io/meta_phyloseq/)
#Cleaning steps use bash tools to aggregate VSEARCH per-read classifications into a pseudo-OTU table where OTUs are the classification strings collapsed to the family level (see here: https://github.com/jcmcnch/Pacbio16S-18S-Wulf18S-Parada16S-18S-Arctic-intercomparison/blob/main/220821_Taylor_MG_SSU_rRNA_non-redundant/scripts/03-convert-to-tsv-counts.sh)

importCleanSINTAXtsv <- function(inputTSV) {

	otu <- read.delim(inputTSV, sep = "\t", header = TRUE)
	rownames(otu)<- otu$SampleID
	axa <- otu %>%
	  select(SampleID) %>%
	  separate(SampleID, c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"),
           ",")

	taxa <- cbind(otu$SampleID, taxa)
	colnames(taxa)[1]<- "SampleID"
	rownames(taxa)<- taxa$SampleID
	otu <- otu %>%
	  select(-SampleID)
	taxa <- taxa %>%
	  select(-SampleID)
	otu_mat <- as.matrix(otu)
	tax_mat <- as.matrix(taxa)
	phylo_OTU <- otu_table(otu_mat, taxa_are_rows = TRUE)
	phylo_TAX <- tax_table(tax_mat)
	phylo_object <- phyloseq(phylo_OTU, phylo_TAX)
	
	return(phylo_object)
}

otu<- read.delim("RAS_EGC_02_1617_1_SSU_rRNA.classified.SILVA138.1.taxtable.tsv", sep = "\t", header = TRUE)
rownames(otu)<- otu$SampleID
taxa<- otu %>% 
  select(SampleID) %>% 
  separate(SampleID, c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"),
           ",")

taxa<- cbind(otu$SampleID, taxa)
colnames(taxa)[1]<- "SampleID"
rownames(taxa)<- taxa$SampleID
otu<- otu %>% 
  select(-SampleID)
taxa<- taxa %>% 
  select(-SampleID)
otu_mat<- as.matrix(otu)
tax_mat<- as.matrix(taxa)
phylo_OTU<- otu_table(otu_mat, taxa_are_rows = TRUE)
phylo_TAX<- tax_table(tax_mat)
phylo_object<- phyloseq(phylo_OTU, phylo_TAX)

otu<- read.delim("RAS_EGC_03_1617_2_SSU_rRNA.classified.SILVA138.1.taxtable.tsv", sep = "\t", header = TRUE)
rownames(otu)<- otu$SampleID
taxa<- otu %>%
  select(SampleID) %>%
  separate(SampleID, c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"),
           ",")

taxa<- cbind(otu$SampleID, taxa)
colnames(taxa)[1]<- "SampleID"
rownames(taxa)<- taxa$SampleID
otu<- otu %>%
  select(-SampleID)
taxa<- taxa %>%
  select(-SampleID)
otu_mat<- as.matrix(otu)
tax_mat<- as.matrix(taxa)
phylo_OTU<- otu_table(otu_mat, taxa_are_rows = TRUE)
phylo_TAX<- tax_table(tax_mat)
phylo_object2<- phyloseq(phylo_OTU, phylo_TAX)

phylo_object_merged <- merge_phyloseq(phylo_object, phylo_object2)

p <- plot_bar(phylo_object_merged, fill="Order") #+
#       scale_fill_manual(values = c("darkblue", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "lightskyblue", "darkgreen", "deeppink", "khaki2", "firebrick", "brown1", "darkorange1", "cyan1", "royalblue4", "darksalmon", "dodgerblue3", "lightskyblue", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "brown1", "darkorange1", "cyan1", "darkgrey", "darkblue", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "lightskyblue", "darkgreen", "deeppink", "khaki2", "firebrick", "brown1", "darkorange1", "cyan1", "royalblue4", "darksalmon", "darkblue", "royalblue4", "dodgerblue3", "steelblue1", "lightskyblue", "darkseagreen", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "brown1", "darkorange1", "cyan1", "darkgrey"))

ggsave(file="foo.jpg", width=10, height=8)
