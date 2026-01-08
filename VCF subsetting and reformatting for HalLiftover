#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=liftover_pipeline
#SBATCH --cpus-per-task 8
#SBATCH --mem=4Gb
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=hrclndnn@memphis.edu



# Configurable Variables:

# Input VCF (no IDs)
INPUT_VCF="GLEastern.vcf.gz"

# Base name (without extension) – inferred
BASE_NAME=$(basename "$INPUT_VCF" .vcf.gz)

# Working directory
WORK_DIR="/project/hrclndnn/EasternDemog"

# Paths to tools
HAL_FILE="/project/mdpllard/Cactus/heather_bears/steps-output/bears_alignment.hal"
HAL_LIFTOVER="/home/mdpllard/cactus-bin-v2.8.0/bin/halLiftover"

# Genomes used in liftover
SRC_GENOME="Ursus_americanus_DNAZoo"
TGT_GENOME="Ursus_americanus_NCBI"

# Python script to update VCF coordinates
VCF_UPDATE_SCRIPT="update_vcf_coordinates.py"

# Step 1: Add Unique IDs to VCF
bcftools annotate --set-id '%CHROM\_%POS' "${WORK_DIR}/${INPUT_VCF}" -Oz -o "${WORK_DIR}/${BASE_NAME}_with_ids.vcf.gz"
tabix -p vcf "${WORK_DIR}/${BASE_NAME}_with_ids.vcf.gz"


# Step 2: Convert VCF to BED
bcftools query -f '%CHROM\t%POS0\t%END\t%ID\n' "${WORK_DIR}/${BASE_NAME}_with_ids.vcf.gz" > "${WORK_DIR}/${BASE_NAME}_with_ids.bed"


# Step 3: Liftover BED
${HAL_LIFTOVER} \
    ${HAL_FILE} \
    ${SRC_GENOME} \
    "${WORK_DIR}/${BASE_NAME}_with_ids.bed" \
    ${TGT_GENOME} \
    "${WORK_DIR}/lifted_${BASE_NAME}.bed"


# Step 4: Remove Duplicates
sort -k4,4 "${WORK_DIR}/lifted_${BASE_NAME}.bed" | uniq -u -f3 > "${WORK_DIR}/lifted_nodups_${BASE_NAME}.bed"


# Step 5: Update VCF Coordinates
python3 ${VCF_UPDATE_SCRIPT} \
    --input "${WORK_DIR}/${BASE_NAME}_with_ids.vcf.gz" \
    --lifted "${WORK_DIR}/lifted_nodups_${BASE_NAME}.bed" \
    --output "${WORK_DIR}/lifted_${BASE_NAME}_pysam.vcf.gz"


# Step 6: Sort and Index Final VCF
bcftools sort "${WORK_DIR}/lifted_${BASE_NAME}_pysam.vcf.gz" -Oz -o "${WORK_DIR}/lifted_${BASE_NAME}_SnpEffInput.vcf.gz"
tabix -p vcf "${WORK_DIR}/lifted_${BASE_NAME}_SnpEffInput.vcf.gz"
