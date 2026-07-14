rule bbsplit_prok_euk:
    input:
        r1="results/00-trimmed/{sample}.1.fastq",
        r2="results/00-trimmed/{sample}.2.fastq"
    output:
        prok=temp("results/01-split/{sample}.prok.fastq"),
        euk=temp("results/01-split/{sample}.euk.fastq"),
    conda:
        "../envs/bbmap.yaml"
    resources:
        mem_mb=4000,
    log:
        "logs/01-splitting/{sample}_bbsplit.log"
    shell:
        "bbsplit.sh usequality=f qtrim=f minratio=0.30 minid=0.30 pairedonly=f path=databases/bbsplit-db/EUK-PROK-bbsplit-db/ in={input.r1} in2={input.r2} out_SILVA_132_PROK.cdhit95pc={output.prok} out_SILVA_132_and_PR2_EUK.cdhit95pc={output.euk} 2>&1 | tee -a {log}"

rule deinterleave_split_reads_euk:
    input:
        "results/01-split/{sample}.euk.fastq"
    output:
        out="results/01-split/{sample}.euk.R1.fastq.gz",
        out2="results/01-split/{sample}.euk.R2.fastq.gz"
    params:
        command="reformat.sh",
        overwrite=True,  # recommended
        pigz=True,
    threads: 4 
    resources:
        mem_mb=4000,  # optional: bbmap normaly needs a lot of memory, e.g. 60GB
    wrapper:
        "v8.0.3/bio/bbtools"

rule deinterleave_split_reads_prok:
    input:
        "results/01-split/{sample}.prok.fastq"
    output:
        out="results/01-split/{sample}.prok.R1.fastq.gz",
        out2="results/01-split/{sample}.prok.R2.fastq.gz"
    params:
        command="reformat.sh",
        overwrite=True,  # recommended
        pigz=True,
    threads: 4
    resources:
        mem_mb=4000,  # optional: bbmap normally needs a lot of memory, e.g. 60GB
    wrapper:
        "v8.0.3/bio/bbtools"

#need to get these data into the qiime2 configs as eukfrac is a nice piece of metadata to look at
rule count_seqs:
    input:
        prok="results/01-split/{sample}.prok.R1.fastq.gz",
        euk="results/01-split/{sample}.euk.R1.fastq.gz"
    output:
        eukfrac="results/01-split/counts/{sample}.eukfrac",
    params:
        "{sample}" 
    conda:
        config["qiime2version"]
    script:
        "../scripts/count-seqs.sh"

#fix this in later step (merging)
rule concatenate_eukfrac_data:
    input:
        eukfrac=expand("results/01-split/counts/{sample}.eukfrac", sample=samples["sample"])
    output:
        eukfracall="results/" + config["studyName"] + ".eukfrac-all.tsv"
    conda:
        config["qiime2version"]
    script:
        "../scripts/concat-eukfrac.sh"
