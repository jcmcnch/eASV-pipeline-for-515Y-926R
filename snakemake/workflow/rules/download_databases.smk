OSF_IDs = 
    ["eux4r", "eahds"] #only for PROK / EUK splitting, other datbases available at repo
NAMES =
    ["_and_PR2_EUK", "PROK"]

SILVA_132_and_PR2_EUK.cdhit95pc.fasta

rule download_databases:
    output:
        expand("{database_dir}/bbsplit-db/SILVA_132_{middlebit}.cdhit95pc.fasta", middlebit=NAMES),
    log:
        "logs/aria2_bbsplit_db_download.log",
    params:
        url=expand("https://osf.io/{id}/download", id=OSF_IDs),
        extra="--file-allocation none --retry-wait 5 --console-log-level warn --log-level notice",
    threads: 2
    resources:
        mem_mb=1024,
        runtime=30,
    wrapper:
        "v7.2.0/utils/aria2c"
