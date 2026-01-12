setwd("D://Bears-EasternDemo/Analyses/rda") #EEP's laptop
library(ggplot2)
library(geosphere)
library(rworldmap)
library(maps)
library(RColorBrewer)
library(reshape2)
library(ggmap)
library(gridExtra)

d <- read.table("inverse.MEM.Aug28_2025.txt",header=T)
world <- map_data("world")
usa <- map_data("state")

m1<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM1),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM1; 13.0%")+
  xlab("")+ylab("")+
  theme_classic()
m2<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM2),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM2; 2.0%")+
  xlab("")+ylab("")+
  theme_classic()
m3<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM3),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM3; 3.9%")+
  xlab("")+ylab("")+
  theme_classic()
m4<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM4),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM4; 2.4%")+
  xlab("")+ylab("")+
  theme_classic()
m5<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM5),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM5; 2.1%")+
  xlab("")+ylab("")+
  theme_classic()
m6<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM6),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM6; 2.9%")+
  xlab("")+ylab("")+
  theme_classic()
m7<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM7),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM7; 1.1%")+
  xlab("")+ylab("")+
  theme_classic()
m8<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM8),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM8; 1.8%")+
  xlab("")+ylab("")+
  theme_classic()
m9<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM9),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM9; 1.0%")+
  xlab("")+ylab("")+
  theme_classic()
m10<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM10),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM10; 1.1%")+
  xlab("")+ylab("")+
  theme_classic()
m11<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM11),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM11; 1.2%")+
  xlab("")+ylab("")+
  theme_classic()
m12<- ggplot(d)+
  geom_polygon(data=world,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  geom_polygon(data=usa,aes(x=long,y=lat, group=group),fill="grey80",color="black")+
  coord_fixed(xlim=c(-100,-66),ylim=c(29,49))+
  geom_point(aes(x=Long,y=Lat,fill=MEM12),size=3,pch=21)+
  scale_fill_gradient2(low="mediumorchid",mid="white",high="navy")+
  ggtitle("MEM12; 1.2%")+
  xlab("")+ylab("")+
  theme_classic()

#This orders the figures by their greatest to least contribution
grid.arrange(m1,m3,m6,m4,m5,m2,m8,m12,m11,m10,m7,m9,nrow=4)
