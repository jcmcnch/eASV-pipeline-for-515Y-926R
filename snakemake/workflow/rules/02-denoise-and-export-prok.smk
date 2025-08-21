rule create_manifest_prok:
    input:
        r1=expand("results/01-split/{sample}.prok.R1.fastq.gz", sample=samples["sample"]),
        r2=expand("results/01-split/{sample}.prok.R2.fastq.gz", sample=samples["sample"])
    output:
        "results/02-proks/manifest.tsv"
    conda:
        "../envs/qiime2-amplicon-ubuntu-2025-7-conda.yml"
    script:
        "../scripts/P00-create-manifest.sh"

rule import_prok:
    input:
        "results/02-proks/manifest.tsv"
    output:
        "results/02-proks/16S.qza"
    conda:
        "../envs/qiime2-amplicon-ubuntu-2025-7-conda.yml"
    script:
        "../scripts/P01-import.sh"

rule visualize_prok_seq_quality:
    input:
        "results/02-proks/16S.qza"
    output:
        directory("results/02-proks/02-quality-plots-R1-R2/")
    conda:
        "../envs/qiime2-amplicon-ubuntu-2025-7-conda.yml"
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
        "../envs/qiime2-amplicon-ubuntu-2025-7-conda.yml"
    log:
        "logs/02-denoise-and-export-prok/03-DADA2/DADA2.stderrout"
    script:
        "../scripts/P03-DADA2.sh"
