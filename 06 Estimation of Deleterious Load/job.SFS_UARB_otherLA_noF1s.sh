#!/bin/bash
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --cpus-per-task=8
#SBATCH --job-name=SFS_byPop
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=hrclndnn@memphis.edu
#SBATCH --output=logs/SFS_%A_%a.out
#SBATCH --error=logs/SFS_%A_%a.err
#SBATCH --array=0-1
#SBATCH -t 14-00:00:00

set -euo pipefail  # safer scripting

#Load required modules
module load samtools/1.16
module load bcftools/1.16
module load angsd/0.941
module load ngsld/1.2.0
module load python/3.10.13/gcc.8.5.0

#Check log directory exists
mkdir -p logs/

#Create populations array
POPS=(UARB_noF1s other_LA_noF1s)
POP=${POPS[$SLURM_ARRAY_TASK_ID]}

echo "[`date`] Running population: $POP"

#Set paths
REF=/project/puckett3lab/ref_genomes/uamer1.fasta
ANC=/project/puckett3lab/ref_genomes/uamer1.anc.fa.gz
POS_DIR=/scratch/hrclndnn/EasternDemo/lifted_posfiles
OUTDIR=/scratch/hrclndnn/EasternDemo/sfs_files

#Declare BAM lists
declare -A BAMLISTS=(
  ["UARB_noF1s"]="/home/hrclndnn/scripts/EasternDemo/bamlists/UARB_noF1s.txt"
  ["other_LA_noF1s"]="/home/hrclndnn/scripts/EasternDemo/bamlists/otherLA_noF1s.txt"
 # ["AppMtns"]="/home/hrclndnn/scripts/EasternDemo/bamlists/AppMtns.fullpath.bamlist.txt"
 # ["GL"]="/home/hrclndnn/scripts/EasternDemo/bamlists/GL.fullpath.bamlist.txt"
)

#Categories of variants
CATEGORIES=("synonymous" "missense" "LOF")

BAMLIST="${BAMLISTS[$POP]}"

#Check BAM list files
if [[ ! -s "$BAMLIST" ]]; then
  echo "ERROR: BAM list file $BAMLIST not found or empty!"
  exit 1
fi

#ANGSD + realSFS wrapper
run_angsd() {
  local cat=$1
  local posfile="${POS_DIR}/${cat}.hic.pos"
  local outfile="${OUTDIR}/${cat}.${POP}.sfs"

  echo "[`date`] Starting ANGSD for $POP - $cat"

  #Check sites file
  if [[ ! -s "$posfile" ]]; then
    echo "ERROR: Sites file $posfile not found or empty!"
    exit 1
  fi

  #Run ANGSD w/ doSaf
  angsd \
    -bam "$BAMLIST" \
    -ref "$REF" \
    -anc "$ANC" \
    -sites "$posfile" \
    -doSaf 1 \
    -GL 1 \
    -P "$SLURM_CPUS_PER_TASK" \
    -C 50 -baq 1 -minMapQ 20 -minQ 20 \
    -out "$outfile"

  #Run realSFS
  realSFS "${outfile}.saf.idx" -fold 0 -P "$SLURM_CPUS_PER_TASK" > "${outfile}"

  echo "[`date`] Finished ANGSD for $POP - $cat"
}

#Run each category in parallel
for cat in "${CATEGORIES[@]}"; do
  run_angsd "$cat" &
done

wait  #Wait for all background jobs to finish

echo "[`date`] Done with population $POP."
