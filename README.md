# eASV-pipeline-for-515Y-926R

***Update April 2021:
Pipeline now uses latest versions of SILVA138 and PR2 (which includes plastid sequences that were previously found in a separate database known as phytoRef). For those running the pipeline on kraken, just pull down the new scripts. For those running the pipeline elsewhere, you can find the necessary classifiers [here](https://osf.io/z8arq/). Raw artifacts are also provided for others in case you wish to slice these databases to different primer regions.***

***UPDATE July 2019:
The purpose of these additional scripts is to easily compare the classifications at different confidence levels in one file known as a “Lookup Table”. This is particularly useful in instances where the default classification classifies the eASV as “Bacteria”, but a less stringent confidence level might classify that eASV further as a mitochondrial sequence. 
One of the options of the qiime feature-classifier classify-sklearn step is to designate the --p-confidence threshold, which limits the depth for taxonomic assignments. The default setting is 0.7, indicating that the classifier is at least 70% confident in its classification. New scripts were added to the pipeline to re-run the classification step at less stringent confidence levels (0.5, 0.3, and -1). A --p-confidence value set at -1 disables the confidence calculation. 
- EUK Scripts: E19-E22
- PROK Scripts: P14-P17
- For the DADA2 version of the pipeline only

***UPDATE March 2019 - New functionality has been added for automatically slicing and dicing eASV tables according to various pre-set categories (e.g. 16S sequences without chloroplasts or mitochondria, 18S sequences with Metazoan sequences removed; see below for exact categories), and automatically making qiime2 barplots for each of these categories. Also, the repository was cleaned up so that the previous (confusing) way of cloning different branches is no longer used - now you just have clone the master branch and you will find all 3 pipeline variants stored in separate folders.***

This is a collection of scripts for analyzing mixed 16S/18S amplicon sequences using bbtools, qiime2, DADA2, Deblur, biom, BLAST, and other tools. They are wrappers of a wrapper (qiime2), and are designed to make the in silico workflow for the 515Y/926R primer set easier, reproducible, and more accessible.

The main difference between this pipeline and standard workflows is that it contains an initial 16S/18S splitting step, which is accomplished using bbsplit against curated 16S / 18S databases derived from SILVA132 and PR2. Other notable differences include:

*Semi-automated methods to validate the performance of your denoising algorithm with the Fuhrman Lab mock communities

*20% mismatches allowed in the primer removal step, meaning taxa that are amplified despite primer mismatches will be retained in the results

*An automated workflow for processing 18S sequences that do not overlap

*Automatic classification/splitting as noted above

Scripts are written with python or bash, and are designed for the pre-set conda environments on kraken.usc.edu. However, they could easily be used elsewhere by installing the conda environment for qiime2 specified in the scripts (currently qiime2-2019.4) and a separate environment (called bbmap-env) that has Brian Bushnell's Bestus Bioinformaticus Tools installed.

To start using them, just clone the repository as follows:

`git clone https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R.git`

The repository is split into a couple of different pipelines with minor differences:

1. Default Fuhrman lab pipeline ("DADA2-pipeline"), set up for use with kraken.usc.edu. A protocol is available here:

https://www.protocols.io/private/C0F9404AB3DAEC96683F142351CEF59C

2. Alternative Fuhrman lab pipeline ("deblur-pipeline"), set up for use with kraken.usc.edu. Protocol here:

https://www.protocols.io/private/6C81EC4BC2074A76D7ACF80E2F0603B7

3. Apply to your own primers/pipeline with deblur ("deblur-template-pipeline"). If you'd like to use these scripts as a starting point for your analysis but are not using the Fuhrman lab primers / mock communities and are concerned about false positives*. This workflow is basically the same as our "in-house" pipeline but with some minor additions to make the scripts more generally applicable (e.g. they include some templates for preparing your own classfication database):

https://www.protocols.io/private/7714BDE068BA6E75FF2B89082009590F

If you're doing the bbsplit step, and want to use our PROK/EUK databases (curated from SILVA 132 and PR2), you can find them [here](https://osf.io/e65rs/) along with instructions for how to create the database.

Then edit the splitting script ("01-sort-16S-18S-bbsplit.sh") so that it points to the full path of the directory specified above in the path part of the command.

*CLASSIFIERS (Trained on the 515Y/926R primer pair)*

The default taxonomy we use is now SILVA138. A pre-trained classifier for the 515Y/926R primer pair can be found [here](https://osf.io/z8arq/) (just point the scripts to where you downloaded the file on your server/laptop).

You'll also need the PhytoRef classifier for better chloroplast assignments, found [here](https://osf.io/z8arq/). Just make sure to point the splitting/reclassification script to the location where you downloaded the qza file.

I've also included a PR2 classification step so you can compare results to SILVA (big thanks to Niu Du who shared the artifacts on the qiime2 forum). Make sure to also change the path location in the appropriate splitting/reclassification script after downloading artifacts [here](https://osf.io/z8arq/).

If you need to make your own classifiers for PR2 / PhytoRef / SILVA (i.e. you're not using the same primers), you can use Niu Du's pre-made artifacts found here: https://github.com/ndu-UCSD/Oceanic_database or the more up-to-date files in the `rawArtifacts` folder [here](https://osf.io/z8arq/). You can find some basic instructions about how to do this by looking at the "T"-prefaced scripts in the "deblur-template-pipeline" subfolder in this repository.

*While DADA2 is superior to Deblur in terms of sequence recovery and accurate recovery of the natural community (especially for our Eukaryotic amplicons - ~80% DADA2 vs ~20% Deblur), we have noticed that it creates spurious eASVs on occasion (a spurious eASV is defined here as an eASV with 1 mismatch to the reference mock community sequence that cannot be accounted for by sample bleedthrough). This seems to be either due to noisy data (e.g. 2x300 PE reads) or due to something that trips up the error model (i.e. it happened once when we had in extra mocks from the same run but different lane that had more reads on average than the first lane). For us, this isn't necessarily a problem since we use the mocks as a way to validate our results, and we can tweak parameters to avoid these potential artifacts. But for those who don't have access to the mocks, or those who are working with data downloaded from the SRA, then it will be easier to use Deblur. HOWEVER, I've recently come across some evidence that deblur may be removing closely-related things and thus potentially distorting the quantitative nature of the amplicon sequences. More to come on this, but at this point if you must exclude all false positives then deblur seems the best choice - whereas if you're concerned about false negatives and making sure your data is as quantitatively accurate as possible, DADA2 seems to be the way to go.

Current automatic splitting/plotting capabilities (a tsv table and graph will be produced for each of these categories):

16S (all filtering steps based on SILVA132 classifications, chloroplasts always classified with PhytoRef):

-16s excluding cyanobacteria, chloroplasts and mitochondria

-16S excluding Archaea

-Archaea only

-All prokaryotes (excluding chloroplasts/mitochondria)

-16S with mitochondria subtracted

-16S with chloroplasts subtracted

-Only cyanobacteria

-Cyanobacteria + chloroplasts

-Only chloroplasts

-Only mitochondria

18S:

-All 18S sequences, classified using SILVA132

-All 18S sequences, classified using PR2

-18S sequences with Metazoa subtracted according to SILVA132 classifications

-18S sequences with Metazoa subtracted according to PR2 classifications
