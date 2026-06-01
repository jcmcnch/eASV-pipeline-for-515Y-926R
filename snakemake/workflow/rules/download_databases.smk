#OSF_IDs = ["eux4r", "eahds"] #only for PROK / EUK splitting, other datbases available at repo
#NAMES = ["and_PR2_EUK", "PROK"]
#database_dir=config["database_dir"]

rule download_prok_db:
    output:
        temp("databases/bbsplit-db/SILVA_132_PROK.cdhit95pc.fasta"),
    log:
        "logs/aria2_bbsplit_prok_db_download.log",
    params:
        url="https://osf.io/eahds/download",
        extra="--file-allocation none --retry-wait 5 --console-log-level warn --log-level notice",
    threads: 2
    resources:
        mem_mb=1024,
        runtime=30,
    priority: 50
    wrapper:
        "v7.2.0/utils/aria2c"

rule download_euk_db:
    output:
        temp("databases/bbsplit-db/SILVA_132_and_PR2_EUK.cdhit95pc.fasta"),
    log:
        "logs/aria2_bbsplit_euk_db_download.log",
    params:
        url="https://osf.io/eux4r/download",
        extra="--file-allocation none --retry-wait 5 --console-log-level warn --log-level notice",
    threads: 2
    resources:
        mem_mb=1024,
        runtime=30,
    priority: 50
    wrapper:
        "v7.2.0/utils/aria2c"

rule download_pr2:
    output:
        temp("databases/PR2/pr2_version_5.1.1_SSU_dada2.fasta.gz")
    log:
        "logs/download_pr2.log"
    params:
        url="https://github.com/pr2database/pr2database/releases/download/v5.1.1/pr2_version_5.1.1_SSU_dada2.fasta.gz",
        extra="--file-allocation none --retry-wait 5 --console-log-level warn --log-level notice",
    threads: 
        2
    resources:
        mem_mb=1024,
        runtime=30,
    priority: 50
    wrapper:
        "v7.2.0/utils/aria2c"

rule unzip_pr2:
    input:
        temp("databases/PR2/pr2_version_5.1.1_SSU_dada2.fasta.gz"),
    output:
        temp("databases/PR2/pr2_version_5.1.1_SSU_dada2.fasta"),
    log:
        "logs/gunzip/extract_pr2.log",
    threads: 1
    priority: 50
    shell:
        "gunzip -c {input} > {output}"    
