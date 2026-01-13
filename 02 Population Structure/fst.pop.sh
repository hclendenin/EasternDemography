#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=fst
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq     
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load vcftools
module load bcftools/1.16

cd /project/puckett3/lc.uamer/eastern/admixture/

#~/software/plink --bfile eastern.thin --recode vcf --out eastern.thin --chr-set 37

for pop1 in CT FL Coastal MI MN MO MS NCc NCmt Ouchita Tensas UARB VA WV; do for pop2 in FL Coastal MI MN MO MS NCc NCmt Ouchita Tensas UARB VA WV; do vcftools --vcf eastern.thin.vcf --weir-fst-pop ~/scripts/${pop1}.fst.out --weir-fst-pop ~/scripts/${pop2}.fst.out --out ${pop1}.${pop2}.out; done; done


vcftools --vcf eastern.thin.vcf --weir-fst-pop ~/scripts/VA.fst.out --weir-fst-pop ~/scripts/WV.fst.out --out VA.WV.out
