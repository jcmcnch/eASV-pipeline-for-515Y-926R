#!/bin/bash -i
#activate environment
conda activate bbmap-env

#make directory, enter it
mkdir -p ~/bbsplit-db/ ; cd ~/bbsplit-db

#download database files from OSF
for item in kv3xp eux4r npb2k 4qtev s5j6q 5jmkv eahds ; do curl -O -J -L https://osf.io/$item/download ; done

#make databases
chmod u+x make-dbs-bbsplit.sh ; ./make-dbs-bbsplit.sh

#once done, move to path specified in scripts (modify according to your preferences)
sudo mv ~/bbsplit-db /home/db/
