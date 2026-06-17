rule prepare_16S_BLASTdb:
    input:
        BP="config/intstd_fastas/" + config["intstds"]["BP"] + ".fasta",
        DR="config/intstd_fastas/" + config["intstds"]["DR"] + ".fasta",
        TT="config/intstd_fastas/" + config["intstds"]["TT"] + ".fasta"
    output:
        BP="config/intstd_fastas/" + config["intstds"]["BP"] + ".fasta.nhr",
        DR="config/intstd_fastas/" + config["intstds"]["DR"] + ".fasta.nhr",
        TT="config/intstd_fastas/" + config["intstds"]["TT"] + ".fasta.nhr"
    conda:
        "../envs/blast-env.yaml"
    script:
        "../scripts/B00-makeblastdb.sh"

        
rule identify_intsd_ASVS:
    input:
        latestseqs="results/02-proks/04-DADA2d-plaintext-exports/" + config["studyName"] + ".16S.latest_seqs.fasta",
        BP="config/intstd_fastas/" + config["intstds"]["BP"] + ".fasta.nhr",
        DR="config/intstd_fastas/" + config["intstds"]["DR"] + ".fasta.nhr",
        TT="config/intstd_fastas/" + config["intstds"]["TT"] + ".fasta.nhr"
    output:
        BPtsv="config/intstd_fastas/" + config["intstds"]["BP"] + ".asvs.outfmt6.tsv",
        BPasvs="config/intstd_fastas/" + config["intstds"]["BP"] + ".asvs.txt",
        DRtsv="config/intstd_fastas/" + config["intstds"]["DR"] + ".asvs.outfmt6.tsv",
        DRasvs="config/intstd_fastas/" + config["intstds"]["DR"] + ".asvs.txt",
        TTtsv="config/intstd_fastas/" + config["intstds"]["TT"] + ".asvs.outfmt6.tsv",
        TTasvs="config/intstd_fastas/" + config["intstds"]["TT"] + ".asvs.txt"
    conda:
        "../envs/blast-env.yaml"
    script:
        "../scripts/B01-blast-ASVs.sh"

rule intstd_correct_data:
    input:
        asv_table="results/04-formatted/" + config["studyName"] + ".long_data.tsv",
        BPasvs="config/intstd_fastas/" + config["intstds"]["BP"] + ".asvs.txt",
        DRasvs="config/intstd_fastas/" + config["intstds"]["DR"] + ".asvs.txt",
        TTasvs="config/intstd_fastas/" + config["intstds"]["TT"] + ".asvs.txt",
        isd="config/internal_stds.tsv",
        isd_added="config/samples.tsv"
    output:
        corrected="results/05-internal-std-corrected/" + config["studyName"] + ".ISD_corrected_asv_table.tsv"
    conda:
        "../envs/r-tidyverse-2.0.0.yml"
    log:
        "logs/05-internal-std-correction/prepare_long_data_corrected.log"
    script:
        "../scripts/correct-w-isds-snakemake-v4.R"
