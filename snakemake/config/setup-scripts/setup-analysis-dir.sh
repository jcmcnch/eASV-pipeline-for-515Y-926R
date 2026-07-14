#!/bin/bash -i

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a memorable and informative name for your project as an argument after this script < e.g. config/setup-scripts/setup-analysis-dir.sh EXAMPLENAME > (make sure the name does not include any spaces - use dashes or underscores instead). This name will be used to create an analysis directory and will be appended to output files.'
    exit 0
fi

if [[ ! ${#1} -eq 0 ]] ; then
	echo "An analysis directory has been created for you at /home/$USER/GRUMP-snakemake-pipeline/$1 . It contains all the scripts needed to run the pipeline. The only things you need to do now are: 1) Modify the config.yml and samples.tsv to allow it to find your input files, use the appropriate primers, choose database versions, etc 2) Add metadata as a separate file, 3) Add bioanalyzer correction info (optional, see documentation), 4) Add internal standard info (optional, see documentation). Important note: The pipeline assumes your input files are demultiplexed fastq.gz files with the primers still attached. Filenames are determined by the combination of the variables \$rawdatadir, \$R1file_ending, \$R2file_ending, and the sample column in the file \"samples.tsv\", so be sure everything matches."
fi

studyName=$1

studyDir=/home/$USER/GRUMP-snakemake-pipeline/$studyName

mkdir -p $studyDir

cp -r config $studyDir
cp -r snakemake $studyDir
cp -r workflow $studyDir
cp README.md $studyDir

sed -i "s/tutorial/${studyName}/" $studyDir/config/config.yml
