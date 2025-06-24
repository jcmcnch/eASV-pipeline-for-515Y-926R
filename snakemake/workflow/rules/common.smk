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
        "results/01-trimmed/{sample}.qc.txt",
        sample=samples["sample"],
    )

    return final_output

# validate sample sheet and config file
validate(samples, schema="../../config/schemas/samples.schema.yml")
validate(config, schema="../../config/schemas/config.schema.yml")
