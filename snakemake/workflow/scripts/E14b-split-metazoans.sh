#!/usr/bin/env bash

#Split out Metazoans based on SILVA

qiime taxa filter-table \
    --i-table ${snakemake_input[euktable]} \
    --i-taxonomy ${snakemake_input[euktaxSILVA]} \
    --p-exclude "p__Annelida,p__Apicomplexa,p__Arthropoda,p__Cnidaria,p__Ctenophora,p__Echinodermata,p__Holozoa,p__Mollusca,p__Porifera,p__Tunicata,p__Vertebrata" \
    --o-filtered-table ${snakemake_output[excludemetazoaSILVAtable]} || touch ${snakemake_output[excludemetazoaSILVAtable]}

#Split out Metazoans based on PR2

qiime taxa filter-table \
    --i-table ${snakemake_input[euktable]} \
    --i-taxonomy  ${snakemake_input[euktaxPR2]} \
    --p-exclude "Metazoa" \
    --o-filtered-table ${snakemake_output[excludemetazoaPR2table]} || touch ${snakemake_output[excludemetazoaPR2table]}

#Create metazoan-only table based on SILVA

qiime taxa filter-table \
    --i-table ${snakemake_input[euktable]} \
    --i-taxonomy ${snakemake_input[euktaxSILVA]} \
    --p-include "p__Annelida,p__Apicomplexa,p__Arthropoda,p__Cnidaria,p__Ctenophora,p__Echinodermata,p__Holozoa,p__Mollusca,p__Porifera,p__Tunicata,p__Vertebrata" \
    --o-filtered-table ${snakemake_output[includemetazoaSILVAtable]} || touch ${snakemake_output[includemetazoaSILVAtable]}


#Create metazoan-only table based on PR2

qiime taxa filter-table \
    --i-table ${snakemake_input[euktable]} \
    --i-taxonomy ${snakemake_input[euktaxPR2]} \
    --p-include "Metazoa" \
    --o-filtered-table ${snakemake_output[includemetazoaPR2table]} || touch ${snakemake_output[includemetazoaPR2table]}

