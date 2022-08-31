#!/bin/bash -i

if [[ ${#1} -eq 0 ]] ; then
    echo 'Please enter a query fasta file as the second argument (after this scripts name).'
    exit 0
fi

if [[ ${#2} -eq 0 ]] ; then
    echo 'Please enter your trim length on the left (R1) read as the third argument.'
    exit 0
fi

if [[ ${#3} -eq 0 ]] ; then
    echo 'Please enter your trim length on the right (R2) read as the fourth argument.'
    exit 0
fi

if [[ ${#3} -eq 0 ]] ; then
    echo 'Please enter the tsv file that you want to annotate with the mock blast information.'
    exit 0
fi

conda activate biopython-env

python3 /home/jesse/eASV-pipeline-for-515Y-926R/DADA2-pipeline/02-utility-scripts/split_18S_eASV_by_trim_length.py \
  --repseqs $1 --forwardtrim $2 --reversetrim $3

conda deactivate

filestem=`basename $1 .fasta`

blastn -query $filestem.R1.fasta -db /home/db/in-silico-mocks/BLAST-db/18s/all_seqs_NR_corrected.fasta -outfmt 6 -out $filestem.R1.blastout.tsv
blastn -query $filestem.R2.fasta -db /home/db/in-silico-mocks/BLAST-db/18s/all_seqs_NR_corrected.fasta -outfmt 6 -out $filestem.R2.blastout.tsv

conda activate biopython-env

python3 /home/jesse/eASV-pipeline-for-515Y-926R/DADA2-pipeline/02-utility-scripts/identify_quantify_mock_artifacts.py --forwardtrim $2 --reversetrim $3 --tsvasvtable $4 --forwardBLASTout $filestem.R1.blastout.tsv --reverseBLASTout $filestem.R2.blastout.tsv

conda deactivate
