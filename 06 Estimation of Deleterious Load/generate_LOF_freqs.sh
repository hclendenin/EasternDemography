#!/bin/bash

# Usage: ./generate_lof_freqs.sh input.vcf.gz sample_pop_map.tsv output_directory/

vcf_path="$1"         # e.g. imputedEastern_pysam.ann.vcf.gz
mapfile="$2"          # sample_pop_map.tsv
outdir="$3"           # e.g. freq/
mkdir -p "$outdir"

# Define individual LOF subtypes
declare -A lof_subtypes=(
  [frameshift_variant]="frameshift_variant"
  [start_lost]="start_lost"
  [stop_gained]="stop_gained"
)

# Output file for combined frequencies
combined_out="${outdir}/LOF.freq"
> "$combined_out"  # Empty or create output file

# Loop over LOF subtypes
for subtype in "${!lof_subtypes[@]}"; do
  echo "== Processing LOF subtype: $subtype =="

  # Filter VCF by LOF subtype
  bcftools view -i "INFO/ANN ~ \"${lof_subtypes[$subtype]}\"" "$vcf_path" | \
    bcftools sort -Oz -o "temp_${subtype}.vcf.gz"
  bcftools index "temp_${subtype}.vcf.gz"

  # Run frequency calculation
  python3 make_freq_by_pop.py \
     --vcf "temp_${subtype}.vcf.gz" \
     --map "$mapfile" \
     --category "$subtype" \
     --output "$outdir"

# Append all population-level freq files for this subtype
for f in "${outdir}"/*."${subtype}.freq"; do
  if [[ -f "$f" ]]; then
    cat "$f" >> "$combined_out"
  else
    echo "Warning: No files found for subtype ${subtype}"
  fi
done


  # Cleanup
rm -f "temp_${subtype}.vcf.gz" "temp_${subtype}.vcf.gz.csi"


echo "Combined LOF frequency file created at: $combined_out"
