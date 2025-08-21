# import basic packages
import pandas as pd
from snakemake.utils import validate

# read sample sheet
samples = (
    pd.read_csv(config["samplesheet"], sep="\t", dtype={"sample": str})
    .set_index("sample", drop=False)
    .sort_index()
)

# define output as function
def get_final_output():
    final_output = expand(
        "results/01-split/{sample}.{organism}.R1.fastq.gz", sample=samples["sample"], organism=["prok","euk"]
        #"results/01-split/{sample}.prok.fastq",
        #"results/00-trimmed/{sample}.{direction}.fastq",
        #sample=samples["sample"], direction=["1","2"]
    )

    final_output.append("databases/bbsplit-db/SILVA_132_PROK.cdhit95pc.fasta"),
    final_output.append("databases/bbsplit-db/SILVA_132_and_PR2_EUK.cdhit95pc.fasta"),
    final_output.append(directory("databases/bbsplit-db/EUK-PROK-bbsplit-db/")),
    final_output.append("results/02-proks/manifest.tsv"),
    final_output.append("results/02-proks/16S.qza"),
    final_output.append(directory("results/02-proks/02-quality-plots-R1-R2/")),
    final_output.append(directory("results/02-proks/03-DADA2d/"))

    return final_output

# validate sample sheet and config file
validate(samples, schema="../../config/schemas/samples.schema.yml")
validate(config, schema="../../config/schemas/config.schema.yml")
