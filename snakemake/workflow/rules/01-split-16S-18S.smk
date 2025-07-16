#SILVA_132_and_PR2_EUK.cdhit95pc
#SILVA_132_PROK.cdhit95pc

rule bbsplit_prok_euk:
    input:
        r1="results/00-trimmed/{sample}.1.fastq",
        r2="results/00-trimmed/{sample}.2.fastq"
    output:
        prok=temp("results/01-split/{sample}.prok.fastq"),
        euk=temp("results/01-split/{sample}.euk.fastq")
    conda:
        "../envs/bbmap.yaml"
#need to include ways of setting params for memory/cores
    log:
        "logs/01-splitting/{sample}_bbsplit.log"
#capture log output with &2> ? - currently no logging info in output file
    shell:
        "bbsplit.sh usequality=f qtrim=f minratio=0.30 minid=0.30 pairedonly=f path=/home/jesse/github/eASV-pipeline-for-515Y-926R/snakemake/databases/bbsplit-db/EUK-PROK-bbsplit-db/ in={input.r1} in2={input.r2} out_SILVA_132_PROK.cdhit95pc={output.prok} out_SILVA_132_and_PR2_EUK.cdhit95pc={output.euk}"

# step 2: deinterlace according to BB's post

# step 3: compress split output
 
#rule compress_split_output:
#    input:
#        "{prefix}.vcf",
#    output:
#        "{prefix}.vcf.gz",
#    threads: 1
#    log:
#        "logs/bgzip/{prefix}.log",
#    wrapper:
#        "v7.2.0/bio/bgzip"
