rule create_manifest_euk_viz:
    input:
        r1=expand("results/01-split/{sample}.euk.R1.fastq.gz", sample=samples["sample"]),
        r2=expand("results/01-split/{sample}.euk.R2.fastq.gz", sample=samples["sample"])
    output:
        "results/02-euks/manifest-viz.tsv"
    conda:
        config["qiime2version"]
    script:
        "../scripts/E00-create-manifest.sh"

rule import_euk_viz:
    input:
        "results/02-euks/manifest-viz.tsv"
    output:
        "results/02-euks/18S-viz.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/E01-import.sh"

rule visualize_euk_seq_quality:
    input:
        "results/02-euks/18S-viz.qza"
    output:
        directory("results/02-euks/02-quality-plots-R1-R2/")
    conda:
        config["qiime2version"]
    script:
        "../scripts/E02-visualize-quality_R1-R2.sh"

rule bbduk_cut_reads:
    input:
        r1="results/01-split/{sample}.euk.R1.fastq.gz",
        r2="results/01-split/{sample}.euk.R2.fastq.gz"
    output:
        r1=temp("results/02-euks/03-size-selected/{sample}.euk.R1.trimmed.fastq"),
        r2=temp("results/02-euks/03-size-selected/{sample}.euk.R2.trimmed.fastq")
    params:
        truncR1=config["trunclens"]["truncR1"],
        truncR2=config["trunclens"]["truncR2"]
    conda:
        "../envs/bbmap.yaml"
    log:
        "logs/euk-trimming.{sample}.log"
    script:
        "../scripts/E03-bbduk-cut-reads.sh"

rule fuse_trimmed_euk_seqs:
    input:
        r1=rules.bbduk_cut_reads.output.r1,
        r2=rules.bbduk_cut_reads.output.r2
    output:
        "results/02-euks/04-concatenated/{sample}.euk.concatenated.fastq",
    conda:
        "../envs/bbmap.yaml"
    log:
        "logs/euk-fusing.{sample}.log"
    script:
        "../scripts/E04-fuse-EUKs-withoutNs.sh"

rule create_manifest_euk_concat:
    input:
        files=expand("results/02-euks/04-concatenated/{sample}.euk.concatenated.fastq", sample=samples["sample"])
    output:
        "results/02-euks/manifest-concat.tsv"
    conda:
        config["qiime2version"]
    script:
        "../scripts/E05-create-manifest-concat.sh"

rule import_euk_concat:
    input:
        "results/02-euks/manifest-concat.tsv"
    output:
        "results/02-euks/18S-concat.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/E06-import-concat.sh"

rule visualize_quality_single_seqs:
    input:
        "results/02-euks/18S-concat.qza"
    output:
        directory("results/02-euks/07-quality-plots-concat/")
    conda:
        config["qiime2version"]
    script:
        "../scripts/E07-visualize-quality-single-seqs.sh"

rule denoise_euk_dada2:
    input:
        "results/02-euks/18S-concat.qza"
    output:
        directory("results/02-euks/08-DADA2d/"),
        eukrepseqs="results/02-euks/08-DADA2d/representative_sequences.qza",
        eukstats="results/02-euks/08-DADA2d/denoising_stats.qza",
        euktable="results/02-euks/08-DADA2d/table.qza"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-euk/08-DADA2/DADA2.stderrout"
    script:
        "../scripts/E08-DADA2.sh"

rule export_DADA2_results_euk:
    input:
        directory("results/02-euks/08-DADA2d/")
    params:
        studyName=config["studyName"]
    output:
        directory("results/02-euks/09-DADA2d-plaintext-exports/"),
        lateststats="results/02-euks/09-DADA2d-plaintext-exports/" + config["studyName"] + ".18S.latest_stats.tsv",
        latestseqs="results/02-euks/09-DADA2d-plaintext-exports/" + config["studyName"] + ".18S.latest_seqs.fasta"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-euk/09_export_DADA2_results/DADA2_export.stderrout"
    script:
        "../scripts/E09-export-DADA2-results.sh"

