#This script was written to convert ASV copies into ASV absolute copies by correcting data with internal standards. 
#It can only be used if genomic internal standards were added at the time of DNA extraction.
#Written by Nathan Williams 18/02/2026.

suppressPackageStartupMessages({
library(tidyverse)
})

#Set paths
isd_path  <- snakemake@input[["isd"]]
isd_added_path <- snakemake@input[["isd_added"]]
output_path    <- snakemake@output[["corrected"]]

#Import Data
asv_table <- read_tsv(snakemake@input[["asv_table"]])
isd <- read_tsv(isd_path , show_col_types = FALSE)
isd_added <- read_tsv(isd_added_path, show_col_types = FALSE) %>%
  rename(SampleID=sample) %>%
  mutate(SampleID = str_replace_all(SampleID, "_", "-"))
samples <- isd_added

#Import Data local
bp_asvs <- read_delim(snakemake@input[["BPasvs"]], delim = "\n", col_names = FALSE)
dr_asvs <- read_delim(snakemake@input[["DRasvs"]], delim = "\n", col_names = FALSE)
tt_asvs <- read_delim(snakemake@input[["TTasvs"]], delim = "\n", col_names = FALSE)

#Make the ISD dataframe lookup vectors
genome_len  <- setNames(isd$genome_len_bp, isd$internal_std_ID)
copy_number <- setNames(isd$rRNA_copy_number, isd$internal_std_ID)

#Calculate copies of each ISD added
#Set parameters
bp_weight <- 617.9
avogadro <- 6.022 * 1e23
# 1e9 is to convert to copies added per L.

BPlen=isd$genome_len_bp[isd$internal_std_ID == "BP"]
DRlen=isd$genome_len_bp[isd$internal_std_ID == "DR"]
TTlen=isd$genome_len_bp[isd$internal_std_ID == "TT"]

BPcopynum=isd$rRNA_copy_number[isd$internal_std_ID == "BP"]
DRcopynum=isd$rRNA_copy_number[isd$internal_std_ID == "DR"]
TTcopynum=isd$rRNA_copy_number[isd$internal_std_ID == "TT"]

# Do calculation
isd_copies_added <- isd_added %>% 
  select(SampleID, TT_ng, BP_ng, DR_ng) %>%
  mutate(TT_copies = ((((TT_ng/1e9) / (bp_weight * TTlen)) * avogadro) * TTcopynum)) %>%
  mutate(DR_copies = ((((DR_ng/1e9) / (bp_weight * DRlen)) * avogadro) * DRcopynum)) %>%
  mutate(BP_copies = ((((BP_ng/1e9) / (bp_weight * BPlen)) * avogadro) * TTcopynum))
          
#Pull internal standard copies out of ASV table frame
bp_ids <- pull(bp_asvs) %>% as.character()
dr_ids <- pull(dr_asvs) %>% as.character()
tt_ids <- pull(tt_asvs) %>% as.character()

bp_by_sample <- asv_table %>%
  filter(ASV_hash %in% bp_ids) %>%
  group_by(SampleID) %>%
  summarize(BP_copies_recovered = sum(Corrected_Sequence_Counts, na.rm = TRUE), .groups = "drop")

dr_by_sample <- asv_table %>%
  filter(ASV_hash %in% dr_ids) %>%
  group_by(SampleID) %>%
  summarize(DR_copies_recovered = sum(Corrected_Sequence_Counts, na.rm = TRUE), .groups = "drop")

tt_by_sample <- asv_table %>%
  filter(ASV_hash %in% tt_ids) %>%
  group_by(SampleID) %>%
  summarize(TT_copies_recovered = sum(Corrected_Sequence_Counts, na.rm = TRUE), .groups = "drop")

#Now calculate recovery ratio
merged_isd_data <- isd_copies_added %>%
  left_join(bp_by_sample) %>%
  left_join(dr_by_sample) %>%
  left_join(tt_by_sample)

#Calculate per-ISD recovery ratio columns (recovered / added)
merged_isd_data <- merged_isd_data %>%
  mutate(TT_recovery_ratio = TT_copies_recovered / TT_copies) %>%
  mutate(BP_recovery_ratio = BP_copies_recovered / BP_copies) %>%
  mutate(DR_recovery_ratio = DR_copies_recovered / DR_copies)

