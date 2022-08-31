#!/bin/bash -i

#needed for step 2: splitting 16S from 18S
mamba env create -n bbmap-env --file env/bbmap.yaml

#OPTIONAL, for checking mock denosing fidelity
mamba env create -n blast-env --file env/blast-env.yaml
