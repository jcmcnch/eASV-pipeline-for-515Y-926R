#!/usr/bin/env bash

#a greatly simplified implementation of the previous script with snakemake - no more crazy loops

#trim R1 and R2 according to params in config
bbduk.sh in=${snakemake_input[r1]} out=${snakemake_output[r1]} minlength=${snakemake_params[truncR1]} forcetrimright=$((${snakemake_params[truncR1]} - 1)) 2>&1 | tee -a ${snakemake_log[0]}

bbduk.sh in=${snakemake_input[r2]} out=${snakemake_output[r2]} minlength=${snakemake_params[truncR2]} forcetrimright=$((${snakemake_params[truncR2]} - 1)) 2>&1 | tee -a ${snakemake_log[0]}

#sometimes pairs get unpaired, fix with this script, generateing tmp files as output
repair.sh in=${snakemake_output[r1]} in2=${snakemake_output[r2]} out=${snakemake_output[r1]}.tmp out2=${snakemake_output[r2]}.tmp

#overwrite output with repaired reads (tmp files)
mv ${snakemake_output[r1]}.tmp ${snakemake_output[r1]}
mv ${snakemake_output[r2]}.tmp ${snakemake_output[r2]}