#Calculate the mean and median of all three combinations, as well as each combination of two.
merged_isd_data <- merged_isd_data %>%
  rowwise() %>%
  mutate(recovery_mean = mean( c(BP_recovery_ratio, DR_recovery_ratio, TT_recovery_ratio), na.rm = TRUE),
  recovery_median = median(c(BP_recovery_ratio, DR_recovery_ratio, TT_recovery_ratio),na.rm = TRUE),
  BP_DR_mean_recovery_ratio = mean( c(BP_recovery_ratio, DR_recovery_ratio), na.rm = TRUE),
  BP_TT_mean_recovery_ratio = mean( c(BP_recovery_ratio, TT_recovery_ratio), na.rm = TRUE),
  DR_TT_mean_recovery_ratio = mean( c(DR_recovery_ratio, TT_recovery_ratio), na.rm = TRUE)
  ) %>%
  ungroup()

#Make a subset of data for the plots
plot_data <- merged_isd_data %>%
  select(SampleID, TT_recovery_ratio, BP_recovery_ratio, DR_recovery_ratio, recovery_mean, 
         BP_DR_mean_recovery_ratio, BP_TT_mean_recovery_ratio, DR_TT_mean_recovery_ratio) %>%
  pivot_longer(
    cols = c(TT_recovery_ratio, BP_recovery_ratio, DR_recovery_ratio, recovery_mean, 
             BP_DR_mean_recovery_ratio, BP_TT_mean_recovery_ratio, DR_TT_mean_recovery_ratio),
    names_to = "Method",
    values_to = "Recovery"
  ) %>%
  filter(!is.na(Recovery))

#means dataframe
means_df <- plot_data %>% filter(Method %in% c("recovery_mean")) %>%
  distinct(SampleID, Recovery)

#Generate a plot to compare ratios
plot1 <- ggplot(plot_data, aes(x = SampleID, y = Recovery, colour = Method)) +
  geom_point(position = position_jitter(width = 0.15, height = 0), size = 2.5) +
  geom_line(data = means_df, aes(x = SampleID, y = Recovery, group = 1),
            inherit.aes = FALSE, colour = "black", linewidth = 1) +
  theme_minimal() +
  labs(title = "Recovery Ratios per Sample",
       subtitle = "Dots = internal standards, Black line = per-sample mean",
       y = "Recovery Ratio",
       x = "Sample") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
plot1

#Choose your method
recovery_ratios <- merged_isd_data %>% select(c("SampleID", "TT_recovery_ratio", "BP_recovery_ratio", "DR_recovery_ratio" ,
                                                "recovery_mean", "recovery_median", "BP_DR_mean_recovery_ratio", 
                                                "BP_TT_mean_recovery_ratio", "DR_TT_mean_recovery_ratio"))

#Join in recovery ratio
asv_table <- asv_table %>%
  left_join(recovery_ratios)


#add in unit for normalisation
isd_norm_fact <- samples %>% 
  select(SampleID,internal_std_normalization_factor,units)
  
asv_table <- asv_table %>% left_join(isd_norm_fact)
  
#Calculate recovery ratio
asv_table <- asv_table %>%
  mutate(Copies_BP_RR = (Corrected_Sequence_Counts / BP_recovery_ratio)/internal_std_normalization_factor) %>%
  mutate(Copies_DR_RR = (Corrected_Sequence_Counts / DR_recovery_ratio)/internal_std_normalization_factor) %>%
  mutate(Copies_TT_RR = (Corrected_Sequence_Counts / TT_recovery_ratio)/internal_std_normalization_factor) %>%
  mutate(Copies_mean_RR = (Corrected_Sequence_Counts / recovery_mean)/internal_std_normalization_factor) %>%
  mutate(Copies_median_RR = (Corrected_Sequence_Counts / recovery_median)/internal_std_normalization_factor) %>%
  mutate(Copies_BP_DR_mean_recovery_ratio_RR = (Corrected_Sequence_Counts /BP_DR_mean_recovery_ratio)/internal_std_normalization_factor) %>%
  mutate(Copies_BP_TT_mean_recovery_ratio_RR = (Corrected_Sequence_Counts /BP_TT_mean_recovery_ratio)/internal_std_normalization_factor) %>%
  mutate(Copies_DR_TT_mean_recovery_ratio_RR = (Corrected_Sequence_Counts /DR_TT_mean_recovery_ratio)/internal_std_normalization_factor)

#Remove ISDs from the data
asv_table <- asv_table %>%
  filter(!ASV_hash %in% bp_ids) %>%
  filter(!ASV_hash %in% dr_ids) %>%
  filter(!ASV_hash %in% tt_ids)

