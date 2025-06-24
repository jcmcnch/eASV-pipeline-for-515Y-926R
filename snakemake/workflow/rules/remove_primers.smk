rule cutadapt:
    input:
        ["/home/jesse/github/nativemicrobiota/ocean-data/{sample}.R1.head400.fastq.gz",
        "/home/jesse/github/nativemicrobiota/ocean-data/{sample}.R2.head400.fastq.gz"],
    output:
        fastq1="results/01-trimmed/{sample}.1.fastq",
        fastq2="results/01-trimmed/{sample}.2.fastq",
        qc="results/01-trimmed/{sample}.qc.txt",
    params:
        # https://cutadapt.readthedocs.io/en/stable/guide.html#adapter-types
        adapters="-g ^GTGYCAGCMGCCGCGGTAA -G ^CCGYCAATTYMTTTRAGTTT",
        # https://cutadapt.readthedocs.io/en/stable/guide.html#
        extra="--no-indels --pair-filter=any --error-rate=0.2 --discard-untrimmed",
    log:
        "logs/01-trimming/{sample}.log",
    threads: 4  # set desired number of threads here
    wrapper:
        "v7.0.0/bio/cutadapt/pe"
