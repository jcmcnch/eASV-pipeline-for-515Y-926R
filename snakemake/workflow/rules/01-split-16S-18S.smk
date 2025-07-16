#SILVA_132_and_PR2_EUK.cdhit95pc
#SILVA_132_PROK.cdhit95pc

rule bbsplit_prok_euk:
    input:
        r1="results/00-trimmed/{sample}.1.fastq",
        r2="results/00-trimmed/{sample}.2.fastq"
    output:
        prok="results/01-split/{sample}.prok.fastq",
        euk="results/01-split/{sample}.euk.fastq"
    conda:
        "../envs/bbmap.yaml"
    log:
        "logs/01-splitting/{sample}_bbsplit.log"
    shell:
        "bbsplit.sh usequality=f qtrim=f minratio=0.30 minid=0.30 pairedonly=f threads=20 -Xmx100g path=/home/jesse/github/eASV-pipeline-for-515Y-926R/snakemake/databases/bbsplit-db/EUK-PROK-bbsplit-db/ in={input.r1} in2={input.r2} out_SILVA_132_PROK.cdhit95pc={output.prok}, out_SILVA_132_and_PR2_EUK.cdhit95pc={output.euk}"

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
