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
    final_output.append("databases/classification/PR2/pr2_version_5.1.1_SSU_dada2.clean.culled.derep-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated_final_classifier_USE_ME.qza"),
    final_output.append(directory("databases/bbsplit-db/EUK-PROK-bbsplit-db/")),
    final_output.append("databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated_final_classifier_USE_ME.qza"),
#    final_output.append("results/02-proks/manifest.tsv"),
    final_output.append("results/02-proks/16S.qza"),
    final_output.append(directory("results/02-proks/02-quality-plots-R1-R2/")),
    final_output.append(directory("results/02-proks/03-DADA2d/")),
    final_output.append(directory("results/02-proks/04-DADA2d-plaintext-exports")),
    final_output.append(directory("results/02-proks/05-classified")),
    final_output.append(directory("results/02-proks/07-SILVA-only-barplots/")),
    final_output.append("results/02-proks/09-subsetting/split-seqs/exclude_o__Chloroplast_subset_filtered_seqs.qza"),
    final_output.append("results/02-proks/09-subsetting/reclassified/include_o__Chloroplast_subset_reclassified_PR2.qza"),
    final_output.append("results/02-proks/10-exports/taxonomy.tsv"),
    final_output.append("results/02-proks/10-exports/all-16S-seqs.with-tax.tsv"),
    final_output.append("results/02-proks/sample-metadata.tsv"),
    final_output.append("results/02-euks/18S-viz.qza"),
    final_output.append(directory("results/02-euks/02-quality-plots-R1-R2/")),
    final_output.append(directory("results/02-euks/07-quality-plots-concat")),
    final_output.append(directory("results/02-euks/08-DADA2d")),
    final_output.append("results/02-euks/18S-concat.qza"),
    final_output.append(expand("results/02-euks/04-concatenated/{sample}.euk.concatenated.fastq", sample=samples["sample"])),
    final_output.append(directory("results/02-euks/09-DADA2d-plaintext-exports/")),
    final_output.append(directory("results/02-euks/10-classified/")),
    final_output.append("results/02-euks/sample-metadata.tsv")

    return final_output

# validate sample sheet and config file
validate(samples, schema="../../config/schemas/samples.schema.yml")
validate(config, schema="../../config/schemas/config.schema.yml")
