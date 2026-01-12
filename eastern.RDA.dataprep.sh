#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=rda.samples
#SBATCH --mem=48G
#SBATCH --mail-type=END
#SBATCH --partition=acomputeq
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load bcftools
module load vcftools

cd /project/puckett3/lc.uamer/eastern/

#sample and site seleciton for RDA
#thins to LMAV data only
bcftools view -S /project/puckett3/lc.uamer/eastern/rda/samples.txt -Oz -o temp.vcf.gz uamer.lchc.mar2024.vcf.gz

#removes Missouri and UARB
vcftools --gzvcf temp.vcf.gz --remove /project/puckett3/lc.uamer/eastern/rda/removetest.txt --recode --out temp2

#maf and missing filters
vcftools --vcf temp2.recode.vcf --max-missing 1 --maf 0.05 --recode --out temp3
#4800386 SNPs

#thin data
vcftools --vcf temp3.recode.vcf --thin 20000 --plink-tped --out /project/puckett3/lc.uamer/eastern/rda/east
#105359 SNPs

cd ./rda
#convert to .raw
~/software/plink --tped east.tped --tfam east.tfam --recode A --out /project/puckett3/lc.uamer/eastern/rda/east

