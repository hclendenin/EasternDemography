#setwd("D://Bears-EasternDemo/Analyses/gone/beagleimputed/")
setwd("D://Bears-EasternDemo/Analyses/gone/glimpseimputed/")
library(ggplot2)
library(gridExtra)
library(cowplot)

#glimpse imputed and 50 runs
uarb <- read.table("Uarbcluster.gone.out",header=T)
larb <- read.table("Coastal.gone.out",header=T)
ten <- read.table("Tensas.gone.out",header=T)
app <- read.table("AppMtns.gone.out",header=T)
gl <- read.table("GL.gone.out",header=T)

#Create mean and CI columns
# Calculate the median (0.5 quantile) for each row
test <- as.data.frame(apply(uarb, 1, quantile, probs = c(0.025,0.5,0.975)))
test.t <- as.data.frame(t(test))
colnames(test.t) <- c("CI2","Median","CI9")
uarb2 <- cbind(uarb,test.t)

test <- as.data.frame(apply(larb, 1, quantile, probs = c(0.025,0.5,0.975)))
test.t <- as.data.frame(t(test))
colnames(test.t) <- c("CI2","Median","CI9")
larb2 <- cbind(larb,test.t)

test <- as.data.frame(apply(ten, 1, quantile, probs = c(0.025,0.5,0.975)))
test.t <- as.data.frame(t(test))
colnames(test.t) <- c("CI2","Median","CI9")
ten2 <- cbind(ten,test.t)

test <- as.data.frame(apply(app, 1, quantile, probs = c(0.025,0.5,0.975)))
test.t <- as.data.frame(t(test))
colnames(test.t) <- c("CI2","Median","CI9")
app2 <- cbind(app,test.t)

test <- as.data.frame(apply(gl, 1, quantile, probs = c(0.025,0.5,0.975)))
test.t <- as.data.frame(t(test))
colnames(test.t) <- c("CI2","Median","CI9")
gl2 <- cbind(gl,test.t)

rm(uarb,larb,ten,app,gl,test,test.t)

#Figure S5
east.p <- ggplot()+
  scale_x_continuous(sec.axis = ~ .*6.5)+
  geom_line(data=subset(app2, Generation < 100),aes(x=Generation,y=Median),col="royalblue",lwd=2)+
  geom_line(data=subset(app2, Generation < 100),aes(x=Generation,y=CI2),col="royalblue")+
  geom_line(data=subset(app2, Generation < 100),aes(x=Generation,y=CI9),col="royalblue")+
  geom_line(data=subset(gl2, Generation < 100),aes(x=Generation,y=Median),col="skyblue",lwd=2)+
  geom_line(data=subset(gl2, Generation < 100),aes(x=Generation,y=CI2),col="skyblue")+
  geom_line(data=subset(gl2, Generation < 100),aes(x=Generation,y=CI9),col="skyblue")+
  scale_y_continuous(trans="log10")+
  annotation_logticks(sides="l")+
  xlab("Generations Ago")+ ylab("Ne")+
  theme_classic()


la.p <- ggplot()+
  scale_x_continuous(sec.axis = ~ .*6.5)+
  geom_rect(mapping=aes(xmin=0.6,xmax=4.3, ymin=0, ymax=Inf),fill="mediumorchid2", alpha=0.6)+ #ESA listing
  geom_line(data=subset(ten2, Generation < 100),aes(x=Generation,y=Median),col="navy",lwd=2)+
  geom_line(data=subset(ten2, Generation < 100),aes(x=Generation,y=CI2),col="navy")+
  geom_line(data=subset(ten2, Generation < 100),aes(x=Generation,y=CI9),col="navy")+
  geom_line(data=subset(larb2, Generation < 100),aes(x=Generation,y=Median),col="grey70",lwd=2)+
  geom_line(data=subset(larb2, Generation < 100),aes(x=Generation,y=CI2),col="grey70")+
  geom_line(data=subset(larb2, Generation < 100),aes(x=Generation,y=CI9),col="grey70")+
  scale_y_continuous(trans="log10")+
  annotation_logticks(sides="l")+
  xlab("Generations Ago")+ ylab("Ne")+
  theme_classic()

uarb.p <- ggplot()+
  scale_x_continuous(sec.axis = ~ .*6.5)+
  geom_vline(xintercept = (2020-1965)/6.5,col="mediumorchid2")+
  geom_line(data=subset(uarb2, Generation < 100),aes(x=Generation,y=Median),col="grey30",lwd=2)+
  geom_line(data=subset(uarb2, Generation < 100),aes(x=Generation,y=CI2),col="grey30")+
  geom_line(data=subset(uarb2, Generation < 100),aes(x=Generation,y=CI9),col="grey30")+
  scale_y_continuous(trans="log10")+
  annotation_logticks(sides="l")+
  xlab("Generations Ago")+ ylab("Ne")+
  theme_classic()

plot_grid(la.p,east.p,uarb.p,nrow=3,align='v')






ggplot()+
  scale_x_continuous(sec.axis = ~ .*6.5)+
  geom_line(data=app2,aes(x=Generation,y=Median),col="royalblue",lwd=2)+
  geom_line(data=gl2,aes(x=Generation,y=Median),col="skyblue",lwd=2)+
  geom_line(data=ten2,aes(x=Generation,y=Median),col="navy",lwd=2)+
  geom_line(data=larb2,aes(x=Generation,y=Median),col="grey70",lwd=2)+
  scale_y_continuous(trans="log10")+
  annotation_logticks(sides="l")+
  xlab("Generations Ago")+ ylab("Ne")+
  theme_classic()
