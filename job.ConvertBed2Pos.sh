#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --job-name=BED_to_POS
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --output=logs/BED2POS_%j.out
#SBATCH --error=logs/BED2POS_%j.err
#SBATCH --time=01:00:00

module load angsd/0.941

BED_DIR=/scratch/hrclndnn/EasternDemo
#GLEastern_DNAzoo.LOF.bed
#GLEastern_DNAzoo.missense.bed
#GLEastern_DNAzoo.synonymous.bed
OUTDIR=/scratch/hrclndnn/EasternDemo/pos_files

mkdir -p "$OUTDIR"

# Adjust these if your BED files have different names
CATEGORIES=("synonymous" "missense" "LOF")

for cat in "${CATEGORIES[@]}"; do
  BEDFILE="${BED_DIR}/GLEastern_DNAzoo.${cat}.bed"
  POSFILE="${OUTDIR}/${cat}.pos"

  if [[ -s "$BEDFILE" ]]; then
    echo "Converting $BEDFILE to $POSFILE..."
    awk '{print $1 "\t" $3}' "$BEDFILE" > "$POSFILE"

    # Index the POS file for ANGSD
    angsd sites index "$POSFILE"
    echo "Indexed POS file: $POSFILE"
  else
    echo "WARNING: Missing or empty BED file: $BEDFILE"
  fi
done

echo "Done converting BED files to POS format."
