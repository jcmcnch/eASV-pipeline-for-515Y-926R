rule merge_prok_euk:
    input:
        raw16S="results/02-proks/10-exports/all-16S-seqs.with-tax.tsv",
        raw18S="results/02-euks/15-exports/all-18S-seqs.with-PR2-tax.tsv",
        stats16S="results/02-proks/04-DADA2d-plaintext-exports/tutorial.16S.latest_stats.tsv",
        stats18S="results/02-euks/09-DADA2d-plaintext-exports/tutorial.18S.latest_stats.tsv",
        read_summary="results/eukfrac-all.tsv",
        bioanalyzer="config/bioanalyzer.tsv"
    output:
        mergedtableuncorrected="results/03-merged/merged_uncorected.tsv",
        mergedtabledada2="results/03-merged/merged_dada2_corrected.tsv",
        mergedtabledada218Scorrected="results/03-merged/merged_dada2_18S_corrected.tsv"
    conda:
        "../envs/r-tidyverse-2.0.0.yml"
    log:
        "logs/03-merging/merge_prok_euk.log"
    script:
        "../scripts/correct_16S_18S_ASV-snakemake-v1.R"

