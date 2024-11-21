#!/usr/bin/env Rscript

#Purpose: normalize raw counts of 16S and 18S ASVs by dividing the 16S reads and 18S reads by the % passing DADA2, 
#then converting to proportions and multiplying counts of 18S sequences by the bias against them and adjusting the 16S sequences to match that bias (as user specifies).
#Required packages: Rscript, args, tidyverse
#Output: This returns a file with ASV relative abundances out of (16S + 18S).
#Note: we recommend assuming a 2-fold bias against 18S sequences, which has been found with Illumina HiSeq or MiSeq data (Yeh et al. 2018)
#This script must be run from the base directory (the folder that contains 02-PROKs/ and 02-EUKs/)
#Author: Nathan Lloyd Robert Williams
#Final version: 11.16.2022

#Note that there will be Eukaryotes in your 16S. These come from the 16S chloroplast, and are phytoplankton.
#Set directory for libraries.
myPaths <- .libPaths()
myPaths <- c(myPaths, '/home1/nathanwi/R/x86_64-pc-linux-gnu-library/4.3')
.libPaths(myPaths)

#Load dependencies
library(tidyverse)
library(data.table)

#Set the correction factors for each file
#Correction factor for 18S and 16S, as determined empirically - please see notes for calculation instructions.
#Change this to reflect your dataset! Placeholder value of 2 from the mock communities
correction_factor_18S = 3.84
correction_factor_16S = 0.79


#Import .16S.all-16S-seqs.with-tax.tsv


# List and read files, combine into a single data.table
raw_16S <- list.files(pattern = '*.16S.all-16S-seqs.with-tax.tsv') %>%
  # Use purrr::map to read and clean each file
  purrr::map_dfr(~ readr::read_delim(.x, delim = "\t", skip = 1, col_names = TRUE)) %>%
  # Convert to tibble for easier row handling
  as_tibble()

# Rename "#OTU ID" to "ASV_hash" if it exists
raw_16S <- raw_16S %>%
  rename(ASV_hash = `#OTU ID`)

# Convert to data.table if needed for efficiency
raw_16S <- as.data.table(raw_16S)


#Import .18S.all-18S-seqs.with-PR2-tax.tsv

# List and read files, combine into a single data.table
raw_18S <- list.files(pattern = '*.18S.all-18S-seqs.with-PR2-tax.tsv') %>%
  # Use purrr::map to read and clean each file
  purrr::map_dfr(~ readr::read_delim(.x, delim = "\t", skip = 1, col_names = TRUE)) %>%
  # Convert to tibble for easier row handling
  as_tibble()

# Rename "#OTU ID" to "ASV_hash" if it exists
raw_18S <- raw_18S %>%
  dplyr::rename(ASV_hash = `#OTU ID`)

# Convert to data.table if needed for efficiency
raw_18S <- as.data.table(raw_18S)


#1. Calculate percent of reads that passed DADA2 denoising for both proks and euks -----

#Import 16S statistics}

statistics_16S <- list.files(pattern = '*.16S.stats.tsv') %>% #List and read files, combine into a single data.table
  map_dfr(~ readr::read_delim(.x, delim = "\t")) %>% #Read each file
  slice(-1) %>% # Remove the first row
  rename(SampleID = `sample-id`) %>% #Rename "sample-id" to "SampleID"
  rename(non_chimeric = `non-chimeric`) %>% #Rename "non-chimeric" to "non_chimeric" -- need to do this because "-" messes with R.
  mutate(non_chimeric = as.numeric(non_chimeric), input = as.numeric(input)) %>%
  as.data.table() %>% #Convert to a data.table for efficient handling
  select(SampleID, non_chimeric, input) %>%
  mutate(percentage_passed_final = non_chimeric/input)  #Calculate ratio of reads that passed DADA2 denoising 16S


#Import 18S statistics}
statistics_18S <- list.files(pattern = '*.18S.stats.tsv') %>% #List and read files, combine into a single data.table
  map_dfr(~ readr::read_delim(.x, delim = "\t")) %>% #Read each file
  slice(-1) %>% # Remove the first row
  rename(SampleID = `sample-id`) %>% #Rename "sample-id" to "SampleID"
  rename(non_chimeric = `non-chimeric`) %>% #Rename "non-chimeric" to "non_chimeric" -- need to do this because "-" messes with R.
  mutate(non_chimeric = as.numeric(non_chimeric), input = as.numeric(input)) %>%
  as.data.table() %>% #Convert to a data.table for efficient handling
  select(SampleID, non_chimeric, input) %>%
  mutate(percentage_passed_final = non_chimeric/input) #Calculate ratio of reads that passed DADA2 denoising 18S


#2. Normalize ASV counts (divide counts of ASVs/ percent passed for each sample, multiply euks ASV counts by the bias you specified)------

#Arrange and connect 16S data and then make the DADA2 statistics calculcation}
raw_16S_long <- raw_16S %>%
  pivot_longer(cols = where(is.numeric),  # Select only numeric columns (e.g., sample ID columns with read counts)
               names_to = "SampleID",     # Name of the new column for sample IDs
               values_to = "read_abundance") %>%  # Name of the new column for the values
  mutate(read_abundance = as.numeric(read_abundance)) %>%
  left_join(statistics_16S, by = "SampleID") %>%
  mutate(corrected_read_abundance = (read_abundance * correction_factor_16S) / percentage_passed_final)

#Arrange and connect 18S data and then make the DADA2 statistics calculcation}
raw_18S_long <- raw_18S %>%
  pivot_longer(cols = where(is.numeric),  # Select only numeric columns (e.g., sample ID columns with read counts)
               names_to = "SampleID",     # Name of the new column for sample IDs
               values_to = "read_abundance") %>%  # Name of the new column for the values
  mutate(read_abundance = as.numeric(read_abundance)) %>%
  left_join(statistics_18S, by = "SampleID") %>%
  mutate(corrected_read_abundance = (read_abundance * correction_factor_18S) / percentage_passed_final)



#Join the two data frames together, pivot wider and then export}
combined_asv_long <- rbind(raw_18S_long, raw_16S_long) %>%
  rename(Taxonomy = taxonomy) %>%
  select(SampleID, ASV_hash, Taxonomy, corrected_read_abundance)

combined_asv <- combined_asv_long %>%
  pivot_wider(
    names_from = SampleID,            # Use SampleID for the column names
    values_from = corrected_read_abundance,  # The values to fill the table
    values_fill = 0                   # Fill missing values with 0
  )

#Write out file
filename <- paste0("corrected_18S_16S_counts", ".tsv")
write_tsv(combined_asv, filename)

q()
