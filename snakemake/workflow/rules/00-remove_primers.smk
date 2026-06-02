rule cutadapt:
    input:
        ["nativemicrobiota/ocean-data/{sample}.R1.head400.fastq.gz",
        "nativemicrobiota/ocean-data/{sample}.R2.head400.fastq.gz"],
    output:
        fastq1=temp("results/00-trimmed/{sample}.1.fastq"),
        fastq2=temp("results/00-trimmed/{sample}.2.fastq"),
        qc="results/00-trimmed/{sample}.qc.txt",
    params:
        # https://cutadapt.readthedocs.io/en/stable/guide.html#adapter-types
        adapters="-g ^GTGYCAGCMGCCGCGGTAA -G ^CCGYCAATTYMTTTRAGTTT",
        # https://cutadapt.readthedocs.io/en/stable/guide.html#
        extra="--no-indels --pair-filter=any --error-rate=0.2 --discard-untrimmed",
    log:
        "logs/00-trimming/{sample}.log",
    threads: 4  # set desired number of threads here
    wrapper:
        "v7.0.0/bio/cutadapt/pe"

rule compress_trimmed_output_r1:
    input:
        "results/00-trimmed/{sample}.1.fastq",
    output:
        "results/00-trimmed/{sample}.1.fastq.gz",
    threads: 1
    log:
        "logs/bgzip/{sample}_compress-trimmed-r1.log",
    wrapper:
        "v7.2.0/bio/bgzip"

rule compress_trimmed_output_r2:
    input:
        "results/00-trimmed/{sample}.2.fastq"
    output:
        "results/00-trimmed/{sample}.2.fastq.gz"
    threads: 1
    log:
        "logs/bgzip/{sample}_compress-trimmed-r2.log",
    wrapper:
        "v7.2.0/bio/bgzip"
