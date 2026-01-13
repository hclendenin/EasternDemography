#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=treemix
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=4
#SBATCH --mem=100G
#SBATCH --time=2-12:00:00
#SBATCH --partition=ibigmemq     
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load samtools/1.16
module load bcftools/1.16
module load angsd/0.941
module load R/4.3.2/gcc.13.2.0
module load treemix/1.13

cd /scratch/puckett3/angsd/

#step 1 pull out americanus sites from brown bear samples


#step 2- create a .bed file 
#taking the .bim file used for admixture w/ 77k sites and converting it into format needed for regions file w/in ANGSD
#if you want to supply essentially a .bed file use -rf flag to input a file in format chr1:1

#step 3, call snps for brown and Am black bears
REF=/project/puckett3lab/ref_genomes/uamer1.fasta
ANC=/project/puckett3lab/ref_genomes/uamer1.anc.fa.gz

#angsd -b samp.out -ref $REF -anc $ANC -out ./arctosGYE.sites -nThreads 4 -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 -minMapQ 20 -minQ 20 -minInd 92 -setMinDepthInd 1 -doCounts 1 -skipTriallelic 1 -rf /home/puckett3/scripts/admixture.sites.txt -GL 1 -doPost 1 -doMaf 1 -doMajorMinor 5 -doGeno 18 -SNP_pval 1e-6 -doBcf 1

#step 4 convert to plink format
#~/software/plink --bcf arctosGYE.sites.bcf --make-bed --out east.TM --double-id --aec

#make pop file
#hand made treemix.pop.txt

#step 5 .freq function in plink to make treemix input
~/software/plink --bfile east.TM --remove remove.txt --aec --out east.TM --freq --within treemix.pop.txt
gzip east.TM.frq.strat
~/plink2treemix.py east.TM.frq.strat.gz east.treemix.gz

#run treemix
treemix -i east.treemix.gz -root Brown -k 1000 -o eastTM.m0
treemix -i east.treemix.gz -root Brown -k 1000 -m 1 -o eastTM.m1
treemix -i east.treemix.gz -root Brown -k 1000 -m 2 -o eastTM.m2
treemix -i east.treemix.gz -root Brown -k 1000 -m 3 -o eastTM.m3
treemix -i east.treemix.gz -root Brown -k 1000 -m 4 -o eastTM.m4
treemix -i east.treemix.gz -root Brown -k 1000 -m 5 -o eastTM.m5
treemix -i east.treemix.gz -root Brown -k 1000 -m 6 -o eastTM.m6
treemix -i east.treemix.gz -root Brown -k 1000 -m 7 -o eastTM.m7
treemix -i east.treemix.gz -root Brown -k 1000 -m 8 -o eastTM.m8
treemix -i east.treemix.gz -root Brown -k 1000 -m 9 -o eastTM.m9



