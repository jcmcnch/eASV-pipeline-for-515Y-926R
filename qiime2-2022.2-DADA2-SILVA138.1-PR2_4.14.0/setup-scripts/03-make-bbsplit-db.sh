#!/bin/bash -i
#activate environment
conda activate bbmap-env

currdir=$PWD

#make directory, enter it
mkdir -p /home/$USER/databases/bbsplit-db/ ; cd /home/$USER/databases/bbsplit-db

#download database files from OSF
for item in kv3xp eux4r npb2k 4qtev s5j6q 5jmkv eahds ; do curl -O -J -L https://osf.io/$item/download ; done

#make databases
chmod u+x make-dbs-bbsplit.sh ; ./make-dbs-bbsplit.sh

cd $currdir

echo ""
echo "Your bbsplit database is stored at /home/$USER/databases/bbsplit-db/EUK-PROK-bbsplit-db/"
echo "Make sure the path to this splitting database is correctly specified in your config file."
