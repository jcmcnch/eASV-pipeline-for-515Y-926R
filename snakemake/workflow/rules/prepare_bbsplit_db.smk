## NOTE : Need to make this a higher priority so it gets done before splitting

rule prepare_bbsplit_db:
    input:
        file1="databases/bbsplit-db/SILVA_132_and_PR2_EUK.cdhit95pc.fasta", file2="databases/bbsplit-db/SILVA_132_PROK.cdhit95pc.fasta",
    output:
        path=directory("databases/bbsplit-db/EUK-PROK-bbsplit-db/")
    conda:
        "../envs/bbmap.yaml"
    log:
        "logs/bbsplit_db_prep.log"
    priority: 50
    shell:
        "bbsplit.sh build=1 ref={input.file1},{input.file2} path={output}"
