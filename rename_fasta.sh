#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 --input <input_fasta> --output <output_fasta>"
    echo "   or: $0 -i <input_fasta> -o <output_fasta>"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i|--input) input_fasta="$2"; shift ;;
        -o|--output) output_fasta="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Check if both input and output arguments are provided
if [[ -z "$input_fasta" || -z "$output_fasta" ]]; then
    echo "Error: Both --input and --output must be specified"
    usage
fi

# Initialize empty arrays to store species names and sequences
species_names=()
sequences=()

# Read the FASTA file, store headers and sequences separately
while read -r line; do
    if [[ $line == ">"* ]]; then
        # Extract the genus and species names (2nd and 3rd fields)
        species=$(echo "$line" | awk '{print $2" "$3}')
        species_names+=("$species")
    else
        sequences+=("$line")
    fi
done < "$input_fasta"

# Output the renamed FASTA file
{
    for i in "${!species_names[@]}"; do
        echo ">${species_names[$i]}"
        echo "${sequences[$i]}"
    done
} > "$output_fasta"

echo "Renaming completed: $output_fasta"

