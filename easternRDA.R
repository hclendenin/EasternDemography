#On HPC
module load R/4.3.2/gcc.13.2.0
module load proj/9.3.1
module load geos
module load gdal

#set the working directory on HPC
setwd("/project/puckett3/lc.uamer/eastern/rda/")
#setwd("D://Bears-EasternDemo/Analyses/rda")

library(psych)    
library(vegan)
library(adegenet)
library(dplyr)
library(fmsb)
#library(gsl)
library(ggplot2)


#https://github.com/laurabenestan/RDA_outlier
#https://kjschmidlab.gitlab.io/b1k-gbs/GenomicVarPartitioning.html
#https://popgen.nescent.org/2018-03-27_RDA_GEA.html
#read in the data
plink_eastern <- read.table("east.raw", header=TRUE, sep=" ", row.names=1)
dim(plink_eastern)

#need to know the size of the matrix being read in; I think the first group did some level of basic LD filtering
gen <- plink_eastern[,6:105364]

#load in the selected dbMEM following forward selection
sel.mem <- read.table("inverse.MEM.Aug28_2025.txt")

#Load in the environmental data
#https://www.climond.org/BioclimRegistry.aspx #definitions for the bioclim variables
#**you need to order the environmental variables to match the genetic data*
#**make sure to have added dbMEMs manually before starting**
env <- read.table("eastern.env.txt",sep="\t",header=T)
env$alt_ext_1 <- as.numeric(env$alt_ext_1)
env$bio12_1 <- as.numeric(env$bio12_1)
env$Humid <- as.numeric(env$Humid)
#env$NLCD <- as.factor(env$NLCD)
str(env)

#evaluate distribution of samples across landcover types
#table(env$NLCD)
#Value 11 21 22 23 41 42 43 52 81 82 90 95
#count 3  25 23 13 24 11  7  1  6 15 21  4
#Interpretation- mostly even; therefore can keep

#env matrix correlation initial round all variables
#matrix_cor <- cor(env[,9:64])
#write.table(matrix_cor,"env.correlations.out",sep="\t")

#second round; reproduce from above only to help w/ visulization b/c the numbers do not change
#July 21, 2025- now w/ dbMEMs
#pairs.panels(env[,c(9,10,13,16,17,24,27,30,32,33,35,37,39,40,42:44,48:50,52:64)], scale=T)
#matrix_cor2 <- cor(env[,c(10,17,24,27,40,50,52:54,56:64)])
#write.table(matrix_cor2,"env.dbMEM.correlations.out",sep="\t")

#okay so these are the correlations, but this rather ignores bear biology.  What do we think eastern black bears are adapted to?
#tempcoldestquart (for hibernation) = bio11
#tempwarmestquart (for southern most heat) = bio10
#keep altitude

#select non-correlated variables
#https://www.nature.com/articles/s41597-020-00726-5 explanation of bio20-40
env_selected <- select(env, bio01_1,bio08_1,bio15_1,bio18_1,bio30_1,bio31_1,bio34_1,alt_ext_1,Humid) 
colnames(env_selected) <- c("AnnualTemp","TempWetQuart","CoVPrecip","PrecipWarmQuart","MeanDriest","MoistureSeasonality","PotEvapotrans","Altitude","Humid")

#run RDA
#rda.snp.sp <- rda(as.matrix(gen) ~ as.matrix(sel.mem)) #this does correlation
#scale=T normalizes the data; may be problematic w/ NLCD (should test before sending out as a script)
east.rda <- rda(as.formula(paste("gen ~ ",paste(colnames(env_selected), collapse = " + "), sep = "")), data = env_selected, scale=T)
#this does variance partitioning
saveRDS(east.rda,"eastRDA_Aug28_2025.rda.rds")

#Results
> east.rda
Call: rda(formula = gen ~ AnnualTemp + TempWetQuart + CoVPrecip +
            PrecipWarmQuart + MeanDriest + MoistureSeasonality + PotEvapotrans +
            Altitude + Humid, data = env_selected, scale = T)

Inertia Proportion Rank
Total         1.054e+05  1.000e+00
Constrained   2.830e+04  2.686e-01    9
Unconstrained 7.706e+04  7.314e-01  138

Inertia is correlations

