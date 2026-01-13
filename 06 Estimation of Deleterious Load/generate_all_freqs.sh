 #!/bin/bash

vcf_path="$1"         # e.g. imputedEastern_pysam.ann.vcf.gz
mapfile="$2"          # sample_pop_map.tsv
outdir="$3"           # e.g. freq/
mkdir -p "$outdir"

# Categories to extract
declare -A cat_filter=(
  [LOF]='frameshift_variant|start_lost|stop_gained'
  [missense]='missense_variant'
  [synonymous]='synonymous_variant'
)

# Loop categories
for cat in "${!cat_filter[@]}"; do
  echo "== Processing category: $cat =="

  # Filter VCF by annotation category
bcftools view -i "INFO/ANN ~ \"${cat_filter[$cat]}\"" "$vcf_path" | \
    bcftools sort -Oz -o temp_${cat}.vcf.gz
bcftools index temp_${cat}.vcf.gz


  # Run Python per category
  python3 make_freq_by_pop.py \
     --vcf temp_${cat}.vcf.gz \
     --map "$mapfile" \
     --category "$cat" \
     --output "$outdir"

  rm temp_${cat}.vcf.gz temp_${cat}.vcf.gz.csi
done
