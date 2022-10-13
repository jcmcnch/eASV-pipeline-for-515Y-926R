#!/usr/bin/env Rscript
suppressMessages(library(tidyverse))
suppressMessages(library(phyloseq))
suppressMessages(library(ggplot2))
suppressMessages(library(optparse))

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
      c("-o", "--outOTUtable"),
      default = file.path(getwd(), 'plots'),
      type = "character",
      help = "Output directory",
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

#Main function definition

main = function() {

  opts = getArgs()
  inputTSV = unlist(strsplit(opts$inputTSV, ","))
  phyloList <- lapply(inputTSV, importCleanSINTAXtsv)
  phylo_object <- do.call(merge_phyloseq, phyloList)
  por <- transform_sample_counts(phylo_object, function(x) x*100 / sum(x))
  top30 <- names(sort(taxa_sums(por), decreasing=TRUE))[1:30]
  por_top30 <- transform_sample_counts(por, function(OTU) OTU/sum(OTU))
  por_top30 <- prune_taxa(top30, por_top30)

  p <- plot_bar(por_top30, fill="Family") +

       scale_fill_manual(values = c("darkblue", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "lightskyblue", "darkgreen", "deeppink", "khaki2", "firebrick", "brown1", "darkorange1", "cyan1", "royalblue4", "darksalmon", "dodgerblue3", "lightskyblue", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "brown1", "darkorange1", "cyan1", "darkgrey", "darkblue", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "lightskyblue", "darkgreen", "deeppink", "khaki2", "firebrick", "brown1", "darkorange1", "cyan1", "royalblue4", "darksalmon", "darkblue", "royalblue4", "dodgerblue3", "steelblue1", "lightskyblue", "darkseagreen", "darkgoldenrod1", "darkseagreen", "darkorchid", "darkolivegreen1", "brown1", "darkorange1", "cyan1", "darkgrey"))

  ggsave(file="foo.jpg", width=10, height=8)

}

main()
