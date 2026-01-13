#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=angsd.CHROMOSOME
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=4
#SBATCH --mem=100G
#SBATCH --time=2-12:00:00
#SBATCH --partition=ibigmemq     
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load samtools/1.16
module load bcftools/1.16
module load angsd/0.941

cd /scratch/puckett3/angsd/
#using https://github.com/nt246/physalia-lcwgs/blob/main/day_2/markdowns/01_filtering.md as a guide

#make a list of all .bam files
#ls *.bam > samp.out

#index .bam files
#for file in *.bam; do samtools index $file; done

#angsd set up
#for chr in 8; do sed "s/CHROMOSOME/"${chr}"/g" angsd_Dec18_2024.sh > angsd.${chr}.sh; sbatch angsd.${chr}.sh; done

REF=/project/puckett3lab/ref_genomes/uamer1.fasta
ANC=/project/puckett3lab/ref_genomes/uamer1.anc.fa.gz


#Decision points for above; otherwise taking the suggestions from the physalia course
#set minInd at 50% of sample size (n=184); therefore, -minInd 92
#I don't think I want to use setMinDepth and setMaxDepth; I don't understand how these parameters will affect the inference a priori.  For hard calling you estimate depth across all samples, then use 0.5x and 3x to parameterize depth cutoffs to deal w/ possible structual variants.

#doMajorMinor 5 means using the ancestral dataset to identify the major alleles; however, physalia says: In general, -GL 1, -doMaf 1/2, and -doMajorMinor 1 should be the preferred choice when data uncertainty is high.

#make samp.out file; after code, do check manually so nothing extra in there
#ls *.bam > samp.out

#Genotype likelihoods
#doGlf 2 and doMajorMinor 1 = beagle files output; once remove header and first three columns from beagle output, can use within ngsLD to begin prunning for eventual pca and structure plots
#mean depth across all samples (lc and hc) is 5.1, with sum of 936.2
#mean depth across lc samples is 3.7, sum 641
#mean depth of hc samples (n=11) is 26.8, with sum of 295
#if I wanted to -setMinDepth, how could I think about this given that hc samples will often by themselves have enough depth to force a call
#maxDepth easier to think about, going w/ 2.5x the total mean depth = 2340
angsd -b samp.out -ref $REF -anc $ANC -out ./ALL.CHROMOSOME -nThreads 4 -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 -minMapQ 20 -minQ 20 -minInd 92 -setMinDepthInd 1 -maxDepth 2340 -doCounts 1 -skipTriallelic 1 -r HiC_scaffold_CHROMOSOME -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 1 -doGeno 18 -doPost 1

#Extract alleles from maf file
#gunzip -c ALL.CHROMOSOME.mafs.gz | cut -f 1,2,3,4 | tail -n +2 > snplist.CHROMOSOME.txt
#angsd sites index snplist.CHROMOSOME.txt
#run ngsLD
#from output could make PCA and run ngsAdmix

#Hard calls
#SNP_pval and doVCF to get VCF; doMajorMinor 5 will set ancestral allele as the major allele
angsd -b samp.out -ref $REF -anc $ANC -out ./ALL.CHROMOSOME -nThreads 4 -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 -minMapQ 20 -minQ 20 -minInd 92 -setMinDepthInd 1 -doCounts 1 -skipTriallelic 1 -r HiC_scaffold_CHROMOSOME -GL 1 -doPost 1 -doMaf 1 -doMajorMinor 5 -doGeno 18 -SNP_pval 1e-6 -doBcf 1
#add -doPlink 2 for plink; -doVCF depreciated use -doBcf 1

bcftools index ./ALL.CHROMOSOME.bcf

