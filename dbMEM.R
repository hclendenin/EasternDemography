#setwd("D://Bears-EasternDemo/Analyses/rda") #EEP's laptop
setwd("/project/puckett3/lc.uamer/eastern/rda/") #BigBlue
library(Riemann)
library(vegan)
library(ggplot2)
library(adespatial)
library(spdep)

#script to create eigenvalues that decompose spatial structure
#read in data table w/ long and lat
#env <- read.table("eastern.env.txt",sep="\t",header=T)

#using adespatial
#https://www.rdocumentation.org/packages/adespatial/versions/0.3-28/topics/dbmem
#https://kjschmidlab.gitlab.io/b1k-gbs/GenomicVarPartitioning.html


#very simple approach to generating dbMEM **DID NOT USE THIS; SEE BELOW**
#The documentation notes that dbMEM is the new PCNM; therefore, this is the whole step
#minus whatever decisions need to be made about thresholds and/or the MEM.autocor parameter
#d.mem <- dbmem(env[,5:6])

#d.out <- cbind(env$sample,d.mem$MEM1,d.mem$MEM2,d.mem$MEM3,d.mem$MEM4,d.mem$MEM5,d.mem$MEM6,d.mem$MEM7,d.mem$MEM8,d.mem$MEM9,d.mem$MEM10,d.mem$MEM11,d.mem$MEM12)
#write.table(d.out,"eastern.dbMEM.Aug28_2025.out",sep="\t",row.names = FALSE,col.names=TRUE)


#more complex approach to generating significant dbMEM
#load genetic data
plink_eastern <- read.table("east.raw", header=TRUE, sep=" ", row.names=1)
#dim(plink_eastern)

#need to know the size of the matrix being read in; I think the first group did some level of basic LD filtering
gen <- plink_eastern[,6:105364]


#mean locations of sampling points
grp.coord <- cbind(tapply(env$long, INDEX = env$pop, mean), 
                   tapply(env$lat, INDEX = env$pop, mean))

## 1. generate MEMs
## 1.1 make neighborhood network
#nb      <- graph2nb(gabrielneigh(grp.coord, nnmult = 100), sym=TRUE)

## 1.2 produce spatial weights matrix
#listW   <- nb2listw(nb,style="W")  

## 1.3 Calculate the distances between neighbours -> 'longlat = TRUE' for longitude-latitude decimal degrees data
#disttri <- nbdists(nb,grp.coord, longlat = TRUE)  

## 1.4 Use inverse distance as weights
#fdist   <- lapply(disttri,function(x) x^(-1))

## 1.5 Revised spatial weights matrix
#listW   <- nb2listw(nb,glist=fdist,style="W")  

## 1.6 Eigen analysis of W 
#MEM <- scores.listw(listW, MEM.autocor = "all")         
#rownames(MEM) <- rownames(grp.coord)

## 1.7 Match MEMs of demes to samples
mem.full <- as.data.frame(apply(MEM, 2, function(x){x[match(env$pop,rownames(MEM))]}))
rownames(mem.full) <- env$sample
write.table(mem.full,"inverse.MEM.Aug28_2025.txt")

## 2. Forward selection after already making the dbMEMs w/ the simple function instead of the inverse distance matrix above
#forward selection when I use demes (p=13) instead of individuals
fwsel.mem <- forward.sel(Y = gen, X = as.matrix(mem.full)) # significant if p-value < 0.05
write.table(fwsel.mem,"forwardselection.dbMEM_July23_2025.txt")

#fwsel.mem
#Results of forward selection


#cumulatively these 12 dbMEMs explain 34% of the variance in the genetic data
#Is that the correct interpretation of the R2Cumulative column?

sel.mem <- read.table("inverse.MEM.Aug28_2025.txt",header=T)

#Contribution of spatial autocorrelation in the rda
#fit an RDA
rda.snp.sp <- rda(gen ~ as.matrix(sel.mem))
saveRDS(rda.snp.sp,"dbMEM.rda_Aug28_2025.rds")

> rda.snp.sp

Call: rda(formula = gen ~ as.matrix(sel.mem))

Inertia Proportion Rank
Total         4.184e+04  1.000e+00
Constrained   1.421e+04  3.397e-01   12
Unconstrained 2.763e+04  6.603e-01  135

Inertia is variance

Eigenvalues for constrained axes:
  RDA1  RDA2  RDA3  RDA4  RDA5  RDA6  RDA7  RDA8  RDA9 RDA10 RDA11 RDA12
6537  1678  1156   995   881   678   588   503   356   338   316   189

Eigenvalues for unconstrained axes:
  PC1   PC2   PC3   PC4   PC5   PC6   PC7   PC8
602.0 491.2 382.7 367.5 360.6 356.5 339.3 338.1
(Showing 8 of 135 unconstrained eigenvalues)

RsquareAdj(rda.snp.sp)
$r.squared
[1] 0.3397123

$adj.r.squared
[1] 0.2810201

#permutation test
rda.snp.sp.anova <- anova(rda.snp.sp, permutations = 1000)
saveRDS(rda.snp.sp.anova,"dbMEM.rda.anova_Aug28_2025")

