rule create_manifest_prok:
    input:
        r1=expand("results/01-split/{sample}.prok.R1.fastq.gz", sample=samples["sample"]),
        r2=expand("results/01-split/{sample}.prok.R2.fastq.gz", sample=samples["sample"])
    output:
        "results/02-proks/manifest.tsv"
    conda:
        config["qiime2version"]
    script:
        "../scripts/P00-create-manifest.sh"

rule import_prok:
    input:
        "results/02-proks/manifest.tsv"
    output:
        "results/02-proks/16S.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/P01-import.sh"

rule visualize_prok_seq_quality:
    input:
        "results/02-proks/16S.qza"
    output:
        directory("results/02-proks/02-quality-plots-R1-R2/")
    conda:
        config["qiime2version"]
    script:
        "../scripts/P02-visualize-quality_R1-R2.sh"

rule denoise_prok_dada2:
    input:
        "results/02-proks/16S.qza"
    params:
        truncR1=config["trunclens"]["truncR1"],
        truncR2=config["trunclens"]["truncR2"]
    output:
        directory("results/02-proks/03-DADA2d/"),
        prokrepseqs="results/02-proks/03-DADA2d/representative_sequences.qza",
        prokstats="results/02-proks/03-DADA2d/denoising_stats.qza",
        proktable="results/02-proks/03-DADA2d/table.qza"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-prok/03-DADA2/DADA2.stderrout"
    script:
        "../scripts/P03-DADA2.sh"

rule export_DADA2_results:
    input:
        directory("results/02-proks/03-DADA2d/")
    params:
        studyName=config["studyName"]
    output:
        directory("results/02-proks/04-DADA2d-plaintext-exports/"),
        lateststats="results/02-proks/04-DADA2d-plaintext-exports/" + config["studyName"] + "16S.latest_stats.tsv",
        latestseqs="results/02-proks/04-DADA2d-plaintext-exports/" + config["studyName"] + "16S.latest_seqs.fasta"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-prok/04_export_DADA2_results/DADA2_export.stderrout"
    script:
        "../scripts/P04-export-DADA2-results.sh"

rule classify_ASVs:
    input:
        "results/02-proks/03-DADA2d/representative_sequences.qza"
    params:
        classDB=rules.train_classifier.output,
    output:
        directory("results/02-proks/05-classified/"),
        classified="results/02-proks/05-classified/" + config["studyName"] + "_SILVA.classified.qza"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-prok/05-classify-ASVs.log"
    script:
        "../scripts/P05-classify-eASVs.sh"

rule create_sample_metadata_file:
    input:
        manifest="results/02-proks/manifest.tsv",
        samplesdottsv="config/samples.tsv",
        prokstats=rules.export_DADA2_results.output.lateststats
    output:
        "results/02-proks/sample-metadata.tsv"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-prok/06-make-sample-metadata-file.log"
    script:
        "../scripts/P06-make-sample-metadata-file.py"

rule make_SILVA_only_prok_barplots:
    input:
        proktable="results/02-proks/03-DADA2d/table.qza",
        proktax=rules.classify_ASVs.output.classified,
        prokmetadata="results/02-proks/sample-metadata.tsv"
    params:
        studyName=config["studyName"]
    output:
        directory("results/02-proks/07-SILVA-only-barplots/")
    conda:
        config["qiime2version"]
    script:
        "../scripts/P07-make-barplot.sh"

rule splitchloroplasts:
    input:
        proktable=rules.denoise_prok_dada2.output.proktable,
        proktax=rules.classify_ASVs.output.classified,
        prokseqs=rules.denoise_prok_dada2.output.prokrepseqs
    output:
        includechlorotable="results/02-proks/09-subsetting/split-tables/include_o__Chloroplast_filtered_table.qza",
        excludechlorotable="results/02-proks/09-subsetting/split-tables/exclude_o__Chloroplast_filtered_table.qza",
        includechloroseqs="results/02-proks/09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_subset_filtered_seqs.qza",
        excludechloroseqs="results/02-proks/09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/P09a-split-chloroplast.sh"

