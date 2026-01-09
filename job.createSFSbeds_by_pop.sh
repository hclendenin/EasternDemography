#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=popcreateSFSbeds
#SBATCH --cpus-per-task=4
#SBATCH --mem=8Gb
#SBATCH --partition=acomputeq
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --output=popcreateSFSbeds.out
#SBATCH --error=popcreateSFSbeds.err

# Load modules
#module load python3
#python/3.12.9/gcc.8.5.0 
python/3.11.6-4zktevb

python3 /home/hrclndnn/scripts/EasternDemo/createSFSbeds_by_pop.py
