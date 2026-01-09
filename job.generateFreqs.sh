#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=generateFreqs
#SBATCH --cpus-per-task=4
#SBATCH --mem=8Gb
#SBATCH --partition=acomputeq
#SBATCH --mail-type=ALL
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --output=generateFreqs.out
#SBATCH --error=generateFreqs.err

# Load modules
module load samtools/1.20/gcc.8.5.0 
module load bcftools
#module load python3
#module load python/3.12.9/gcc.8.5.0 
module load python/3.11.6-kj3xhgc

# Command-line arguments to pass to the script
VCF="/project/hrclndnn/EasternDemog/imputed_annotation/imputedEastern_pysam.ann.vcf"
POP_MAP="/home/hrclndnn/scripts/EasternDemo/RXY/251022_sample_pops.tsv"
OUTPUT_DIR="/project/hrclndnn/EasternDemog/251022_freq/"
POP_LIST="/home/hrclndnn/scripts/EasternDemo/RXY/251022_sample_pops.tsv"

./generate_all_freqs.sh "$VCF" "$POP_MAP" "$OUTPUT_DIR" "$POP_LIST"
