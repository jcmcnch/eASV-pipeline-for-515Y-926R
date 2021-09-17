#!/bin/bash -i

conda activate qiime2-2019.4

for item in `ls 15-exports/04-converted-biom-to-tsv/non-chloroplasts/*.tsv`; do
	
	outdir=`dirname $item`
	filestem=`basename $item .tsv`

	transform-ESV-tsv-to-proportions.py --input $item --output $outdir/$filestem.proportions.tsv --minimum_abundance_filtered_output $outdir/$filestem.proportions-minabund-0.01.tsv --minimum_abundance_threshold 0.01 --cumulative_abundance_filtered_output $outdir/$filestem.proportions-cumabund-0.99.tsv --cumulative_abundance_threshold 0.99

done

for item in `ls 15-exports/04-converted-biom-to-tsv/chloroplasts/*.tsv`; do

        outdir=`dirname $item`
        filestem=`basename $item .tsv`

        transform-ESV-tsv-to-proportions.py --input $item --output $outdir/$filestem.proportions.tsv --minimum_abundance_filtered_output $outdir/$filestem.proportions-minabund-0.01.tsv --minimum_abundance_threshold 0.01 --cumulative_abundance_filtered_output $outdir/$filestem.proportions-cumabund-0.99.tsv --cumulative_abundance_threshold 0.99

done

