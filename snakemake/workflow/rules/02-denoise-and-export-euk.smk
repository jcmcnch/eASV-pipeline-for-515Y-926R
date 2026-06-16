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

rule create_sample_metadata_file_euk:
    input:
        manifest="results/02-euks/manifest-concat.tsv",
        samplesdottsv="config/samples.tsv",
        eukstats=rules.export_DADA2_results_euk.output.lateststats
    output:
        "results/02-euks/sample-metadata.tsv"
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-euk/11-make-sample-metadata-file.log"
    script:
        "../scripts/E11-make-sample-metadata-file.py"

rule make_SILVA_only_euk_barplots:
    input:
        euktable="results/02-euks/08-DADA2d/table.qza",
        euktax=rules.classify_ASVs_euk.output.classified,
        eukmetadata="results/02-euks/sample-metadata.tsv"
    params:
        studyName=config["studyName"]
    output:
        directory("results/02-euks/12-SILVA-only-barplots/")
    conda:
        config["qiime2version"]
    script:
        "../scripts/E12-make-barplot.sh"

rule euk_PR2_reclassify:
    input:
        classifier="databases/classification/PR2/pr2_version_5.1.1_SSU_dada2.clean.culled.derep-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated_final_classifier_USE_ME.qza",
        euktable=rules.denoise_euk_dada2.output.euktable,
        eukseqs=rules.denoise_euk_dada2.output.eukrepseqs
    output:
        PR2classeuk="results/02-euks/14-subsetting/reclassified-PR2/classification.qza",
        fixedtax=directory("results/02-euks/14-subsetting/reclassified-PR2/fixed/"),
        taxasmetadata="results/02-euks/14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata.qzv",
        taxasmetadatafolder=directory("results/02-euks/14-subsetting/reclassified-PR2/fixed/taxonomy-as-metadata/"),
        taxwithoutspaces="results/02-euks/14-subsetting/reclassified-PR2/fixed/taxonomy-without-spaces.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/E14a-PR2-alternative-class.sh"

rule splitmetazoa_euk:
    input:
        euktable=rules.denoise_euk_dada2.output.euktable,
        euktaxSILVA=rules.classify_ASVs_euk.output.classified,
        euktaxPR2=rules.euk_PR2_reclassify.output.taxwithoutspaces,
        eukseqs=rules.denoise_euk_dada2.output.eukrepseqs
    output:
        excludemetazoaSILVAtable="results/02-euks/14-subsetting/split-tables/exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.qza",
        excludemetazoaPR2table="results/02-euks/14-subsetting/split-tables/exclude_Metazoa_PR2_filtered_table.qza",
        includemetazoaSILVAtable="results/02-euks/14-subsetting/split-tables/include_D_3__Metazoa_Animalia_SILVA_filtered_table.qza",
        includemetazoaPR2table="results/02-euks/14-subsetting/split-tables/include_Metazoa_PR2_filtered_table.qza"
    conda:
        config["qiime2version"]
    script:
        "../scripts/E14b-split-metazoans.sh"

rule export_tax_convert_biom_euk:
    input:
        SILVAclassified=rules.classify_ASVs_euk.output.classified,
        PR2classified=rules.euk_PR2_reclassify.output.taxwithoutspaces,
        all18Stable=rules.denoise_euk_dada2.output.euktable,
        excludemetazoaSILVAtable="results/02-euks/14-subsetting/split-tables/exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.qza",
        excludemetazoaPR2table="results/02-euks/14-subsetting/split-tables/exclude_Metazoa_PR2_filtered_table.qza",
        includemetazoaSILVAtable="results/02-euks/14-subsetting/split-tables/include_D_3__Metazoa_Animalia_SILVA_filtered_table.qza",
        includemetazoaPR2table="results/02-euks/14-subsetting/split-tables/include_Metazoa_PR2_filtered_table.qza"
    output:
        SILVAtaxdir=temp(directory("results/02-euks/15-exports/" + config["studyName"] + ".taxonomy-SILVA/")),
        PR2taxdir=temp(directory("results/02-euks/15-exports/" + config["studyName"] + ".taxonomy-PR2/")),
        SILVAtaxfile="results/02-euks/15-exports/" + config["studyName"] + ".taxonomy-SILVA.tsv",
        PR2taxfile="results/02-euks/15-exports/" + config["studyName"] + ".taxonomy-PR2.tsv",
        all18Stablebiom=temp("results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.biom"),
        excludemetazoaSILVAtablebiom=temp("results/02-euks/15-exports/" + config["studyName"] + ".exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.biom"),
        excludemetazoaPR2tablebiom=temp("results/02-euks/15-exports/" + config["studyName"] + ".exclude_Metazoa_PR2_filtered_table.biom"),
        includemetazoaSILVAtablebiom=temp("results/02-euks/15-exports/" + config["studyName"] + ".include_D_3__Metazoa_Animalia_SILVA_filtered_table.biom"),
        includemetazoaPR2tablebiom=temp("results/02-euks/15-exports/" + config["studyName"] + ".include_Metazoa_PR2_filtered_table.biom"),
    conda:
        config["qiime2version"]
    script:
        "../scripts/E15a-generate-biom-tables.sh"

