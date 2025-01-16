# A Software Pipeline for 3-Domain Universal Primers (515Y / 926R)

---

This is a collection of bash scripts to automate the analysis of mixed 16S/18S amplicon sequences using `bbtools`, `qiime2`, `DADA2`, and other associated software. They are designed to make the in silico workflow for the 515Y/926R primer set easier, reproducible, and more accessible.

The main difference between this pipeline and standard workflows is that it contains an initial 16S/18S splitting step, which is accomplished using bbsplit against curated 16S / 18S databases derived from SILVA and PR2. This results in two "pools" of data (16S and 18S rRNA) that are then denoised separately, and later merged if desired. The pipeline will also allow you to generate `qiime2` plots, obtain biologically-relevant classifications for your metabarcodes using the latest iterations of the SILVA/PR2 databases. 

- If you just need to set up and run the pipeline, check out the *Quickstart* below. 

- To read more about the primers and why this workflow was created, check out the *Pipeline Architecture* section.

- To see how to quickly archive your code/data for review, check out *Data / Code Archiving*.

---

**Table of contents:**

0. [quickstart](https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R#0-quickstart-and-reproducibility)
1. [preamble](https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R#1-preamble)
2. [pipeline architecture](https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R#2-pipeline-architecture)
3. [data and code archiving](https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R#3-data--code-archiving)

---

** Latest News (2023-09-04): **

- We have noticed an issue where in rare cases our artificially-concatenated eukaryotic 18S ASVs are less than the sum of the forward and reverse trim lengths, indicating production of spurious ASVs due to poor quality sequences that get truncated. If you are using this pipeline to generate 18S ASVs from the Parada primers, we recommend you check to make sure your lengths are all the same as follows:

```
conda activate bbmap-env
readlength.sh in=02-EUKs/08-DADA2d/220913-0413.Niall-Zooplankton-2021-Gradients.18S.dna-sequences.fasta out=18S-read-length-histogram.txt bin=1
```

The output should look like this:

```
#Reads: 9444
#Bases: 3777600
#Max:   400
#Min:   400
#Avg:   400.0
#Median:        400
#Mode:  400
#Std_Dev:       0.0
#Read Length Histogram:
#Length reads   pct_reads       cum_reads       cum_pct_reads   bases   pct_bases       cum_bases       cum_pct_bases
400     9444    100.000%        9444    100.000%        3777600 100.000%        3777600 100.000%
```

In this case, all 18S ASVs are 400bp which matches the sum of the fwd/rev trim lengths specified (220/180), so there is no issue. *NB: These trim lengths (220/180) have worked well for us, and are default in the configuration of the newer version of the pipeline. Unless you have a strong reason to change them, we recommend sticking with these trim lengths.*

According to advice from Yi-Chun Yeh, I have also added an additional parameter to the 18S denoising step (`--p-trunc-q 0`), which may prevent the production of some of these spurious ASVs.

---

** News (2023-03-21):**

- The new version of the pipeline and associated helper scripts have been fully tested.
- There is now a workflow for analyzing multiple sequencing runs, which allows you to denoise several sequencing runs separately and then merge samples later.
- Tutorial video in progress.

---

**Citing this work:**

If you find this pipeline useful to your research, we ask that you cite this github repository (with the version used in your analysis) as well as the following two papers:

McNichol, J., Berube, P., Biller, S., Fuhrman, J., 2021. [Evaluating and Improving SSU rRNA PCR Primer Coverage for Bacteria, Archaea, and Eukaryotes Using Metagenomes from Global Ocean Surveys](https://journals.asm.org/doi/10.1128/mSystems.00565-21). mSystems. 6(3), e00565-2

Yeh, Y.C., McNichol, J., Needham, D., Fichot, E., Berdjeb, L., Fuhrman, J., 2021. [Comprehensive single-PCR 16S and 18S rRNA community analysis validated with mock communities, and estimation of sequencing bias against 18S](https://sfamjournals.onlinelibrary.wiley.com/doi/10.1111/1462-2920.15553). Environmental Microbiology. doi: 10.1111/1462-2920.15553.

---

## 0. Quickstart

**Note:** This tutorial assumes you are running scripts in a GNU/Linux system and miniconda already installed. If you need help installing miniconda, [check out instructions on the qiime2 page here](https://docs.qiime2.org/2022.8/install/native/). Make sure to do the `conda init` step at the end of the installation (normally just say 'yes' when prompted). To make sure conda is working properly, either log out and back in again, or run `source ~/.bashrc`.

**Note número dos:** There is no reason why this shouldn't work on OSX or WSL but I haven't tested it. If you would like to contribute scripts for your different setup you can open a pull request or email them to me.

1. Clone the repo and enter the directory:

```
#if you're running a fresh system may need to install git
sudo apt-get install git
git clone https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R.git 
cd eASV-pipeline-for-515Y-926R
```

2. Enter the folder for the latest `qiime2` version:

`cd qiime2-2022.2-DADA2-SILVA138.1-PR2_4.14.0`

3. Install `qiime2` by running the following script (see `qiime2` install link above if you want a different version or operating system):

```
#to install qiime2-2022.8 for GNU/Linux systems
#it will also install mamba for you which is faster than conda
#needs to be modified for different versions or operating systems
./setup-scripts/00-install-qiime2-2022.2.sh
```

2. Install accessory conda environments (for initial trimming and splitting steps). This has only been tested on GNU/Linux so again, YMMV. See note above if you want to contribute your setup scripts.
1
```
#install 2-3 other conda environments
./setup-scripts/01-install-conda-envs.sh
```

3. Download classifiers and create the necessary databases for splitting:

```
./setup-scripts/02-download-qiime2-classifiers-qiime2-2022.2.sh
./setup-scripts/03-make-bbsplit-db.sh
```

4. Create a new template analysis directory with a custom name, using provided setup script:

```
#input your study name (no spaces) after the script
./setup-scripts/04-setup-new-analysis-directory.sh tutorial
```

5. Enter into that directory, setup configuration file, then add raw reads.

```
#enter analysis dir
cd ~/515FY-926R-pipeline/tutorial

#add your raw files to 00-raw folder, for example by softlinking from another folder:
ln -s /home/jesse/demultiplexed/tutorial-data/*fastq.gz $PWD/00-raw #provide full (not relative) paths if softlinking

#edit config file, using your preferred text editor, making sure to at least change the file endings to whatever format your raw data is in
vi 515FY-926R.cfg

```

**To denoise multiple sequencing runs together, simply create multiple `00-raw` folders with numbers after a dash, i.e. `00-raw-01`, `00-raw-02`, etc. The workflow script will iterate over these folders and merge data after denoising is run in parallel.**

6. Run one of the workflow scripts:

```
#run this one if all your data are in one sequencing run
./runscripts/00-denoising-workflow.sh

#run this one if you have data that need to be merged from multiple sequencing runs
./runscripts/00-denoising-workflow-multiple-seq-runs.sh
```

7. Optionally merge 16S and 18S data.

8. Optionally run plotting / other scripts after inputting your metadata in `sample-metadata.tsv`.

9. Optionally export data and/or scripts for upload to an external repository such as [The Open Science Framework](https://osf.io/).


## 1. Preamble

Metabarcoding using SSU rRNA as a marker gene is a powerful technique for profiling biological communities. My (admittedly subjective) impression is that metabarcoding studies are separated into roughly three different camps:

1. Those studying the "microbiome", i.e. *Bacteria* and *Archaea*.
2. Those studying microbial *Eukarya*, i.e. things like phytoplankton or heterotrophic protists.
3. Those studying macroscopic *Eukarya*, such as animals or plants.

Group 1 tends to use 16S SSU rRNA as a marker gene, while groups 2 and 3 will use 18S. PCR primer design has followed this paradigm, with many primer sets having been designed to target a specific group of interest while discriminating against another (i.e. *Bacteria* and *Archaea* but not *Eukarya*).

However, 16S and 18S are, in evolutionary terms, the same molecule. Therefore, SSU rRNA primers that target **both 16S and 18S** in the same PCR assay exist. It's really important to note that this is **not** two sets of primers. It is a single set of primers (1 forward, 1 reverse) that **amplifies 16S from Archaea, Bacteria, Chloroplasts and Mitochondria alongside Eukaryotic nuclear 18S in the same assay**. This happens literally in the same tube.

The fact that this is possible is (in my opinion) mind-blowing. It tells us there are regions in the SSU rRNA molecule that have been so evolutionarily conserved across ~3.5 **billion** years of evolutionary history that it is possible to design primers that amplify vastly different organisms. We're talking about the difference between bacteria to chloroplasts to protists to jellyfish. That different!

To illustrate this visually, I want to show an example of this primer set applied to two different datasets that come from a recent research cruise. 

---

The first dataset is derived from DNA extracted from 1 L of whole seawater from the Pacific Ocean filtered on a 0.2 µm Sterivex filter. Therefore, it contains organisms ranging from prokaryotes to eukaryotes to even bits and pieces of animals or their larval stages / propagules.

This is what it looks like as a sequence pool (a number of samples mixed together after PCR amplification):

![LJ-Gradients](https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R/blob/master/visualizations/220902_122853_LJ-GRADIENTS-samples-trace.png)

What you should notice in this graph is there is a large peak at 539 bp, and a much smaller peak at 707 bp. The big peak is 16S. Bacteria, Archaea, plastids, mitochondria. The small peak is 18S from protists, metazoa, picoeukaryotes, etc.

---

The second dataset is DNA extracted from the same region of the Pacific Ocean, except this time the larger organisms were concentrated in a net tow. Therefore, the majority of the DNA comes from animals, protists, microeukaryotes, etc.

This is what its trace looks like.

![NM-Gradients](https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R/blob/master/visualizations/220902_122853_NM-GRADIENTS-samples-trace.png)

It's the mirror image! This time the 16S peak (546 bp) is tiny (could be mitochondria, plastids, or the animal-associated "microbiome") whereas the 18S peak (736 bp) is massive.

---

Again, this is the same primer set. Same procedure. Yet it works quite well on both classes of samples!

Why hasn't this approach been used commonly before? One reason comes from the mismatch between sequencing lengths and the length of the amplicon. The primers this pipeline is designed for\* bind at the SSU rRNA coordinates 515 / 926 (using *E. coli* as a reference). That means the amplicon should be approximately 411 bp for most *Bacteria* (this depends on the biology of the organism - extreme oligotrophs have shorter rRNA sequences; NB: traces above are longer because they already have the *Illumina* adapters ligated on it). *Archaea* should be approximately the same.

\* *Note: Other universal primers are possible and have been proven to work. There is another universal binding location at 1392, so you can do 926F/1392R or 515F/1392R.*

However, for *Eukarya*, the binding coordinates for the primers are 562 and 1150 (in *S. cerevisieae* coordinates). That's an eukaryotic amplicon of 588 bp. Although there is certainly evolutionary and ecological variation in 18S length, but on average eukaryotic amplicons will be on the order of 177 bp longer than prokaryotic amplicons.

What does this all mean? Well, modern *Illumina* sequencing has a maximum paired-end read length of 300bp but typically you can't use all of that length. Some has to be trimmed off to remove low-quality bases, especially from the reverse read. With what you're left with, the 16S (prokaryotic) amplicons from the forward and reverse reads overlap, but the 18S reads do not.

And this length difference is the main reason why this pipeline was developed. Most amplicon sequencing pipelines have a step that requires overlap. This makes sense for 16S but not for 18S. So a normal pipeline dealing with data from the 515Y/926R primers will discard 18S reads because they do not overlap. Based on an initial prototype by [Mike Lee](https://astrobiomike.github.io/) (thanks Mike!), Jesse McNichol refined and finalized a way of splitting 16S and 18S reads *in-silico* and pipeline grew from there. Since then, Yi-Chun Yeh, Melody Aleman and Colette Fletcher-Hoppe have made important contributions to the pipeline, many of which of course were inspired by Jed Fuhrman's ideas. Read on to learn more how the pipeline is constructed and what it can do for you. Or if you already know that, just use the quickstart above to run the pipeline on your data.

## 2. Pipeline Architecture 

I think a visual summary of the pipeline is always helpful. So here's a diagram:

![Pipeline structure](https://github.com/jcmcnch/eASV-pipeline-for-515Y-926R/blob/master/visualizations/qiime2-pipeline-revised.svg)


... To be continued ...

---

### Previous updates / notes:

***Update April 2021:
Pipeline now uses latest versions of SILVA138 and PR2 (which includes plastid sequences that were previously found in a separate database known as phytoRef). For those running the pipeline on kraken, just pull down the new scripts. For those running the pipeline elsewhere, you can find the necessary classifiers [here](https://osf.io/z8arq/). Raw artifacts are also provided for others in case you wish to slice these databases to different primer regions.***

***UPDATE July 2019:
The purpose of these additional scripts is to easily compare the classifications at different confidence levels in one file known as a “Lookup Table”. This is particularly useful in instances where the default classification classifies the eASV as “Bacteria”, but a less stringent confidence level might classify that eASV further as a mitochondrial sequence. 
One of the options of the qiime feature-classifier classify-sklearn step is to designate the --p-confidence threshold, which limits the depth for taxonomic assignments. The default setting is 0.7, indicating that the classifier is at least 70% confident in its classification. New scripts were added to the pipeline to re-run the classification step at less stringent confidence levels (0.5, 0.3, and -1). A --p-confidence value set at -1 disables the confidence calculation. 
- EUK Scripts: E19-E22
- PROK Scripts: P14-P17
- For the DADA2 version of the pipeline only

***UPDATE March 2019 - New functionality has been added for automatically slicing and dicing eASV tables according to various pre-set categories (e.g. 16S sequences without chloroplasts or mitochondria, 18S sequences with Metazoan sequences removed; see below for exact categories), and automatically making qiime2 barplots for each of these categories. Also, the repository was cleaned up so that the previous (confusing) way of cloning different branches is no longer used - now you just have clone the master branch and you will find all 3 pipeline variants stored in separate folders.***


*While DADA2 is superior to Deblur in terms of sequence recovery and accurate recovery of the natural community (especially for our Eukaryotic amplicons - ~80% DADA2 vs ~20% Deblur), we have noticed that it creates spurious eASVs on occasion (a spurious eASV is defined here as an eASV with 1 mismatch to the reference mock community sequence that cannot be accounted for by sample bleedthrough). This seems to be either due to noisy data (e.g. 2x300 PE reads) or due to something that trips up the error model (i.e. it happened once when we had in extra mocks from the same run but different lane that had more reads on average than the first lane). For us, this isn't necessarily a problem since we use the mocks as a way to validate our results, and we can tweak parameters to avoid these potential artifacts. But for those who don't have access to the mocks, or those who are working with data downloaded from the SRA, then it will be easier to use Deblur. HOWEVER, I've recently come across some evidence that deblur may be removing closely-related things and thus potentially distorting the quantitative nature of the amplicon sequences. More to come on this, but at this point if you must exclude all false positives then deblur seems the best choice - whereas if you're concerned about false negatives and making sure your data is as quantitatively accurate as possible, DADA2 seems to be the way to go.

16S (all filtering steps based on SILVA classifications, chloroplasts always classified with PR2):

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

-All 18S sequences, classified using SILVA

-All 18S sequences, classified using PR2

-18S sequences with Metazoa subtracted according to SILVA classifications

-18S sequences with Metazoa subtracted according to PR2 classifications

## 3. Data / Code Archiving

This pipeline generates *a lot* of output files that can be useful for later visualization / inspection. Because the organization of folders tracks the bioinformatic steps, it can be somewhat confusing for someone who didn't design the pipeline to know where to find stuff. For example, maybe you want to find:

- 16S or 18S ASV sequences to do some BLASTing
- The statistics of denoising
- Some of those nice *qiime2* visualizations to share with collaborators

In addition, for publication review you'll probably want to archive:

- Your config files, which would include parameters such as trim length
- All the bash scripts used in your iteration of this pipeline which might include modifications specific to your workflow

To simplify the collection and organization of these files, I've put together a couple of bash scripts that will automatically do this for you. It's pretty simple:

1. Go into
