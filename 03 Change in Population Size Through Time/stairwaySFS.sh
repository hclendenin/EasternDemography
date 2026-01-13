#!/bin/bash 
#SBATCH -N 1 # number of nodes
#SBATCH -n 8 # number of cores
#SBATCH --mem=8Gb
#SBATCH --time=2:00:00
#SBATCH --job-name=POP.CHR
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load samtools/1.16
module load bcftools/1.16
module load angsd/0.941
module load ngsld/1.2.0

cd /scratch/puckett3/angsd/

REF=/project/puckett3lab/ref_genomes/uamer1.fasta
ANC=/project/puckett3lab/ref_genomes/uamer1.anc.fa.gz

#Florida test
#angsd -bam /home/puckett3/scripts/FL.bamlist.txt -ref $REF -anc $ANC -r HiC_scaffold_CHR -doSaf 1 -out FLsfs.CHR -GL 1 -P 4 -C 50 -baq 1 -minMapQ 20 -minQ 20

#no folding b/c we have the real ancestral states defined
#/opt/ohpc/pub/apps/uofm/angsd/0.941/bin/misc/realSFS FLsfs.CHR.saf.idx -fold 0 -maxIter 100 -cores 8 > FL.CHR.sfs

#post processing
#for chr in {2..37}; do cat FL.${chr}.sfs >> FL.temp.sfs; done
#pull everything into Excel, sum, and output new file

#get number of sites that passed quality filters for the blueprint file
#for chr in {2..37}; do grep filtering FLsfs.${chr}.arg >> FL.numsites.out; done

#for file in {1717346..1717381}; do grep filtering slurm-${file}.out >> FL.numsites.out;done

#LARB
#for samp in LAC349 LAC366 LAC371 LAC377 LAC378 LAC379 LAC383 LAC397 LAC399 LAC407 LAC427 LAC429; do echo *.${samp}*bam >> LARB.bamlist.txt;done 

#Tensas
#for file  in *LAT*bam; do echo $file >> Tensas.bamlist.txt;done
#echo LA_T*bam >> Tensas.bamlist.txt

#App Mtns (NCmt,VA, and WV)
#for file in *NCmt*bam; do echo $file >> AppMtns.bamlist.txt;done
#echo NC00417*bam >> AppMtns.bamlist.txt
#echo NC056*bam >> AppMtns.bamlist.txt
#for file in *VA*bam; do echo $file >> AppMtns.bamlist.txt;done 
#for file in *WV*bam; do echo $file >> AppMtns.bamlist.txt;done 

#Great Lakes (MN and MI)
#for file in *MN*bam; do echo $file >> GL.bamlist.txt;done
#for file in *MI*bam; do echo $file >> GL.bamlist.txt;done

#NC coast
#for file in *NCc*bam; do echo $file >> NCc.bamlist.txt;done
#echo NC00417*bam >> NCc.bamlist.txt

#Missouri
#for file in *MO*bam; do echo $file >> MO.bamlist.txt;done

#CT
#for file in *CT*bam; do echo $file >> CT.bamlist.txt;done

#UARB
#for samp in LAP160 LAP161 LAP162 LAP163 LAP164 LAP165 LAP166 LAP167 LAP168 LAP170 LAP171 LAP172 LAP173; do echo *.${samp}*bam >> UARB.bamlist.txt;done 


#batch by pop b/c need to record the slurm outputs to count the sites
##LARB Tensas AppMtns GL UARB MO CT NCc LARB Tensas AppMtns GL
#for pop in  UARB; do sed "s/POP/"${pop}"/g" stairwaySFS.sh > ${pop}.sfs.sh; done
angsd -bam /home/puckett3/scripts/POP.bamlist.txt -ref $REF -anc $ANC -r HiC_scaffold_CHR -doSaf 1 -out POPsfs.CHR -GL 1 -P 4 -C 50 -baq 1 -minMapQ 20 -minQ 20

#no folding b/c we have the real ancestral states defined
/opt/ohpc/pub/apps/uofm/angsd/0.941/bin/misc/realSFS POPsfs.CHR.saf.idx -fold 0 -maxIter 100 -cores 8 > POP.CHR.sfs

rm POPsfs.CHR.saf.gz
rm POPsfs.CHR.saf.pos.gz
rm POPsfs.CHR.arg
rm POPsfs.CHR.saf.idx

#Batch script after creating pop by pop files; but do not launch b/c you need the slurm numbers downstream

#for pop in LARB Tensas AppMtns GL; do for chr in {2..37}; do sed "s/CHR/"${chr}"/g" ${pop}.sfs.sh > ${pop}.${chr}.sh; sbatch ${pop}.${chr}.sh; done; done

#get number of sites that passed quality filters for the blueprint file
#for chr in {2..37}; do sbatch LARB.${chr}.sh; done #slurm: for file in {1717498..1717533}; do grep filtering slurm-${file}.out >> LARB.numsites.out;done
#for chr in {2..37}; do sbatch Tensas.${chr}.sh; done #slurm: for file in {1717534..1717569}; do grep filtering slurm-${file}.out >> Tensas.numsites.out;done
#for chr in {2..37}; do sbatch AppMtns.${chr}.sh; done #slurm: for file in {1717809..1717844}; do grep filtering slurm-${file}.out >> AppMtns.numsites.out;done
#for chr in {2..37}; do sbatch GL.${chr}.sh; done #slurm: for file in {1717606..1717641}; do grep filtering slurm-${file}.out >> GL.numsites.out;done
#for chr in {2..37}; do sbatch NCc.${chr}.sh; done #slurm: for file in {1717675..1717710}; do grep filtering slurm-${file}.out >> NCc.numsites.out;done
#for chr in {2..37}; do sbatch MO.${chr}.sh; done #slurm: for file in {1717711..1717746}; do grep filtering slurm-${file}.out >> MO.numsites.out;done
#for chr in {2..37}; do sbatch CT.${chr}.sh; done #slurm: for file in {1717747..1717782}; do grep filtering slurm-${file}.out >> CT.numsites.out;done

#for chr in {2..37}; do sbatch UARB.${chr}.sh; done #slurm: for file in {1878120..1878155}; do grep filtering slurm-${file}.out >> UARB.numsites.out;done

#post processing
#for pop in UARB; do for chr in {2..37}; do cat ${pop}.${chr}.sfs >> ${pop}.temp.sfs; done;done
#pull everything into Excel, sum, and output new file