rule classify_ASVs_euk:
    input:
        "results/02-euks/08-DADA2d/representative_sequences.qza"
    params:
        classDB=rules.train_classifier_pr2.output,
    output:
        directory("results/02-euks/10-classified/"),
        classified="results/02-euks/10-classified/" + config["studyName"] + "_SILVA.classified.qza"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-euk/10-classify-ASVs.log"
    script:
        "../scripts/E10-classify-seqs.sh"
"""
rule create_sample_metadata_file:
    input:
        manifest="results/02-euks/manifest.tsv",
        samplesdottsv="config/samples.tsv",
        eukstats=rules.export_DADA2_results.output.lateststats
    output:
        "results/02-euks/sample-metadata.tsv"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-euk/06-make-sample-metadata-file.log"
    script:
        "../scripts/P06-make-sample-metadata-file.py"

rule make_SILVA_only_euk_barplots:
    input:
        euktable="results/02-euks/08-DADA2d/table.qza",
        euktax=rules.classify_ASVs.output.classified,
        eukmetadata="results/02-euks/sample-metadata.tsv"
    params:
        studyName=config["studyName"]
    output:
        directory("results/02-euks/07-SILVA-only-barplots/")
    conda:
        config["qiime2version"]
    script:
        "../scripts/P07-make-barplot.sh"

rule splitchloroplasts:
    input:
        euktable=rules.denoise_euk_dada2.output.euktable,
        euktax=rules.classify_ASVs.output.classified,
        eukseqs=rules.denoise_euk_dada2.output.eukrepseqs
    output:
        includechlorotable="results/02-euks/09-subsetting/split-tables/include_o__Chloroplast_filtered_table.qza",
        excludechlorotable="results/02-euks/09-subsetting/split-tables/exclude_o__Chloroplast_filtered_table.qza",
        includechloroseqs="results/02-euks/09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_subset_filtered_seqs.qza",
        excludechloroseqs="results/02-euks/09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/P09a-split-chloroplast.sh"

rule reclassify_chloro_split_tables:
    input:
        PR2classifier="databases/classification/PR2/pr2_version_5.1.1_SSU_dada2.clean.culled.derep-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated_final_classifier_USE_ME.qza",
        euktable=rules.denoise_euk_dada2.output.euktable,
        euktax=rules.classify_ASVs.output.classified,
        includechloroseqs=rules.splitchloroplasts.output.includechloroseqs
    output:
        PR2classifiedchloroseqs="results/02-euks/09-subsetting/reclassified/include_o__Chloroplast_subset_reclassified_PR2.qza",
        mergedclass="results/02-euks/09-subsetting/tax-merged/chloroplasts-PR2-reclassified-merged-classification.qza",
        onlymitotable="results/02-euks/09-subsetting/split-tables/include_f__Mitochondria_filtered_table.qza",
        onlyalgaetable="results/02-euks/09-subsetting/split-tables/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza",
        onlycyanotable="results/02-euks/09-subsetting/split-tables/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.qza",
        nomitotable="results/02-euks/09-subsetting/split-tables/exclude_f__Mitochondria_filtered_table.qza",
        nomitonochlorotable="results/02-euks/09-subsetting/split-tables/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.qza",
        nomitonochloronocyanotable="results/02-euks/09-subsetting/split-tables/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.qza",
        onlyarchaeatable="results/02-euks/09-subsetting/split-tables/include_d__Archaea_filtered_table.qza",
        noarchaeatable="results/02-euks/09-subsetting/split-tables/exclude_d__Archaea_filtered_table.qza" 
    params:
        studyName=config["studyName"]
    conda:
        config["qiime2version"]
    script:
        "../scripts/P09b-PR2-reclassify-chloroplasts-split-categories.sh"

rule export_tax_convert_biom:
    input:
        mergedtax=rules.reclassify_chloro_split_tables.output.mergedclass,
        all16Stable="results/02-euks/08-DADA2d/table.qza",
        noarch="results/02-euks/09-subsetting/split-tables/exclude_d__Archaea_filtered_table.qza",
        nomito="results/02-euks/09-subsetting/split-tables/exclude_f__Mitochondria_filtered_table.qza",
        nochloronomito="results/02-euks/09-subsetting/split-tables/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.qza",
        nochloro="results/02-euks/09-subsetting/split-tables/exclude_o__Chloroplast_filtered_table.qza",
        nochloronocyanonomito="results/02-euks/09-subsetting/split-tables/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.qza",
        onlyarch="results/02-euks/09-subsetting/split-tables/include_d__Archaea_filtered_table.qza",
        onlymito="results/02-euks/09-subsetting/split-tables/include_f__Mitochondria_filtered_table.qza",
        onlychloro="results/02-euks/09-subsetting/split-tables/include_o__Chloroplast_filtered_table.qza",
        onlycyano="results/02-euks/09-subsetting/split-tables/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.qza",
        onlyalgae="results/02-euks/09-subsetting/split-tables/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza",
    output:
        mergedtaxtsv="results/02-euks/10-exports/taxonomy.tsv",
        all16Stable_biom=temp("results/02-euks/10-exports/all-16S-seqs.biom"),
        noarch_biom=temp("results/02-euks/10-exports/exclude_d__Archaea_filtered_table.biom"),
        nomito_biom=temp("results/02-euks/10-exports/exclude_f__Mitochondria_filtered_table.biom"),
        nochloronomito_biom=temp("results/02-euks/10-exports/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.biom"),
        nochloro_biom=temp("results/02-euks/10-exports/exclude_o__Chloroplast_filtered_table.biom"),
        nochloronocyanonomito_biom=temp("results/02-euks/10-exports/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.biom"),
        onlyarch_biom=temp("results/02-euks/10-exports/include_d__Archaea_filtered_table.biom"),
        onlymito_biom=temp("results/02-euks/10-exports/include_f__Mitochondria_filtered_table.biom"),
        onlychloro_biom=temp("results/02-euks/10-exports/include_o__Chloroplast_filtered_table.biom"),
        onlycyano_biom=temp("results/02-euks/10-exports/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.biom"),
        onlyalgae_biom=temp("results/02-euks/10-exports/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza.biom"),
    conda:
        config["qiime2version"]
    script:
        "../scripts/P10a-generate-biom-tables.sh"

rule add_tax_to_biom:
    input:
        mergedtaxtsv="results/02-euks/10-exports/taxonomy.tsv",
        all16Stable_biom="results/02-euks/10-exports/all-16S-seqs.biom",
        noarch_biom="results/02-euks/10-exports/exclude_d__Archaea_filtered_table.biom",
        nomito_biom="results/02-euks/10-exports/exclude_f__Mitochondria_filtered_table.biom",
        nochloronomito_biom="results/02-euks/10-exports/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.biom",
        nochloro_biom="results/02-euks/10-exports/exclude_o__Chloroplast_filtered_table.biom",
        nochloronocyanonomito_biom="results/02-euks/10-exports/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.biom",
        onlyarch_biom="results/02-euks/10-exports/include_d__Archaea_filtered_table.biom",
        onlymito_biom="results/02-euks/10-exports/include_f__Mitochondria_filtered_table.biom",
        onlychloro_biom="results/02-euks/10-exports/include_o__Chloroplast_filtered_table.biom",
        onlycyano_biom="results/02-euks/10-exports/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.biom",
        onlyalgae_biom="results/02-euks/10-exports/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza.biom",
    output:
        all16Stable_biomtax=temp("results/02-euks/10-exports/all-16S-seqs.with-tax.biom"),
        noarch_biomtax=temp("results/02-euks/10-exports/exclude_d__Archaea_filtered_table.with-tax.biom"),
        nomito_biomtax=temp("results/02-euks/10-exports/exclude_f__Mitochondria_filtered_table.with-tax.biom"),
        nochloronomito_biomtax=temp("results/02-euks/10-exports/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.with-tax.biom"),
        nochloro_biomtax=temp("results/02-euks/10-exports/exclude_o__Chloroplast_filtered_table.with-tax.biom"),
        nochloronocyanonomito_biomtax=temp("results/02-euks/10-exports/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.with-tax.biom"),
        onlyarch_biomtax=temp("results/02-euks/10-exports/include_d__Archaea_filtered_table.with-tax.biom"),
        onlymito_biomtax=temp("results/02-euks/10-exports/include_f__Mitochondria_filtered_table.with-tax.biom"),
        onlychloro_biomtax=temp("results/02-euks/10-exports/include_o__Chloroplast_filtered_table.with-tax.biom"),
        onlycyano_biomtax=temp("results/02-euks/10-exports/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.with-tax.biom"),
        onlyalgae_biomtax=temp("results/02-euks/10-exports/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza.with-tax.biom")
    conda:
        config["qiime2version"]
    script:
        "../scripts/P10b-add-tax-to-biom.sh"

rule export_biom_tsv:
    input:
        all16Stable_biomtax="results/02-euks/10-exports/all-16S-seqs.with-tax.biom",
        noarch_biomtax="results/02-euks/10-exports/exclude_d__Archaea_filtered_table.with-tax.biom",
        nomito_biomtax="results/02-euks/10-exports/exclude_f__Mitochondria_filtered_table.with-tax.biom",
        nochloronomito_biomtax="results/02-euks/10-exports/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.with-tax.biom",
        nochloro_biomtax="results/02-euks/10-exports/exclude_o__Chloroplast_filtered_table.with-tax.biom",
        nochloronocyanonomito_biomtax="results/02-euks/10-exports/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.with-tax.biom",
        onlyarch_biomtax="results/02-euks/10-exports/include_d__Archaea_filtered_table.with-tax.biom",
        onlymito_biomtax="results/02-euks/10-exports/include_f__Mitochondria_filtered_table.with-tax.biom",
        onlychloro_biomtax="results/02-euks/10-exports/include_o__Chloroplast_filtered_table.with-tax.biom",
        onlycyano_biomtax="results/02-euks/10-exports/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.with-tax.biom",
        onlyalgae_biomtax="results/02-euks/10-exports/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza.with-tax.biom",
    output:
        all16Stable_biomtaxtsv="results/02-euks/10-exports/all-16S-seqs.with-tax.tsv",
        noarch_biomtaxtsv="results/02-euks/10-exports/exclude_d__Archaea_filtered_table.with-tax.tsv",
        nomito_biomtaxtsv="results/02-euks/10-exports/exclude_f__Mitochondria_filtered_table.with-tax.tsv",
        nochloronomito_biomtaxtsv="results/02-euks/10-exports/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.with-tax.tsv",
        nochloro_biomtaxtsv="results/02-euks/10-exports/exclude_o__Chloroplast_filtered_table.with-tax.tsv",
        nochloronocyanonomito_biomtaxtsv="results/02-euks/10-exports/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.with-tax.tsv",
        onlyarch_biomtaxtsv="results/02-euks/10-exports/include_d__Archaea_filtered_table.with-tax.tsv",
        onlymito_biomtaxtsv="results/02-euks/10-exports/include_f__Mitochondria_filtered_table.with-tax.tsv",
        onlychloro_biomtaxtsv="results/02-euks/10-exports/include_o__Chloroplast_filtered_table.with-tax.tsv",
        onlycyano_biomtaxtsv="results/02-euks/10-exports/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.with-tax.tsv",
        onlyalgae_biomtaxtsv="results/02-euks/10-exports/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.with-tax.tsv",
    conda:
        config["qiime2version"]
    script:
        "../scripts/P10c-export-tax-tsvs.sh"
"""
