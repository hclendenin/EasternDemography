#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=snpable
#SBATCH --mem=8G
#SBATCH --mail-type=END
#SBATCH --partition=computeq
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load bwa/0.7.17
module load snpable
module load seqtk
cd ~/puckettlab/genomes/uamerMappabilityMasks

#snpable tutorial: http://lh3lh3.users.sourceforge.net/snpable.shtml

#Extracting sequencnces from genome fasta file
#scafnames.txt is a file with HiC_scaffold_TEST on the inside
#touch scafnames.txt; cat HiC_scaffold_TEST > scafnames.txt
#for i in {2..37}; do sed "s/TEST/"${i}"/g" scafnames.txt > scaf.${i}.txt; seqtk subseq ~/puckettlab/genomes/Ursus_americanus_ASM334442v1_HiC.fasta scaf.${i}.txt > uamer.scaf${i}.fasta ;done


#Prepping reference genome sequences to make masks for MSMC2
cd chrTEST
bwa index ../uamer.scafTEST.fasta
splitfa ../uamer.scafTEST.fasta 35 | split -l 20000000
for let in a b c d e f g h i j k l m n o p q r s t; bwa aln -R 1000000 -O 3 -E 3 uamer.scafTEST.fasta xa${let} >> chrTEST.${let}.sai; bwa samse -f chrTEST.${let}.sam uamer.scafTEST.fasta chrTEST.${let}.sai xa${let} ; gen_raw_mask.pl chrTEST.${let}.sam >> chrTEST.${let}_rawMask35.fasta; done

#gen_mask -l 35 -r 0.5 chrTEST_rawMask35.fasta > Uamer.chrTESTMask.fasta; done

#apply the mappability mask to each chr level fasta file (first step) and make a .bed file for msmc
#apply_mask_s Uamer.chrTESTMask.fasta uamer.scafTEST.fasta > uamer.maskTEST.fasta
#apply_mask_l Uamer.chrTESTMask.fasta regions.txt > uamer.maskTEST.txt

#Run ./msmc-tools-master/makeMappabilityMask.py
#module load python/3.6.7
#for i in {2..37}; do sed "s/TEST/"${i}"/g" ~/software/msmc-tools-master/makeMappabilityMask.py > mask${i}.py; python mask${i}.py;rm mask${i}.py;done 
