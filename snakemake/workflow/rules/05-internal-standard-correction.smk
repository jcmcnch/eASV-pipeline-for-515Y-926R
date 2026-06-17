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

"""        
rule identify_intst_ASVS:
    input:
        latestseqs="results/02-proks/04-DADA2d-plaintext-exports/" + config["studyName"] + ".16S.latest_seqs.fasta"
"""

rule intstd_correct_data:
    input:
        asvtable="results/04-formatted/" + config["studyName"] + ".long_data.tsv",
        asvsequences="results/04-formatted/" + config["studyName"] + ".asv_sequences.tsv"
    output:
        corrected=""
    conda:
        "../envs/r-tidyverse-2.0.0.yml"
    log:
        "logs/04-formatting/prepare_long_data.log"
    script:
        "../scripts/long-data-preparation.R"