Domain_Totals <- asv_table %>%
  filter(!Domain %in% c("Unassigned")) %>%
  group_by(SampleID, Domain) %>%
  summarise(
    Total_TT_RR     = sum(Copies_TT_RR, na.rm = TRUE),
    Total_BP_RR     = sum(Copies_BP_RR, na.rm = TRUE),
    Total_DR_RR     = sum(Copies_DR_RR, na.rm = TRUE),
    Total_mean_RR   = sum(Copies_mean_RR, na.rm = TRUE),
    Total_median_RR = sum(Copies_median_RR, na.rm = TRUE),
    Total_mean_BP_TT_RR = sum(Copies_BP_DR_mean_recovery_ratio_RR, na.rm = TRUE),
    Total_mean_BP_DR_RR = sum(Copies_BP_TT_mean_recovery_ratio_RR, na.rm = TRUE),
    Total_mean_DR_TT_RR = sum(Copies_DR_TT_mean_recovery_ratio_RR, na.rm = TRUE),
    .groups = "drop"
  )
  
Domain_Totals_long <- Domain_Totals %>%
  pivot_longer(
    cols = starts_with("Total_"),
    names_to = "Method",
    values_to = "Total_Copies"
  ) %>%
  mutate(Method = recode(Method, "Total_TT_RR" = "TT_RR", "Total_BP_RR" = "BP_RR", "Total_DR_RR" = "DR_RR", 
                         "Total_mean_RR" = "Mean_RR", "Total_median_RR" = "Median_RR", "Total_mean_BP_TT_RR" = "BP_TT_RR",
                         "Total_mean_BP_DR_RR" = "BP_DR_RR", "Total_mean_DR_TT_RR" = "DR_TT_RR"))

plot2 <- ggplot(
  Domain_Totals_long,
  aes(x = SampleID, y = Total_Copies, colour = Domain, group = Domain)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_y_log10() +
  facet_wrap(~Method, ncol = 2) +
  theme_minimal() +
  labs(
    title = "Total Copies per unit by Domain and Correction Method",
    y = "Total Copies per unit (log10 scale)",
    x = "Sample"
  ) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
plot2

# TT_RR wide table
asv_table_TT_RR <- asv_table %>% select(SampleID, ASV_hash, Copies_TT_RR) %>%
  group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_TT_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

# BP_RR wide table
asv_table_BP_RR <- asv_table %>% select(SampleID, ASV_hash, Copies_BP_RR) %>% 
  group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_BP_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

# DR_RR wide table
asv_table_DR_RR <- asv_table %>% select(SampleID, ASV_hash, Copies_DR_RR) %>% 
  group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_DR_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

# mean_RR wide table
asv_table_mean_RR <- asv_table %>%
  select(SampleID, ASV_hash, Copies_mean_RR) %>% group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_mean_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

# median_RR wide table
asv_table_median_RR <- asv_table %>%
  select(SampleID, ASV_hash, Copies_median_RR) %>%
  group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_median_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

# mean_BP_DR_RR wide table
asv_table_mean_BP_DR_RR <- asv_table %>%
  select(SampleID, ASV_hash, Copies_BP_DR_mean_recovery_ratio_RR) %>% group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_BP_DR_mean_recovery_ratio_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

# mean_BP_TT_RR wide table
asv_table_mean_BP_TT_RR <- asv_table %>%
  select(SampleID, ASV_hash, Copies_BP_TT_mean_recovery_ratio_RR) %>% group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_BP_TT_mean_recovery_ratio_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

# mean_DR_TT_RR wide table
asv_table_mean_DR_TT_RR <- asv_table %>%
  select(SampleID, ASV_hash, Copies_DR_TT_mean_recovery_ratio_RR) %>% group_by(ASV_hash, SampleID) %>%
  summarise(Abundance = sum(Copies_DR_TT_mean_recovery_ratio_RR, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = SampleID, values_from = Abundance, values_fill = 0)

#Write tsv files - one for each correction method.
write_tsv(asv_table_BP_RR, "asv_table_BP_RR.tsv")
write_tsv(asv_table_DR_RR, "asv_table_DR_RR.tsv")
write_tsv(asv_table_TT_RR, "asv_table_TT_RR.tsv")
write_tsv(asv_table_median_RR, "asv_table_median_RR.tsv")
write_tsv(asv_table_mean_RR, "asv_table_mean_RR.tsv")
write_tsv(asv_table_mean_BP_DR_RR, "asv_table_mean_BP_DR_RR.tsv")
write_tsv(asv_table_mean_BP_TT_RR, "asv_table_mean_BP_TT_RR.tsv")
write_tsv(asv_table_mean_DR_TT_RR, "asv_table_mean_DR_TT_RR.tsv")

#Write plots
# Export plot1
ggsave(filename = "recovery_ratios.pdf", plot = plot1, width = 12, height = 8, units = "in")

# Export plot2
ggsave(filename = "Domain_by_sampleID.pdf", plot = plot2, width = 12, height = 8,units = "in")

#write csv
write_tsv(asv_table, snakemake@output[["corrected"]])
