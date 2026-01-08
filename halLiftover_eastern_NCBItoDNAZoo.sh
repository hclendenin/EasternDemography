#!/bin/bash
#SBATCH --partition=abigmemq       # the requested queue
#SBATCH --nodes=1              # number of nodes to use
#SBATCH --tasks-per-node=1     #
#!/bin/bash
#SBATCH --partition=abigmemq
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=48G
#SBATCH --job-name="Liftover_Eastern"
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --array=0-4

echo "Usable Environment Variables:"
echo "============================="
echo "hostname=$(hostname)"
echo "SLURM_JOB_ID=${SLURM_JOB_ID}"
echo "SLURM_NTASKS=${SLURM_NTASKS}"
echo "SLURM_NTASKS_PER_NODE=${SLURM_NTASKS_PER_NODE}"
echo "SLURM_MEM_PER_CPU=${SLURM_MEM_PER_CPU}"

# BED files to process (already converted)
BED_FILES=(
    "LOF_Eastern.shared.bed"
    "missense_Eastern.fixed_ALT.bed"
    "missense_Eastern.shared.bed"
    "synonymous_Eastern.fixed_ALT.bed"
    "synonymous_Eastern.shared.bed"
)

# Pick the file for this array task
BED_FILE="${BED_FILES[$SLURM_ARRAY_TASK_ID]}"

INPUT_DIR="/home/hrclndnn/EasternDemog"
HAL_FILE="/project/mdpllard/Cactus/heather_bears/steps-output/bears_alignment.hal"
SRC_GENOME="Ursus_americanus_NCBI"
TGT_GENOME="Ursus_americanus_DNAZoo"

OUTPUT_DIR="${INPUT_DIR}/liftover_output"
mkdir -p "$OUTPUT_DIR"

INPUT_BED="${INPUT_DIR}/${BED_FILE}"
OUTPUT_BED="${OUTPUT_DIR}/DNAzoo_${BED_FILE}"

# Check that the input BED exists
if [[ ! -f "$INPUT_BED" ]]; then
    echo "Error: Input BED not found: $INPUT_BED"
    exit 1
fi

echo "Processing file: $BED_FILE"
echo "Input BED: $INPUT_BED"
echo "Output BED: $OUTPUT_BED"

# Run halLiftover
/home/mdpllard/cactus-bin-v2.8.0/bin/halLiftover \
    "$HAL_FILE" \
    "$SRC_GENOME" \
    "$INPUT_BED" \
    "$TGT_GENOME" \
    "$OUTPUT_BED" \
    --bedType 4

if [[ $? -eq 0 ]]; then
    echo "Liftover completed successfully for $BED_FILE"
else
    echo "Error: Liftover failed for $BED_FILE"
fi

echo "All done."
