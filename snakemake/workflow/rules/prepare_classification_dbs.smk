#set up rules with different scripts for rescript pipeline as implemented in bash, may need to split out
#make variables for everything that can have variables - db version, primer sequence, etc

rule download_SILVA:
    output:
        seqs=temp("databases/classification/SILVA/silva-ssu-nr99-rna-seqs.qza"),
        taxonomy=temp("databases/classification/SILVA/silva-ssu-nr99-tax.qza")
    params:
        SILVAversion=config["SILVAversion"]
    log:
        "logs/SILVA_classification_db_prep_download.log"
    priority: 50
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/01-rescript-dl-database-file.sh"

rule reverse_transcribe:
    input:
        "databases/classification/SILVA/silva-ssu-nr99-rna-seqs.qza"
    output:
        temp("databases/classification/SILVA/silva-ssu-nr99-dna-seqs.qza")
    log:
        "logs/SILVA_classification_db_prep_reverse_transcribe.log"
    priority: 49
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/02-reverse-transcribe.sh"

rule qc_seqs_cull:
    input:
        rawDNA="databases/classification/SILVA/silva-ssu-nr99-dna-seqs.qza"
    output:
        cleanDNA=temp("databases/classification/SILVA/silva-ssu-nr99-dna-seqs-culled.qza")
    log:
        "logs/SILVA_classification_db_prep_qc_SILVA_seqs_cull.log"
    priority: 48
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/03-qc-seqs-cull.sh"

rule qc_seqs_filter:
    input:
        cleanDNA="databases/classification/SILVA/silva-ssu-nr99-dna-seqs-culled.qza",
        taxonomy="databases/classification/SILVA/silva-ssu-nr99-tax.qza"
    output:
        filteredDNA=temp("databases/classification/SILVA/silva-ssu-nr99-dna-seqs-culled-filtered.qza"),
        discardedDNA=temp("databases/classification/SILVA/silva-ssu-nr99-dna-seqs-culled-discarded.qza")
    log:
        "logs/SILVA_classification_db_prep_qc_SILVA_seqs_filter.log"
    priority: 47
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/04-qc-seqs-length-filter.sh"

rule qc_seqs_dereplicate:
    input:
        filteredDNA="databases/classification/SILVA/silva-ssu-nr99-dna-seqs-culled-filtered.qza",
        taxonomy="databases/classification/SILVA/silva-ssu-nr99-tax.qza"
    output:
        dereplicatedDNA=temp("databases/classification/SILVA/silva-ssu-nr99-dna-seqs-culled-filtered-dereplicated.qza"),
        dereplicatedTaxa=temp("databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated.qza")
    log:
        "logs/SILVA_classification_db_prep_qc_SILVA_seqs_dereplicate.log"
    priority: 46
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/05-qc-seqs-dereplicate.sh"

rule extract_primers:
    input:
        dereplicatedDNA="databases/classification/SILVA/silva-ssu-nr99-dna-seqs-culled-filtered-dereplicated.qza"
    params:
        fwdPrimer=config["fwdPrimer"],
        revPrimer=config["revPrimer"]
    output:
        slicedDNA=temp("databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + ".qza")
    log:
        "logs/SILVA_classification_db_prep_qc_SILVA_seqs_extract_primers.log"
    priority: 45
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/06-extract-primers.sh"

rule dereplicated_sliced_data:
    input:
        slicedDNA="databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + ".qza",
        dereplicatedTaxa="databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated.qza"
    output:
        slicedDNAdereplicated=temp("databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated.qza"),
        dereplicatedTaxaSliced=temp("databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated.qza")
    log:
        "logs/SILVA_classification_db_prep_qc_SILVA_seqs_dereplicate_sliced_data.log"
    priority: 44
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/07-deduplicate-sliced-data.sh"

rule train_classifier:
    input:
        slicedDNAdereplicated="databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated.qza",
        dereplicatedTaxaSliced="databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated.qza"
    output:
        "databases/classification/SILVA/silva-ssu-nr99-tax-dereplicated-sliced_" + config["fwdPrimer"] + "_" + config["revPrimer"] + "_dereplicated_final_classifier_USE_ME.qza"
    log:
        "logs/SILVA_classification_db_prep_qc_SILVA_seqs_train_sliced_classifier.log"
    priority: 43
    conda:
        config["qiime2version"]
    script:
        "../scripts/tax-classifier-construction/SILVA/08-train-classifier.sh"
