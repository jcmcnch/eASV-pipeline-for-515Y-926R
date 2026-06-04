#!/usr/bin/env bash

#another radically simplified script, go snakemake!
fuse.sh in=${snakemake_input[r1]} in2=${snakemake_input[r2]} fusepairs=t pad=0 out=${snakemake_output[0]}
