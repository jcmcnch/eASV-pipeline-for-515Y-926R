#!/bin/bash

for item in `ls 10-exports/*.with-tax.tsv`; do
	
	outdir=`dirname $item`
	filestem=`basename $item .tsv`

	/home/melody/Run055/March2019-eASV-515Y-926R/eASV-pipeline-for-515Y-926R/DADA2-pipeline/02-utility-scripts/transform-ESV-tsv-to-proportions.py --input $item --output $outdir/$filestem.proportions.tsv --minimum_abundance_filtered_output $outdir/$filestem.proportions-minabund-0.01.tsv --minimum_abundance_threshold 0.01 --cumulative_abundance_filtered_output $outdir/$filestem.proportions-cumabund-0.99.tsv --cumulative_abundance_threshold 0.99

done