Eigenvalues for constrained axes:
  RDA1  RDA2  RDA3  RDA4  RDA5  RDA6  RDA7  RDA8  RDA9
13264  3762  2721  2393  1796  1412  1290   949   709

#Proportion of RDA out of total
RDA1 = 46.9%
RDA2 = 13.3%
RDA3 = 9.6%

Eigenvalues for unconstrained axes:
  PC1    PC2    PC3    PC4    PC5    PC6    PC7    PC8
1887.6 1659.0 1441.1 1344.1 1145.7 1012.5 1000.7  953.6
(Showing 8 of 138 unconstrained eigenvalues)


> RsquareAdj(east.rda)
$r.squared
[1] 0.2685767

$adj.r.squared
[1] 0.2208751


#permutation test
east.rda.anova <- anova(east.rda, permutations = 1000)
saveRDS(east.rda.anova,"east.rda.anova_Aug28_2025.rds")

#Results
> east.rda.anova
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ AnnualTemp + TempWetQuart + CoVPrecip + PrecipWarmQuart + MeanDriest + MoistureSeasonality + PotEvapotrans + Altitude + Humid, data = env_selected, scale = T)
Df Variance      F   Pr(>F)
Model      9    28296 5.6304 0.000999 ***
  Residual 138    77061
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

#Individual effect of each env variable
env.scale <- as.data.frame(scale(env_selected)) #scale the data
#remember you can't write it like this if nlcd is in the dataset
env.anova <- lapply(1:ncol(env.scale),function(x){anova(rda(gen ~ env.scale[,x]), permutations = 1000)} )
names(env.anova) <- colnames(env.scale)

# sort the ANOVA result
envstat <- cbind(sapply(env.anova, function(x){x$F[1]}),
                 sapply(env.anova, function(x){x$Variance[1]}),
                 sapply(env.anova, function(x){x$Variance[1]/sum(x$Variance)})*100,
                 sapply(env.anova, function(x){x$`Pr(>F)`[1]}))
rownames(envstat) <- colnames(env.scale)
colnames(envstat) <- c("F","Var","PerceVar", "pvalue")
rda.snp.env.anova.ind <- envstat[order(envstat[,1],decreasing = T),]
saveRDS(rda.snp.env.anova.ind,"east.rda.env.anova.ind_Aug28_2025.rds")

#Results of the anova
> rda.snp.env.anova.ind
                            F      Var  PerceVar      pvalue
MoistureSeasonality 19.176651 4857.974 11.609783 0.000999001
AnnualTemp          14.351092 3744.934  8.949794 0.000999001
Humid               11.061163 2946.884  7.042583 0.000999001
PotEvapotrans        9.171427 2473.183  5.910513 0.000999001
Altitude             8.998227 2429.189  5.805374 0.000999001
TempWetQuart         8.952259 2417.496  5.777431 0.000999001
MeanDriest           8.671609 2345.958  5.606464 0.000999001
PrecipWarmQuart      6.115987 1682.375  4.020608 0.000999001
CoVPrecip            3.602685 1007.669  2.408169 0.000999001


#partial rda (w/ spatial scale accounted for)
#dbMEM3 was correlated w/ environmental variables kept w/in the analysis and removed
east.partial.env <- rda(gen ~ as.matrix(env.scale) + Condition(as.matrix(sel.mem[c(1:2,4:12)])), scale = F)
saveRDS(east.partial.env,"east.rda.partial_Aug28_25.rds")

#read in results
d <- readRDS("east.rda.partial_July23_25.rds")

#Results
> east.partial.env
Call: rda(formula = gen ~ as.matrix(env.scale) +
            Condition(as.matrix(sel.mem[c(1:2, 4:12)])), scale = F)

Inertia Proportion Rank
Total         4.184e+04  1.000e+00
Conditional   1.260e+04  3.012e-01   11   #Interp: 30% of variation explained by landscape config
Constrained   3.613e+03  8.634e-02    9   #Interp: 8.6% of variation explained by the environmental variables
Unconstrained 2.563e+04  6.125e-01  127

Inertia is variance

Eigenvalues for constrained axes:
  RDA1   RDA2   RDA3   RDA4   RDA5   RDA6   RDA7   RDA8   RDA9
1607.5  355.8  296.4  262.3  249.3  225.9  218.5  205.2  191.8