rule reclassify_chloro_split_tables:
    input:
        PR2classifier="databases/classification/PR2/pr2_version_5.1.1_SSU_dada2.clean.culled.derep-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated_final_classifier_USE_ME.qza",
        proktable=rules.denoise_prok_dada2.output.proktable,
        proktax=rules.classify_ASVs.output.classified,
        includechloroseqs=rules.splitchloroplasts.output.includechloroseqs
    output:
        PR2classifiedchloroseqs="results/02-proks/09-subsetting/reclassified/include_o__Chloroplast_subset_reclassified_PR2.qza",
        mergedclass="results/02-proks/09-subsetting/tax-merged/chloroplasts-PR2-reclassified-merged-classification.qza",
        onlymitotable="results/02-proks/09-subsetting/split-tables/include_f__Mitochondria_filtered_table.qza",
        onlyalgaetable="results/02-proks/09-subsetting/split-tables/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza",
        onlycyanotable="results/02-proks/09-subsetting/split-tables/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.qza",
        nomitotable="results/02-proks/09-subsetting/split-tables/exclude_f__Mitochondria_filtered_table.qza",
        nomitonochlorotable="results/02-proks/09-subsetting/split-tables/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.qza",
        nomitonochloronocyanotable="results/02-proks/09-subsetting/split-tables/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.qza",
        onlyarchaeatable="results/02-proks/09-subsetting/split-tables/include_d__Archaea_filtered_table.qza",
        noarchaeatable="results/02-proks/09-subsetting/split-tables/exclude_d__Archaea_filtered_table.qza" 
    params:
        studyName=config["studyName"]
    conda:
        config["qiime2version"]
    script:
        "../scripts/P09b-PR2-reclassify-chloroplasts-split-categories.sh"

rule export_tax_convert_biom:
    input:
        mergedtax=rules.reclassify_chloro_split_tables.output.mergedclass,
        all16Stable="results/02-proks/03-DADA2d/table.qza",
        noarch="results/02-proks/09-subsetting/split-tables/exclude_d__Archaea_filtered_table.qza",
        nomito="results/02-proks/09-subsetting/split-tables/exclude_f__Mitochondria_filtered_table.qza",
        nochloronomito="results/02-proks/09-subsetting/split-tables/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.qza",
        nochloro="results/02-proks/09-subsetting/split-tables/exclude_o__Chloroplast_filtered_table.qza",
        nochloronocyanonomito="results/02-proks/09-subsetting/split-tables/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.qza",
        onlyarch="results/02-proks/09-subsetting/split-tables/include_d__Archaea_filtered_table.qza",
        onlymito="results/02-proks/09-subsetting/split-tables/include_f__Mitochondria_filtered_table.qza",
        onlychloro="results/02-proks/09-subsetting/split-tables/include_o__Chloroplast_filtered_table.qza",
        onlycyano="results/02-proks/09-subsetting/split-tables/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.qza",
        onlyalgae="results/02-proks/09-subsetting/split-tables/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza",
    output:
        mergedtaxtsv="results/02-proks/10-exports/taxonomy.tsv",
        all16Stable_biom=temp("results/02-proks/10-exports/all-16S-seqs.biom"),
        noarch_biom=temp("results/02-proks/10-exports/exclude_d__Archaea_filtered_table.biom"),
        nomito_biom=temp("results/02-proks/10-exports/exclude_f__Mitochondria_filtered_table.biom"),
        nochloronomito_biom=temp("results/02-proks/10-exports/exclude_o__Chloroplast_exclude_f__Mitochondria_filtered_table.biom"),
        nochloro_biom=temp("results/02-proks/10-exports/exclude_o__Chloroplast_filtered_table.biom"),
        nochloronocyanonomito_biom=temp("results/02-proks/10-exports/exclude_p__Cyanobacteria_exclude_f__Mitochondria_NOTE_excludes_chloroplasts_filtered_table.biom"),
        onlyarch_biom=temp("results/02-proks/10-exports/include_d__Archaea_filtered_table.biom"),
        onlymito_biom=temp("results/02-proks/10-exports/include_f__Mitochondria_filtered_table.biom"),
        onlychloro_biom=temp("results/02-proks/10-exports/include_o__Chloroplast_filtered_table.biom"),
        onlycyano_biom=temp("results/02-proks/10-exports/include_p__Cyanobacteria_exclude_o__Chloroplast_filtered_table.biom"),
        onlyalgae_biom="results/02-proks/10-exports/include_p__Cyanobacteria_NOTE_includes_chloroplasts_filtered_table.qza.biom",
    conda:
        config["qiime2version"]
    script:
        "../scripts/P10a-generate-biom-tables.sh"
