#!/bin/bash
#SBATCH --partition=abigmemq       # the requested queue
#SBATCH --nodes=1              # number of nodes to use
#SBATCH --tasks-per-node=1     #
#SBATCH --mem=48G
#SBATCH --job-name="Liftover_EasternImputed"
#SBATCH --mail-user=hrclndnn@memphis.edu  # email address used for event notification
#SBATCH --mail-type=end                                   # email on job end
#SBATCH --mail-type=fail                                  # email on job failure
#SBATCH --mail-type=begin                                  # email on job start

echo "Usable Environment Variables:"
echo "============================="
echo "hostname=$(hostname)"
echo \$SLURM_JOB_ID=${SLURM_JOB_ID}
echo \$SLURM_NTASKS=${SLURM_NTASKS}
echo \$SLURM_NTASKS_PER_NODE=${SLURM_NTASKS_PER_NODE}
echo \$SLURM_MEM_PER_CPU=${SLURM_MEM_PER_CPU}

/home/mdpllard/cactus-bin-v2.8.0/bin/halLiftover /project/mdpllard/Cactus/heather_bears/steps-output/bears_alignment.hal \
    Ursus_americanus_DNAZoo \
    /project/hrclndnn/EasternDemog/imputedEastern.bed \
    Ursus_americanus_NCBI \
    /project/hrclndnn/EasternDemog/lifted_imputedEastern.bed
