#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=iHS.eastern
#SBATCH --mem=4Gb
#SBATCH --mail-type=ALL
#SBATCH --partition=acomputeq
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load vcftools
module load selscan/2.0.2

cd /project/puckett3/lc.uamer/eastern/iHS

#for chr in {2..37}; do sed "s/CHR/"${chr}"/g" ihs_ihh12.eastern.sh > ihs.${chr}.sh; sbatch ihs.${chr}.sh; done

#iHS
for pop in Tensas LARB GL AppMtns; do selscan --ihs --vcf /project/puckett3/lc.uamer/eastern/beagle/${pop}.CHR.vcf.gz --map /project/puckett3/lc.uamer/eastern/beagle/eastern.CHR.map --out ${pop}.CHR.iHS.out;done 

#concatenate files
for pop in Tensas LARB GL AppMtns; do for chr in {2..37}; do cat ${pop}.${chr}.iHS.out.ihs.out >> ${pop}.iHS.out;done;done 
#head Tensas.iHS.out > test
#sed -i 's/_/\t/g' test
for pop in Tensas LARB GL AppMtns; do sed -i 's/_/\t/g' ${pop}.iHS.out;done

cd ../iHH12
#iHH12
for pop in Tensas LARB GL AppMtns; do selscan --ihh12 --vcf /project/puckett3/lc.uamer/eastern/beagle/${pop}.CHR.vcf.gz --map /project/puckett3/lc.uamer/eastern/beagle/eastern.CHR.map --out ${pop}.CHR.iHH12.out; done

#concatenate files
for pop in Tensas LARB GL AppMtns; do for chr in {2..37}; do tail -n +2 ${pop}.${chr}.iHH12.out.ihh12.out >> ${pop}.iHH12.out;done;done 
for pop in Tensas LARB GL AppMtns; do sed -i 's/_/\t/g' ${pop}.iHH12.out;done




#if you want to thin these datasets for plotting/data exploration:
for pop in Tensas LARB GL AppMtns; do awk 'NR % 2' ${pop}.iHS.out > temp.out; awk 'NR % 2' temp.out > ${pop}.quart.iHS.out; done 
#(would remove every other sample)

for pop in Tensas LARB GL AppMtns; do awk 'NR % 2' ${pop}.iHH12.out > temp.out; awk 'NR % 2' temp.out > ${pop}.quart.iHH12.out; done 