#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=admixture
#SBATCH --mem=48G
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load bcftools
module load vcftools
module load admixture/1.3.0

cd /project/puckett3/lc.uamer/eastern/admixture/

#Aug 15, 2025
#vcftools --gzvcf /project/puckett3/lc.uamer/eastern/uamer.lchc.mar2024.vcf.gz --exclude-bed /project/puckett3/lc.uamer/eastern/Uamer.genemask.50kb.bed --recode --out uamer.lchc.mask.vcf
#After filtering, kept 2768412 out of a possible 7369660 Sites

#Remove samples not in this project
#vcftools --vcf uamer.lchc.mask.vcf.recode.vcf --keep ../eastern.samp.txt --recode --out east.mask

#filter
#vcftools --vcf east.mask.recode.vcf --maf 0.05 --max-missing 0.9 --recode --out east.lchc.maf
#After filtering, kept 1837685 out of a possible 2768412 Sites
#vcftools --vcf east.lchc.maf.recode.vcf --thin 10000 --recode --out east.lchc.thin
#After filtering, kept 77197 out of a possible 1837685 Sites

#~/software/plink --vcf east.lchc.thin.recode.vcf --aec --pca --out east.thin.Aug15_2025


#~/software/plink --vcf east.lchc.thin.recode.vcf --aec --make-bed --out eastern.thin
#for K in {1..25}; do sed "s/K/"$K"/g" admixture.sh > east.admixture.$K.sh; sbatch east.admixture.$K.sh; done
#sed -i -e 's/HiC_scaffold_//g' eastern.thin.bim
admixture --cv=20 eastern.thin.bed K | tee logK.out

#Kplots
#grep -h CV log*.out > eastern.K.Aug2025.out

