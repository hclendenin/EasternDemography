setwd("D://Bears-EasternDemo/Analyses/stairway/")
library(ggplot2)
library(gridExtra)

fl <- read.table("Florida.final.summary",header=T)
larb <- read.table("LARB.final.summary",header=T)
ncc <- read.table("NCcoast.final.summary",header=T)
ct <- read.table("CT.final.summary",header=T)
mo <- read.table("Missouri.final.summary",header=T)
app <- read.table("AppMtns.final.summary",header=T)
ten <-  read.table("Tensas.final.summary",header=T)
gl <-  read.table("GL.final.summary",header=T)
uarb <- read.table("UARB.final.summary",header=T)

#For MIS shading
s.col <- data.frame(read.table("D://Bears-DEMO/Analyses.2022/msmc_Aug2022/shading.txt",header=T))
frenchLA <- data.frame(x=c(258,338),y=c(0,0))
missRIV <- data.frame(x=c(4200,4500),y=c(0,0))

#Figure 2B
sfs.p <- ggplot()+
  geom_rect(data=s.col, aes(xmin = min,xmax = max, ymin = 0, ymax = Inf), fill = s.col$col2, alpha = 0.3) +
  #geom_rect(data=frenchLA,aes(xmin=x[1],xmax=x[2],ymin=0,ymax=Inf), fill = "gold", alpha = 0.1)+
  #geom_rect(data=missRIV,aes(xmin=x[1],xmax=x[2],ymin=0,ymax=Inf), fill = "skyblue", alpha = 0.3)+ #Timing of shifts in Stages 1&2 of Mississippi River that collapsed Poverty Point Culture
  #App Mtns
  geom_line(aes(x=app$year,y=app$Ne_median),col="royalblue",lwd=2)+
  geom_line(aes(x=app$year,y=app$Ne_2.5.),col="royalblue")+
  geom_line(aes(x=app$year,y=app$Ne_97.5.),col="royalblue")+
  #Great Lakes
  geom_line(aes(x=gl$year,y=gl$Ne_median),col="skyblue",lwd=2)+
  geom_line(aes(x=gl$year,y=gl$Ne_2.5.),col="skyblue")+
  geom_line(aes(x=gl$year,y=gl$Ne_97.5.),col="skyblue")+
  #LARB / Coastal
  geom_line(aes(x=larb$year,y=larb$Ne_median),col="grey70",lwd=2)+
  geom_line(aes(x=larb$year,y=larb$Ne_2.5.),col="grey70")+
  geom_line(aes(x=larb$year,y=larb$Ne_97.5.),col="grey70")+
  #geom_ribbon(aes(x = c(min(larb$year),max(larb$year)),ymin = larb$Ne_2.5., ymax = larb$Ne_97.5.), fill = "blue", alpha = 0.5) +
  #Tensas
  geom_line(aes(x=ten$year,y=ten$Ne_median),col="navy",lwd=2)+
  geom_line(aes(x=ten$year,y=ten$Ne_2.5.),col="navy")+
  geom_line(aes(x=ten$year,y=ten$Ne_97.5.),col="navy")+
  #UARB
  geom_line(aes(x=uarb$year,y=uarb$Ne_median),col="grey30",lwd=2)+
  geom_line(aes(x=uarb$year,y=uarb$Ne_2.5.),col="grey30")+
  geom_line(aes(x=uarb$year,y=uarb$Ne_97.5.),col="grey30")+
  xlab("Time (years ago)")+ylab("Ne")+
  #geom_vline(xintercept=0.3,color="grey60")+ #potential expansion into Faroes
  #geom_vline(xintercept=30,color="grey60")+ #expansion into SEA
  scale_x_log10(limits=c(1e2,1e6))+
  #scale_x_log10()+
  annotation_logticks(sides="bl")+
  scale_y_continuous(trans="log10")+
  #geom_vline(xintercept = 528,col="black")+ #Spanish find NAm (1492)
  #geom_vline(xintercept = c(300,330,360,650,2600,5000),col="magenta")+ #360 years ago = 1660 (coinsides w/ French colonists); 650yr = 1370 AD; 2.6kya = 580BC
  #geom_vline(xintercept = c(413),col="red")+ #British colonists to N.Am
  #geom_vline(xintercept = c(138000,175000,195000),col="black")+ #Estimated eastern-western split time
  theme_classic()

