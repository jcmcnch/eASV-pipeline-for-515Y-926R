#!/usr/bin/env Rscript

#Load dependencies
library(tidyverse)
library(lubridate)
library(patchwork)
library(data.table)

#This script will load in the data for the cruise that is being uploaded to CMAP. We will convert it into long format.

#Import data
counts <- readr::read_tsv(snakemake@input[["mergedtabledada218Scorrected"]], show_col_types = FALSE) %>% as.data.table()

counts_dada2_corrected <- readr::read_tsv(snakemake@input[["mergedtabledada2"]], show_col_types = FALSE) %>% as.data.table()

counts_uncorrected <- readr::read_tsv(snakemake@input[["mergedtableuncorrected"]], show_col_types = FALSE) %>% as.data.table()

#Import all the ASV sequences from the 16S data
files <- list.files(pattern = '*16S.dna-sequences.fasta', full.names = TRUE) # List all files in the directory that match the pattern '*16S.dna-sequences.fasta'

for (file in files) {
  input <- readLines(file)
  # Standardize the output filename
  output_filename <- "prokaryote_asv_sequences.csv"
  # Open the output file
  output <- file(output_filename, "w")
  # Initialize sequence counter
  currentSeq <- 0
  # Process each line of the input file
  for (i in 1:length(input)) {
    if (strtrim(input[i], 1) == ">") {
      # If it's the first sequence, write the sequence header followed by a tab without newline
if (currentSeq == 0) {
  writeLines(paste(input[i], "\t"), output, sep = "")
  currentSeq <- currentSeq + 1
} else {
  # For subsequent sequences, add a newline before the sequence header
  writeLines(paste("\n", input[i], "\t", sep = ""), output, sep = "")
}
} else {
  # Write sequence data directly
  writeLines(paste(input[i]), output, sep = "")
}
}

# Close the output file
close(output)
}

#Import all the ASV sequences from the 18S data
files <- list.files(pattern = '*18S.dna-sequences.fasta', full.names = TRUE) # List all files in the directory that match the pattern '*16S.dna-sequences.fasta'
for (file in files) {
  input <- readLines(file)
  # Replace the entire filename to standardize the output filename
  output_filename <- "eukaryote_asv_sequences.csv"
  # Open the output file
  output <- file(output_filename, "w")
  # Initialize sequence counter
  currentSeq <- 0
  # Process each line of the input file
  for (i in 1:length(input)) {
    if (strtrim(input[i], 1) == ">") {
      # If it's the first sequence, write the sequence header followed by a tab without newline
      if (currentSeq == 0) {
        writeLines(paste(input[i], "\t"), output, sep = "")
        currentSeq <- currentSeq + 1
      } else {
        # For subsequent sequences, add a newline before the sequence header
        writeLines(paste("\n", input[i], "\t", sep = ""), output, sep = "")
      }
    } else {
      # Write sequence data directly
      writeLines(paste(input[i]), output, sep = "")
    }
  }
  
  # Close the output file
  close(output)
}

#Import asv_sequences now that htey have been converted to csv files
prokaryote_asv_sequences <- read.csv(snakemake@input[["fasta16S"]], header=FALSE)
eukaryote_asv_sequences  <- read.csv(snakemake@input[["fasta18S"]], header=FALSE)

#Join together asv sequences
asv_sequences <- bind_rows(eukaryote_asv_sequences,prokaryote_asv_sequences)
asv_sequences <- asv_sequences %>% rename(ASV = V1)
asv_sequences <- write_csv(asv_sequences, snakemake@output[["asvsequences"]])
asv_sequences <- as.data.frame(asv_sequences)

#parse out plas to get a yes/no column for whether something came from a plastid or not.
Taxonomy <- counts %>% 
  select(Taxonomy, ProPortal_ASV_Ecotype, ASV_hash)
Taxonomy <- Taxonomy %>%
  mutate(plastid_16S_rRNA = case_when(str_detect(Taxonomy, ":plas") ~ "yes", TRUE ~ "no"))
Taxonomy <- Taxonomy %>% 
  mutate(Source_database = case_when(str_detect(Taxonomy, "d__") ~ "SILVA", TRUE ~ "PR2"))

# This is to create a dataframe for proportal assigned taxa - this is requried for the "source_database" column
ProPortal <- Taxonomy %>% 
  filter(!ProPortal_ASV_Ecotype %in% (NA)) %>% mutate(Source_database = c("ProPortal"))
ProPortal$ProPortal_ASV_Ecotype <- as.character(ProPortal$ProPortal_ASV_Ecotype)
Taxonomy <- Taxonomy %>% 
  filter(ProPortal_ASV_Ecotype %in% (NA))

ProPortal <- ProPortal %>% 
  separate(Taxonomy, c("Domain","Phylum", "Class", "Order", "Family","Genus","Species"), ";")
ProPortal <- lapply(ProPortal, gsub, pattern=c('d__'), replacement='')
ProPortal <- lapply(ProPortal, gsub, pattern=c("p__"), replacement='')
ProPortal <- lapply(ProPortal, gsub, pattern=c("c__"), replacement='')
ProPortal <- lapply(ProPortal, gsub, pattern=c("o__"), replacement='')
ProPortal <- lapply(ProPortal, gsub, pattern=c("f__"), replacement='')
ProPortal <- lapply(ProPortal, gsub, pattern=c("g__"), replacement='')
ProPortal <- lapply(ProPortal, gsub, pattern=c("s__"), replacement='')
ProPortal <- as.data.frame(ProPortal)

