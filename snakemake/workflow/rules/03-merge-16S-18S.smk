rule merge_prok_euk:
    input:
        raw16S="",
        raw18S="",
        stats16S="",
        stats18S="",
        read_summary="",
        bioanalyzer=""
    output:
        mergedtable="",
    conda:
        "../envs/r-tidyverse-2.0.0.yml"
    log:
        "logs/03-merging/merge_prok_euk.log"
    script:
        "../scripts/correct_16S_18S_ASV-snakemake-v1.R"

