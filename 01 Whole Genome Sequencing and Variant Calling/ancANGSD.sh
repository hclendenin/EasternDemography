#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=ANCangsd
#SBATCH --mail-type=ALL
#SBATCH --mem=200G
#SBATCH --partition=ibigmemq      
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load samtools/1.16
module load bcftools/1.16
module load angsd/0.941

cd /scratch/puckett3/introgression/uamer1.bam/
#https://www.popgen.dk/angsd/index.php/Fasta#Ancestral_fasta_using_multiple_outgroups 

#index files
#samtools index amer1.umayl.SuB13.bam
#samtools index uamer1.GYE953.bam

#going to use the following samples:
#U. arctos = GYE953 (Yellowstone population); depth = 19.8
#U. thibetanus = DRR250459 (Japanese population); depth = 66.0
#U. maylanus = SuB_13 (see Zhou et al 2022 PNAS paper); depth = 54.2
#U. ursinus = SlB_03 (see Zhou et al 2022 PNAS paper); depth = 42.0

#estimate depth from samples to decide on value for setMinDepthInd parameter
#for file in uamer1.GYE953.bam uamer1.DRR250459.bam amer1.umayl.SuB13.bam CRR324585.uamer.RG.dup.sorted.bam; do echo $file >> uamer1.anc.depth; samtools depth -r HiC_scaffold_30 $file | awk '{sum+=$3} END { print "Average = ",sum/NR}' >> uamer1.anc.depth;done

#testing this out on the smallest uamer1 scaffold before setting up all 36 to go concurrent
angsd -b fourOutgroup.bamlist -out uamer1.anc -doCounts 1 -snp_pval 0.01 -domaf 1 -domajorminor 1 -gl 2 -rmSNPs 1 -minind 4 -setMinDepthInd 15 -explode 1 -doFasta 2 
