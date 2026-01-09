#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=lift_pos
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --array=0-2
#SBATCH --partition=acomputeq
#SBATCH --output=logs/lift_pos_%A_%a.out
#SBATCH --error=logs/lift_pos_%A_%a.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=hrclndnn@memphis.edu

#Inputs
POS_DIR="/scratch/hrclndnn/EasternDemo/pos_files"
BED_FILE="/project/hrclndnn/EasternDemog/lifted_GLEastern.bed"
OUT_DIR="/scratch/hrclndnn/EasternDemo/lifted_posfiles"

mkdir -p "$OUT_DIR"

#Array of .pos files
POS_FILES=($(ls ${POS_DIR}/*.pos))
POS_FILE="${POS_FILES[$SLURM_ARRAY_TASK_ID]}"

#Extract base file name
BASE=$(basename "$POS_FILE" .pos)
OUT_FILE="${OUT_DIR}/${BASE}.hic.pos"

echo "Processing $POS_FILE -> $OUT_FILE"

#Load Python
module load python/3.10.13/gcc.8.5.0

# === Run Python mapping script ===
python3 <<EOF
import sys

bed_path = "$BED_FILE"
pos_file = "$POS_FILE"
output_file = "$OUT_FILE"

# Step 1: Build mapping
coord_map = {}
with open(bed_path) as bed:
    for line in bed:
        chrom, start, end, hic_id = line.strip().split('\t')
        pos = int(start) + 1
        key = f"{chrom}_{pos}"
        hic_scaffold = "_".join(hic_id.split("_")[:-1])
        hic_pos = hic_id.split("_")[-1]
        coord_map[key] = (hic_scaffold, hic_pos)

# Step 2: Convert
converted = 0
skipped = 0

with open(pos_file) as inp, open(output_file, "w") as out:
    for line in inp:
        chrom, pos = line.strip().split('\t')
        key = f"{chrom}_{pos}"
        if key in coord_map:
            hic_chrom, hic_pos = coord_map[key]
            out.write(f"{hic_chrom}\t{hic_pos}\n")
            converted += 1
        else:
            skipped += 1

print(f"Converted {converted} variants from {pos_file}")
print(f"Skipped {skipped} variants")
EOF
