#!/bin/bash
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --job-name=2D_SFS_compare
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --output=logs/2dSFS_%j.out
#SBATCH --error=logs/2dSFS_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --array=0-2


module load angsd/0.941
module load ngsld/1.2.0

#POPS=(AppMtns GL LARB Tensas)
POPS=(LARB UARB TENSAS)
CATEGORIES=("synonymous" "missense" "LOF")
cat=${CATEGORIES[$SLURM_ARRAY_TASK_ID]}

SAFDIR=/scratch/hrclndnn/EasternDemo/sfs_files
OUTDIR=/scratch/hrclndnn/EasternDemo/2dsfs
mkdir -p "$OUTDIR"

echo "Starting 2D SFS comparisons for category: $cat"

for ((i=0; i<${#POPS[@]}; i++)); do
  for ((j=i+1; j<${#POPS[@]}; j++)); do
    pop1=${POPS[$i]}
    pop2=${POPS[$j]}

    saf1="${SAFDIR}/${cat}.${pop1}.sfs.saf.idx"
    saf2="${SAFDIR}/${cat}.${pop2}.sfs.saf.idx"
    output="${OUTDIR}/${cat}.${pop1}_vs_${pop2}.2dsfs"

    if [[ -f "$saf1" && -f "$saf2" ]]; then
      echo "[$(date)] Computing 2D SFS for $cat: $pop1 vs $pop2"
      realSFS "$saf1" "$saf2" -fold 0 -P 8 > "$output"

      if [[ -s "$output" ]]; then
        echo "Successfully saved: $output"
      else
        echo "Output file is empty: $output"
      fi
    else
      echo "Missing .saf.idx file(s) for $pop1 or $pop2 in category $cat. Skipping."
    fi
  done
done

echo "Done with 2D SFS for category: $cat"