#Results for proportion of variance by RDA 1-3
RDA1 = 44.5%
RDA2 = 9.8%
RDA3 = 8.2%
RDA4 = 7.3%
RDA5 = 6.9%
RDA6 = 6.2%
RDA7 = 6.0%
RDA8 = 5.7%
RDA9 = 5.3%

Eigenvalues for unconstrained axes:
  PC1   PC2   PC3   PC4   PC5   PC6   PC7   PC8
585.8 403.0 356.8 352.9 344.1 339.2 318.5 306.7
(Showing 8 of 127 unconstrained eigenvalues)



RsquareAdj(east.partial.env)
$r.squared
[1] 0.08633732

$adj.r.squared
[1] 0.04640604


***pick back up here for Aug 28, 2025 runs***

#Individual effect of each env variable within the rda accountnig for spatial scale
env.anova <- lapply(1:ncol(env.scale),function(x){anova(rda(gen ~ env.scale[,x] + Condition(as.matrix(sel.mem[c(1:2,4:12)]))), permutations = 1000)} )
names(env.anova) <- colnames(env.scale)
saveRDS(env.anova,"env.sp.anova.rds")

#Results
> env.anova
$AnnualTemp
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F   Pr(>F)
Model      1   1597.3 7.8006 0.000999 ***
  Residual 135  27643.7
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$TempWetQuart
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F   Pr(>F)
Model      1    652.6 3.0818 0.000999 ***
  Residual 135  28588.4
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$CoVPrecip
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F   Pr(>F)
Model      1   1564.8 7.6329 0.000999 ***
  Residual 135  27676.2
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$PrecipWarmQuart
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F   Pr(>F)
Model      1   1358.9 6.5796 0.000999 ***
  Residual 135  27882.1
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$MeanDriest
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F   Pr(>F)
Model      1    795.3 3.7744 0.000999 ***
  Residual 135  28445.7
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$MoistureSeasonality
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F   Pr(>F)
Model      1    956.4 4.5648 0.000999 ***
  Residual 135  28284.6
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$PotEvapotrans
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance     F   Pr(>F)
Model      1     1009 4.825 0.000999 ***
  Residual 135    28232
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$Altitude
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F  Pr(>F)
Model      1    262.4 1.2225 0.02597 *
  Residual 135  28978.6
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

$Humid
Permutation test for rda under reduced model
Permutation: free
Number of permutations: 1000

Model: rda(formula = gen ~ env.scale[, x] + Condition(as.matrix(sel.mem[c(1:2, 4:12)])))
Df Variance      F   Pr(>F)
Model      1    953.9 4.5527 0.000999 ***
  Residual 135  28287.1
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


tol.var <- sum(env.anova[[1]]$Variance)
envstat <- cbind(sapply(env.anova, function(x){x$F[1]}),
                 sapply(env.anova, function(x){x$Variance[1]}), 
                 sapply(env.anova, function(x){x$Variance[1]/tol.var})*100,
                 sapply(env.anova, function(x){x$`Pr(>F)`[1]}))
rownames(envstat) <- colnames(env_selected)
colnames(envstat) <- c("F","Var","PerceVar", "pvalue")
rda.snp.env.alsQ.anova.ind <- envstat[order(envstat[,1],decreasing = T),]

saveRDS(rda.snp.env.alsQ.anova.ind,"east.rda.partial.anova.ind.rds")

#results
> rda.snp.env.alsQ.anova.ind
                          F       Var  PerceVar      pvalue
AnnualTemp          7.800599 1597.3145 5.4625813 0.000999001
CoVPrecip           7.632902 1564.8132 5.3514318 0.000999001
PrecipWarmQuart     6.579635 1358.9188 4.6473029 0.000999001
PotEvapotrans       4.825048 1009.0419 3.4507754 0.000999001
MoistureSeasonality 4.564784  956.3942 3.2707279 0.000999001
Humid               4.552721  953.9492 3.2623664 0.000999001
MeanDriest          3.774419  795.3041 2.7198234 0.000999001
TempWetQuart        3.081801  652.6204 2.2318662 0.000999001
Altitude            1.222486  262.4144 0.8974187 0.025974026

#Interp: Within the spatially constrained RDA, Annual Temp explains 5.5% of the variation within the genomic data
