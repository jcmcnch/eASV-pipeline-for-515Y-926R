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
        directory("results/02-proks/03-DADA2d/")
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
        directory("results/02-proks/03-DADA2d-plaintext-exports/")
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
        classDB="databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated-sliced_GTGYCAGCMGCCGCGGTAA_CCGYCAATTYMTTTRAGTTT_dereplicated_final_classifier_USE_ME.qza"
    output:
        directory("results/02-proks/05-classified")
    conda:
        config["qiime2version"]
    log:
        "logs/02-denoise-and-export-prok/05-classify-ASVs.log"
    script:
        "../scripts/P05-classify-eASVs.sh"
