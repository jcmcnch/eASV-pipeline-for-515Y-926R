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
        "results/02-proks/manifest.tsv",
        "config/samples.tsv",
        "results/02-proks/04-DADA2d-plaintext-exports/" + config["studyName"] + "16S.latest_stats.tsv"
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

rule split_chloroplasts:
    input:
        proktable=rules.denoise_prok_dada2.output.proktable,
        proktax=rules.classify_ASVs.output.classified,
        prokseqs=rules.denoise_prok_dada2.output.prokrepseqs
    output:
        includechlorotable="results/02-proks/09-subsetting/split-tables/include_o__Chloroplast_filtered_table.qza",
        excludechlorotable="results/02-proks/09-subsetting/split-tables/exclude_o__Chloroplast_filtered_table.qza",
        includechloroseqs="results/02-proks/09-subsetting/split-seqs/include_o__Chloroplast_subset_filtered_s",
        excludechloroseqs="results/02-proks/09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/P09a-split-chloroplast.sh"
