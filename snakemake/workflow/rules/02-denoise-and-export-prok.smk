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

"""
rule import_prok:
    input:
        "results/01-split/{sample}.prok.fastq"
    output:
        out="results/01-split/{sample}.prok.R1.fastq.gz",
        out2="results/01-split/{sample}.prok.R2.fastq.gz"
    conda:
        "../envs/qiime2-amplicon-ubuntu-2025-7-conda.yml"
    shell:
        "bbsplit.sh build=1 ref={input.file1},{input.file2} path={output}"

    log:
        "logs/x.log"

    params:
        command="reformat.sh",
        overwrite=True,  # recommended
        pigz=True,
    threads: 4
    resources:
        mem_mb=4000,  # optional: bbmap normaly needs a lot of memory, e.g. 60GB
    wrapper:
        "v7.2.0/bio/bbtools"
"""
