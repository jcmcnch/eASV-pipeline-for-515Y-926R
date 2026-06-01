#!/usr/bin/env bash

#this script will extract the headers from the .fasta and create a table with feature/taxonomy
#modified from script by María D. Hernández Limón to fit into a snakemake workflow

# Initialize a counter
counter=1

# Read the input file line by line
while IFS= read -r line; do
  # Check if the line starts with '>'
  if [[ "$line" == \>* ]]; then
  	# Create the new header line with feature_counter
    new_header="feature_$counter"
    #remove > from original header when saving
    clean_line="${line#>}"
    # Save the original header line to extracted file
    echo -e "$new_header\t$clean_line" >> ${snakemake_output[headers]}
    # Replace with the counter and save to output file
    echo ">feature_$counter" >> ${snakemake_output[clean]}
    # Increment the counter
    ((counter++))
  else
    # Print the line as is to the output file
    echo "$line" >> ${snakemake_output[clean]}
  fi
done < ${snakemake_input[0]}

echo "Processing complete. Check ${snakemake_output[clean]} for the result and ${snakemake_output[headers]} for the extracted headers."
