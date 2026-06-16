rule prepare_long_data:
    input:
        mergedtableuncorrected="results/03-merged/" + config["studyName"] + ".merged_uncorected.tsv",
        mergedtabledada2="results/03-merged/" + config["studyName"] + ".merged_dada2_corrected.tsv",
        mergedtabledada218Scorrected="results/03-merged/" + config["studyName"] + ".merged_dada2_18S_corrected.tsv",
        fasta16S=="results/02-proks/04-DADA2d-plaintext-exports/" + config["studyName"] + ".16S.latest_seqs.fasta",
        fasta18S="results/02-euks/09-DADA2d-plaintext-exports/" + config["studyName"] + ".18S.latest_seqs.fasta"        
    output:
        longdata="results/04-formatted/" + config["studyName"] + ".long_data.tsv",
        asvsequences="results/04-formatted/"  + config["studyName"] + ".asv_sequences.tsv"
    conda:
        "../envs/r-tidyverse-2.0.0.yml"
    log:
        "logs/04-formatting/prepare_long_data.log"
    script:
        "../scripts/long-data-preparation.R"
