#!/bin/bash
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --job-name=index_pos
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --output=logs/indexpos_%A_%a.out
#SBATCH --error=logs/indexpos_%A_%a.err
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00


module load angsd/0.941

POSDIR=/scratch/hrclndnn/EasternDemo/lifted_posfiles

for file in $POSDIR/*.pos; do
  echo "Indexing $file"
  angsd sites index "$file"
done
