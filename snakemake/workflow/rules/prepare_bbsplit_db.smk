import sys
sys.setrecursionlimit(1200)

rule prepare_bbsplit_db:
    input:
        "databases/bbsplit-db/SILVA_132_and_PR2_EUK.cdhit95pc.fasta", "databases/bbsplit-db/SILVA_132_PROK.cdhit95pc.fasta",
    output:
        path=directory("databases/bbsplit-db/ref/genome/")
    params:
        command="bbsplit.sh",
        ref={input}
    log:
        "logs/bbsplit_db_prep.log"
    wrapper:
        "v7.2.0/bio/bbtools"
