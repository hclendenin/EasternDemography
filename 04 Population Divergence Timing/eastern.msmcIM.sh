#!/bin/bash
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=msmcIM
#SBATCH --partition=computeq
#SBATCH --mail-type=END
#SBATCH --mail-user=Emily.Puckett@memphis.edu

module load vcftools/0.1.17
module load msmc2/2.1.1
module load msmc
module load python/3.6.7
module load beagle/5.1
module load htslib
cd ~/projects/beardemo/msmc/

#uamer
#	LA366	18	19	LARB
#	LA371	20	21	LARB
#	MI334	22	23	GL
#	MI335	24	25	GL
#	MS3783	26	27	Tensas
#	NC00417	28	29	SE
#	NC056	30	31	SE
#	WV17_01	38	39	SE

#single samples
msmc2 -I 18,19 -t 8 -o LA366.final.txt Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

msmc2 -I 22,23 -t 8 -o MI334.final.txt Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

msmc2 -I 26,27 -t 8 -o MS3783.final.txt Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

msmc2 -I 30,31 -t 8 -o NC056.final.txt Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

#LARB vs GL
msmc2 -I 18-22,19-22,18-23,19-23 -t 8 -o larb.gl Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

combineCrossCoal.py larb.gl.final.txt LA366.final.txt MI334.final.txt > cross.larb.gl.final.txt
MSMC_IM.py -mu 1e-8 -p 1*2+25*1+1*2+1*3 -o ./cross.larb.gl.final.txt cross.larb.gl.final.txt --printfittingdetails

#Tensas vs GL
msmc2 -I 26-22,27-22,26-23,27-23 -t 8 -o tensas.gl Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

combineCrossCoal.py tensas.gl.final.txt MS3783.final.txt MI334.final.txt > cross.tensas.gl.final.txt
MSMC_IM.py -mu 1e-8 -p 1*2+25*1+1*2+1*3 -o ./cross.tensas.gl.final.txt cross.tensas.gl.final.txt --printfittingdetails

#SE vs GL
msmc2 -I 30-22,31-22,30-23,31-23 -t 8 -o se.gl Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

combineCrossCoal.py se.gl.final.txt NC056.final.txt MI334.final.txt > cross.se.gl.final.txt
MSMC_IM.py -mu 1e-8 -p 1*2+25*1+1*2+1*3 -o ./cross.se.gl.final.txt cross.se.gl.final.txt --printfittingdetails

#LARB vs SE
msmc2 -I 18-30,19-30,18-31,19-31 -t 8 -o larb.se Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

combineCrossCoal.py larb.se.final.txt LA366.final.txt NC056.final.txt > cross.larb.se.final.txt
MSMC_IM.py -mu 1e-8 -p 1*2+25*1+1*2+1*3 -o ./cross.larb.se.final.txt cross.larb.se.final.txt --printfittingdetails

#Tensas vs SE
msmc2 -I 26-30,27-30,26-31,27-31 -t 8 -o tensas.se Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

combineCrossCoal.py tensas.se.final.txt MS3783.final.txt NC056.final.txt > cross.tensas.se.final.txt
MSMC_IM.py -mu 1e-8 -p 1*2+25*1+1*2+1*3 -o ./cross.tensas.se.final.txt cross.tensas.se.final.txt --printfittingdetails

#LARB vs Tensas
msmc2 -I 18-26,19-26,18-27,19-27 -t 8 -o larb.tensas Ursus.2.multihetsep.txt Ursus.3.multihetsep.txt Ursus.4.multihetsep.txt Ursus.5.multihetsep.txt Ursus.6.multihetsep.txt Ursus.7.multihetsep.txt Ursus.8.multihetsep.txt Ursus.9.multihetsep.txt Ursus.10.multihetsep.txt Ursus.11.multihetsep.txt Ursus.12.multihetsep.txt Ursus.13.multihetsep.txt Ursus.14.multihetsep.txt Ursus.15.multihetsep.txt Ursus.16.multihetsep.txt Ursus.17.multihetsep.txt Ursus.18.multihetsep.txt Ursus.19.multihetsep.txt Ursus.20.multihetsep.txt Ursus.21.multihetsep.txt Ursus.22.multihetsep.txt Ursus.23.multihetsep.txt Ursus.24.multihetsep.txt Ursus.25.multihetsep.txt Ursus.26.multihetsep.txt Ursus.27.multihetsep.txt Ursus.28.multihetsep.txt Ursus.29.multihetsep.txt Ursus.30.multihetsep.txt Ursus.31.multihetsep.txt Ursus.32.multihetsep.txt Ursus.33.multihetsep.txt Ursus.34.multihetsep.txt Ursus.35.multihetsep.txt Ursus.36.multihetsep.txt Ursus.37.multihetsep.txt

combineCrossCoal.py larb.tensas.final.txt LA366.final.txt MS3783.final.txt > cross.larb.tensas.final.txt
MSMC_IM.py -mu 1e-8 -p 1*2+25*1+1*2+1*3 -o ./cross.larb.tensas.final.txt cross.larb.tensas.final.txt --printfittingdetails

