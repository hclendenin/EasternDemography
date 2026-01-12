#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH -n 8 # number of cores
#SBATCH --job-name=POPstairway
#SBATCH --mem=20Gb
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=Emily.Puckett@memphis.edu

#stairway is uniquely dumb and you must put the blueprint files in the stairway folder

cd /home/puckett3/software/stairway/

#generate stairbuilder files *do not remove the space between the path and "Stairbuilder"
#Tensas GL LARB MO NCc CT Florida AppMts
#for pop in UARB; do java -cp /home/puckett3/software/stairway/ Stairbuilder ${pop}.blueprint ;done
#yes there really is a space between the path and Stairbuilder!!

#after stairbuilder makes the *.blueprint.sh, then do:
#bash *.blueprint.sh
#**or better yet, copy some basic slurm headers into the .sh file, and push to an hpc job since it takes >2hr for a small sfs and should have some scaling w/ time

#for pop in UARB; do sed "s/POP/"${pop}"/g" stairway.sh >> ${pop}.stairway.sh; sbatch ${pop}.stairway.sh; done
#bash POP.blueprint.sh 
bash UARB.blueprint.sh 