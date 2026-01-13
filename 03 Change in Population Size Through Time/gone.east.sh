#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --cpus-per-task=8
#SBATCH --job-name=gone.east
#SBATCH --mail-type=ALL
#SBATCH --mem=60G
#SBATCH --time=2-12:00:00
#SBATCH --partition=acomputeq
#SBATCH --mail-user=Emily.Puckett@memphis.edu

cd /scratch/puckett3/gone/uamer/Linux
module load vcftools
module load bcftools
module load gone/git/gcc.8.5.0

#Approach for using the imputed data
#Take imputed full file and break up into pop specific .ped/.map files
#subset by population
#LARB Tensas  GL AppMtns UARB
for pop in UARB.partial; do bcftools view -S ${pop}.samps.txt -r HiC_scaffold_2,HiC_scaffold_3,HiC_scaffold_4,HiC_scaffold_5,HiC_scaffold_6,HiC_scaffold_7,HiC_scaffold_8,HiC_scaffold_9,HiC_scaffold_10,HiC_scaffold_11,HiC_scaffold_12,HiC_scaffold_13,HiC_scaffold_14,HiC_scaffold_15,HiC_scaffold_16,HiC_scaffold_17,HiC_scaffold_18,HiC_scaffold_19,HiC_scaffold_20,HiC_scaffold_21,HiC_scaffold_22,HiC_scaffold_23,HiC_scaffold_24,HiC_scaffold_25,HiC_scaffold_26,HiC_scaffold_27,HiC_scaffold_28,HiC_scaffold_29,HiC_scaffold_30,HiC_scaffold_31,HiC_scaffold_32,HiC_scaffold_33,HiC_scaffold_34,HiC_scaffold_35,HiC_scaffold_36,HiC_scaffold_37 --force-samples -Oz -o ${pop}.temp.vcf.gz /project/puckett3/lc.uamer/eastern/uamer.lchc.mar2024.vcf.gz; done

for pop in UARB.partial; do ~/software/plink --vcf ${pop}.temp.vcf.gz -aec --geno 1 --recode --out $pop; done

for pop in UARB.partial; do sed -i 's/HiC_scaffold_//g' ${pop}.map; awk 'BEGIN {OFS="\t"} {print $1,$1"."$4,$3,$4}' ${pop}.map > test.map; mv test.map ${pop}.map; done


#Had challenges when all chr were output instead of only chr w/ lots of sites.  Kept giving a segmentation fault error.  Code above that first limited to good chrs fixed the problem.

#cp -r /opt/ohpc/pub/apps/uofm/gone/git/Linux ./

#GONE
for pop in GL; do for rep in {1..50}; do  bash ./script_GONE.sh $pop ; cp Output_Ne_${pop} >> Output_Ne_${rep}.${pop}; done;done 

#From Eric
#I've modified script_GONE.sh and PROGRAMMES/GONEparallel.sh to work with slurm and use the programs that were compiled. If you run script_GONE.sh without a job, it will just use 4 threads.

#############

#Approach for using the phased and beagle imputed GLs
#for pop in AppMtns UARB LARB Tensas  GL; do bcftools view -S ${pop}.samps.txt --force-samples -Oz -o ${pop}.temp.vcf.gz /scratch/puckett3/angsd/eastGL.phased.vcf.gz; done


#for pop in AppMtns UARB LARB Tensas  GL; do ~/software/plink --vcf ${pop}.temp.vcf.gz -aec --geno 1 --recode --out $pop; done

#for pop in AppMtns UARB LARB Tensas  GL; do sed -i 's/HiC_scaffold_//g' ${pop}.map; awk 'BEGIN {OFS="\t"} {print $1,$1"."$4,$3,$4}' ${pop}.map > test.map; mv test.map ${pop}.map; done


#Had challenges when all chr were output instead of only chr w/ lots of sites.  Kept giving a segmentation fault error.  Code above that first limited to good chrs fixed the problem.

#cp -r /opt/ohpc/pub/apps/uofm/gone/git/Linux ./

#GONE
#for pop in AppMtns UARB LARB Tensas  GL; do bash ./script_GONE.sh $pop ;done

#concatenate file
tail -n +2 Output_Ne_1.Tensas > Tensas.gone.out
eval paste $(printf "<(tail -n +2 Output_Ne_%s.Tensas | cut -f2) " {2..50}) >> Tensas.gone.out

tail -n +2 Output_Ne_1.GL > GL.gone.out
eval paste $(printf "<(tail -n +2 Output_Ne_%s.GL | cut -f2) " {2..50}) > GL.gone.out

tail -n +2 Output_Ne_1.AppMtns > AppMtns.gone.out
eval paste $(printf "<(tail -n +2 Output_Ne_%s.AppMtns | cut -f2) " {2..50}) >> AppMtns.gone.out

tail -n +2 Output_Ne_1.Coastal > Coastal.gone.out
eval paste $(printf "<(tail -n +2 Output_Ne_%s.Coastal | cut -f2) " {2..50}) >> Coastal.gone.out

tail -n +2 Output_Ne_1.UARB > UARB.gone.out
eval paste $(printf "<(tail -n +2 Output_Ne_%s.UARB | cut -f2) " {2..50}) >> UARB.gone.out

tail -n +2 Output_Ne_1.UARBcluster > UARBcluster.gone.out
eval paste $(printf "<(tail -n +2 Output_Ne_%s.UARBcluster | cut -f2) " {2..50}) >> UARBcluster.gone.out