# This is to create a dataframe for SILVA assigned taxa - this is requried for the "source_database" column
SILVA <- Taxonomy %>% 
  filter(Source_database %in% c("SILVA"))
SILVA <- SILVA %>% 
  separate(Taxonomy, c("Domain","Phylum", "Class", "Order", "Family","Genus","Species"), ";")
SILVA <- lapply(SILVA, gsub, pattern=c('d__'), replacement='')
SILVA <- lapply(SILVA, gsub, pattern=c("p__"), replacement='')
SILVA <- lapply(SILVA, gsub, pattern=c("c__"), replacement='')
SILVA <- lapply(SILVA, gsub, pattern=c("o__"), replacement='')
SILVA <- lapply(SILVA, gsub, pattern=c("f__"), replacement='')
SILVA <- lapply(SILVA, gsub, pattern=c("g__"), replacement='')
SILVA <- lapply(SILVA, gsub, pattern=c("s__"), replacement='')
SILVA <- as.data.frame(SILVA)

# This is to create a dataframe for PR2 assigned taxa - this is requried for the "source_database" column
PR2 <- Taxonomy %>% 
  filter(Source_database %in% c("PR2"))
PR2 <- PR2 %>% 
  separate(Taxonomy, c("Domain", "Supergroup","Division", "Subdivision" ,"Class", "Order", "Family","Genus","Species"), ";")
PR2 <- lapply(PR2, gsub, pattern = c(":plas"), replacement = '')
PR2 <- as.data.frame(PR2)

#Join all the Taxonomy together
Taxonomy <- bind_rows(SILVA,PR2,ProPortal)

#Left join taxonomy to asv_sequences
Taxonomy <- Taxonomy %>% 
  left_join(asv_sequences)

#Join asv table to Taxonomy}
counts <- Taxonomy %>% 
  left_join(counts)

#ASV Data Long
counts_long <- counts %>%
  gather(key = SampleID, value = Corrected_Sequence_Counts, -c(1:16)) %>%
  filter(Corrected_Sequence_Counts != 0)

counts_dada2 <- gather(data = counts_dada2_corrected, key = SampleID, value = Corrected_dada2_Sequence_Counts, -c(1,2,3)) %>%
  filter(Corrected_dada2_Sequence_Counts != 0)

counts_raw <- gather(data = counts_uncorrected, key = SampleID, value = Raw_Sequence_Counts, -c(1,2,3)) %>%
  filter(Raw_Sequence_Counts !=0)

asv_long <- counts_long %>% 
  left_join(counts_dada2)

asv_long <- asv_long %>% 
  left_join(counts_raw)

asv_long <- asv_long %>%
  group_by(SampleID, ASV_hash) %>%
  distinct(.keep_all = TRUE)

#Calculate Relative Abundance
asv_long <- asv_long %>% 
  group_by(SampleID) %>% 
  mutate(TC = sum(Corrected_Sequence_Counts)) %>% 
  group_by(SampleID,ASV) %>% 
  mutate(Relative_Abundance = (Corrected_Sequence_Counts/TC))

Check <- asv_long %>% 
  ungroup() %>% 
  group_by(SampleID) %>% 
  summarise(Check = sum(Relative_Abundance))

#Make Sequence Type Column
asv_long <- asv_long %>% mutate(Plas_Domain = paste(plastid_16S_rRNA, Domain, sep = "_"))
Prokaryotic_16S <- asv_long %>% filter(Plas_Domain %in% c("no_Bacteria","no_Archaea")) %>% mutate(Sequence_Type = "Prokaryotic_16S")
Chloroplast_16S <- asv_long %>% filter(Plas_Domain %in% c("yes_Eukaryota"))  %>% mutate(Sequence_Type = "Chloroplast_16S")
Eukaryote_18S   <- asv_long %>% filter(Plas_Domain %in% c("no_Eukaryota"))  %>% mutate(Sequence_Type = "Eukaryote_18S")
Unassigned      <- asv_long %>% filter(Plas_Domain %in% c("no_Unassigned"))  %>% mutate(Sequence_Type = "Unassigned")

asv_long <- bind_rows(Prokaryotic_16S,Chloroplast_16S,Eukaryote_18S,Unassigned)

#Tidy order of columns and what's included in final sheet
asv_long <- asv_long %>% 
  select(SampleID, Domain, Supergroup, Division, Subdivision, Phylum, Class, Order, Family, Genus, 
         Species, ProPortal_ASV_Ecotype, Sequence_Type, plastid_16S_rRNA, ASV_hash, ASV, Raw_Sequence_Counts, Corrected_dada2_Sequence_Counts, Corrected_Sequence_Counts, Relative_Abundance, Source_database)

#Last thing is to remove 0's for our use to prevent having such a large file
asv_long <- asv_long %>% filter(!Corrected_Sequence_Counts %in% (0))

#Write asv long
write_csv(asv_long,snakemake@output[["longdata"]])