#Three panel plot w/ data from MSMC-IM
plot_grid(M.plot,sfs.p,nrow=2,align='v')
#plot_grid(sfs.p,M.plot,amer.indiv,nrow=3,align='v')

#Figure 2 manuscript (must preload BearMSMC_IM.R)


#Supplemental
ggplot()+
  #geom_rect(data=s.col, aes(xmin = min,xmax = max, ymin = 0, ymax = Inf), fill = s.col$col2, alpha = 0.3) +
  #geom_rect(data=frenchLA,aes(xmin=x[1],xmax=x[2],ymin=0,ymax=Inf), fill = "blue", alpha = 0.1)+
  #Florida
  geom_line(aes(x=fl$year,y=fl$Ne_median),col="olivedrab4",lwd=1)+
  geom_line(aes(x=fl$year,y=fl$Ne_2.5.),col="olivedrab4",linetype = "dotted")+
  geom_line(aes(x=fl$year,y=fl$Ne_97.5.),col="olivedrab4",linetype = "dotted")+
  #Conn
  geom_line(aes(x=ct$year,y=ct$Ne_median),col="purple4",lwd=1)+
  geom_line(aes(x=ct$year,y=ct$Ne_2.5.),col="purple4",linetype = "dotted")+
  geom_line(aes(x=ct$year,y=ct$Ne_97.5.),col="purple4",linetype = "dotted")+
  #Missouri
  geom_line(aes(x=mo$year,y=mo$Ne_median),col="gold3",lwd=1)+
  geom_line(aes(x=mo$year,y=mo$Ne_2.5.),col="gold3",linetype = "dotted")+
  geom_line(aes(x=mo$year,y=mo$Ne_97.5.),col="gold3",linetype = "dotted")+
  #NC coast
  geom_line(aes(x=ncc$year,y=ncc$Ne_median),col="royalblue",lwd=1)+
  geom_line(aes(x=ncc$year,y=ncc$Ne_2.5.),col="royalblue",linetype = "dotted")+
  geom_line(aes(x=ncc$year,y=ncc$Ne_97.5.),col="royalblue",linetype = "dotted")+
  #App Mtns
  geom_line(aes(x=app$year,y=app$Ne_median),col="dodgerblue",lwd=1)+
  geom_line(aes(x=app$year,y=app$Ne_2.5.),col="dodgerblue",linetype = "dotted")+
  geom_line(aes(x=app$year,y=app$Ne_97.5.),col="dodgerblue",linetype = "dotted")+
  #LARB
  geom_line(aes(x=larb$year,y=larb$Ne_median),col="grey70",lwd=1)+
  geom_line(aes(x=larb$year,y=larb$Ne_2.5.),col="grey70",linetype = "dotted")+
  geom_line(aes(x=larb$year,y=larb$Ne_97.5.),col="grey70",linetype = "dotted")+
  #Tensas
  geom_line(aes(x=ten$year,y=ten$Ne_median),col="navy",lwd=1)+
  geom_line(aes(x=ten$year,y=ten$Ne_2.5.),col="navy",linetype = "dotted")+
  geom_line(aes(x=ten$year,y=ten$Ne_97.5.),col="navy",linetype = "dotted")+
  #UARB
  geom_line(aes(x=uarb$year,y=uarb$Ne_median),col="grey30",lwd=2)+
  geom_line(aes(x=uarb$year,y=uarb$Ne_2.5.),col="grey30")+
  geom_line(aes(x=uarb$year,y=uarb$Ne_97.5.),col="grey30")+
  #Great Lakes
  geom_line(aes(x=gl$year,y=gl$Ne_median),col="skyblue",lwd=1)+
  geom_line(aes(x=gl$year,y=gl$Ne_2.5.),col="skyblue",linetype = "dotted")+
  geom_line(aes(x=gl$year,y=gl$Ne_97.5.),col="skyblue",linetype = "dotted")+
  xlab("Time (years ago)")+ylab("Ne")+
  #geom_vline(xintercept=c(2600,360),color="grey60")+ #expansion into SEA
  #geom_hline(yintercept = c(20000,40000,60000))+
  scale_x_log10(limits=c(1e1,1e6))+
  scale_y_continuous(trans="log10")+ annotation_logticks(sides="bl")+
  theme_classic()
  