rule add_tax_to_biom_euk:
    input:
        SILVAtaxfile="results/02-euks/15-exports/" + config["studyName"] + ".taxonomy-SILVA.tsv",
        PR2taxfile="results/02-euks/15-exports/" + config["studyName"] + ".taxonomy-PR2.tsv",
        all18Stablebiom="results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.biom",
        excludemetazoaSILVAtablebiom="results/02-euks/15-exports/" + config["studyName"] + ".exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.biom",
        excludemetazoaPR2tablebiom="results/02-euks/15-exports/" + config["studyName"] + ".exclude_Metazoa_PR2_filtered_table.biom",
        includemetazoaSILVAtablebiom="results/02-euks/15-exports/" + config["studyName"] + ".include_D_3__Metazoa_Animalia_SILVA_filtered_table.biom",
        includemetazoaPR2tablebiom="results/02-euks/15-exports/" + config["studyName"] + ".include_Metazoa_PR2_filtered_table.biom",
    output:
        all18StablebiomSILVAtax=temp("results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.with-SILVA-tax.biom"),
        all18StablebiomPR2tax=temp("results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.with-PR2-tax.biom"),
        excludemetazoaSILVAtablebiomtax=temp("results/02-euks/15-exports/" + config["studyName"] + ".exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.with-tax.biom"),
        excludemetazoaPR2tablebiomtax=temp("results/02-euks/15-exports/" + config["studyName"] + ".exclude_Metazoa_PR2_filtered_table.with-tax.biom"),
        includemetazoaSILVAtablebiomtax=temp("results/02-euks/15-exports/" + config["studyName"] + ".include_D_3__Metazoa_Animalia_SILVA_filtered_table.with-tax.biom"),
        includemetazoaPR2tablebiomtax=temp("results/02-euks/15-exports/" + config["studyName"] + ".include_Metazoa_PR2_filtered_table.with-tax.biom"),
    conda:
        config["qiime2version"]
    script:
        "../scripts/E15b-add-tax-to-biom.sh"

rule export_biom_tsv_euk:
    input:
        all18StablebiomSILVAtax="results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.with-SILVA-tax.biom",
        all18StablebiomPR2tax="results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.with-PR2-tax.biom",
        excludemetazoaSILVAtablebiomtax="results/02-euks/15-exports/" + config["studyName"] + ".exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.with-tax.biom",
        excludemetazoaPR2tablebiomtax="results/02-euks/15-exports/" + config["studyName"] + ".exclude_Metazoa_PR2_filtered_table.with-tax.biom",
        includemetazoaSILVAtablebiomtax="results/02-euks/15-exports/" + config["studyName"] + ".include_D_3__Metazoa_Animalia_SILVA_filtered_table.with-tax.biom",
        includemetazoaPR2tablebiomtax="results/02-euks/15-exports/" + config["studyName"] + ".include_Metazoa_PR2_filtered_table.with-tax.biom",
    output:
        all18StablebiomSILVAtaxtsv="results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.with-SILVA-tax.tsv",
        all18StablebiomPR2taxtsv="results/02-euks/15-exports/" + config["studyName"] + ".all-18S-seqs.with-PR2-tax.tsv",
        excludemetazoaSILVAtablebiomtaxtsv="results/02-euks/15-exports/" + config["studyName"] + ".exclude_D_3__Metazoa_Animalia_SILVA_filtered_table.with-tax.tsv",
        excludemetazoaPR2tablebiomtaxtsv="results/02-euks/15-exports/" + config["studyName"] + ".exclude_Metazoa_PR2_filtered_table.with-tax.tsv",
        includemetazoaSILVAtablebiomtaxtsv="results/02-euks/15-exports/" + config["studyName"] + ".include_D_3__Metazoa_Animalia_SILVA_filtered_table.with-tax.tsv",
        includemetazoaPR2tablebiomtaxtsv="results/02-euks/15-exports/" + config["studyName"] + ".include_Metazoa_PR2_filtered_table.with-tax.tsv",
    conda:
        config["qiime2version"]
    script:
        "../scripts/E15c-export-tax-tsvs.sh"
