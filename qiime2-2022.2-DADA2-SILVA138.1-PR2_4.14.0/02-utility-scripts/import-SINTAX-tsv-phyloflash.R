#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(ggplot2)

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
p <- plot_bar(phylo_object, fill="Order")
ggsave(file="foo.jpg", width=10, height=8)
