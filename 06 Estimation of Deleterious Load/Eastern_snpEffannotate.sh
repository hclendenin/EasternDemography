#!/bin/bash
#SBATCH --partition=acomputeq       # the requested queue
#SBATCH --nodes=1              # number of nodes to use
#SBATCH --tasks-per-node=1     #
#SBATCH --mem=48G
#SBATCH --job-name="EasternImputed"
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



module load snpeff/5.0e 


snpeff -Xms2g -Xmx4g -v "ASM334442v1.99" /project/hrclndnn/EasternDemog/lifted_imputedEastern_pysam.vcf.gz > /project/hrclndnn/EasternDemog/imputedEastern_pysam.ann.vcf.gz
