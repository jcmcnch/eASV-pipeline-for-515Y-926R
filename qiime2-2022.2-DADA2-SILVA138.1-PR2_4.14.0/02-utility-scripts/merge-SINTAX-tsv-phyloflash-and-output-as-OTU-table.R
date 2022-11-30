#!/usr/bin/env Rscript
suppressMessages(library(tidyverse))
suppressMessages(library(phyloseq))
suppressMessages(library(ggplot2))
suppressMessages(library(optparse))
suppressMessages(library(readr))
suppressMessages(library(tidyr))


# Arguments. Directly modified from Ken's script found here:
# https://github.com/simonscmap/c-microbial-map

getArgs = function() {
  args = commandArgs(trailingOnly = TRUE)

  option_list = list(
    make_option(
      c("-i", "--inputTSV"),
      default = "",
      type = "character",
      help = "Comma-separated list of input TSV tables",
      metavar = "character"
    ),
    make_option(
      c("-o", "--OTUout"),
      default = "",
      type = "character",
      help = "Output OTU file name",
      metavar = "character"
    )
  )
  opt_parser = OptionParser(option_list = option_list)
  return(parse_args(opt_parser))
}


#A function to import cleaned TSV output from VSEARCH's implementation of the SINTAX classification algorithm into a phyloseq object (most code from: https://mvuko.github.io/meta_phyloseq/)
#Cleaning steps use bash tools to aggregate VSEARCH per-read classifications into a pseudo-OTU table where OTUs are the classification strings collapsed to the family level (see here: https://github.com/jcmcnch/Pacbio16S-18S-Wulf18S-Parada16S-18S-Arctic-intercomparison/blob/main/220821_Taylor_MG_SSU_rRNA_non-redundant/scripts/03-convert-to-tsv-counts.sh)

importCleanSINTAXtsv <- function(inputTSV) {

	otu <- read.delim(inputTSV, sep = "\t", header = TRUE)
	rownames(otu)<- otu$SampleID
	taxa <- otu %>%
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

#Export function from https://gist.github.com/smdabdoub/f5451c654006426a70e22a13fc18b276

write_biom_tsv <- function(ps, file, sep = "; ") {
  phyloseq::otu_table(ps) %>%
    as.data.frame() %>%
    rownames_to_column("#OTU ID") %>%
    left_join(phyloseq::tax_table(ps) %>%
                as.data.frame() %>%
                rownames_to_column("#OTU ID") %>%
                tidyr::unite("taxonomy", !`#OTU ID`, sep = sep)) -> phyloseq_biom

  write_tsv(phyloseq_biom, file = file)
}

#Main function definition

main = function() {

  #import data from bash arguments, combine
  opts = getArgs()
  inputTSV = unlist(strsplit(opts$inputTSV, ","))
  phyloList <- lapply(inputTSV, importCleanSINTAXtsv)
  phylo_object <- do.call(merge_phyloseq, phyloList)
  #por <- transform_sample_counts(phylo_object, function(x) x*100 / sum(x))
  write_biom_tsv(phylo_object, opts$OTUout, sep = "; ")

}

main()
