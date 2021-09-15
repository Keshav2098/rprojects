readRDS("/home3/ep624/plfsdata/hhfv201920.rds")-> hhdata
readRDS("/home3/ep624/plfsdata/perfv201920.rds")-> perdata
library(data.table)
library(reshape)
library(Hmisc)
library(ggplot2)
st = 1
sc = 2
muslim = 2
others = 9
rural = 1
urban = 2
hhdata[,sum(weight),by = .(sector, social_group)]->num1
hhdata[!(social_group %in% c(sc,st))&religion==muslim, sum(weight), by = .(sector)]->num2
hhdata[,sum(weight), by = .(sector)]->den
merge(num1, den, by = "sector")->t1
t1$value<- t1$V1.x*100/t1$V1.y
t1<- t1[order(t1),]
q1<-matrix(t1$value, nrow=4, ncol = 2)
q1[3,]<- num2$V1*100/den$V1
as.data.frame(q1, row.names = c("st", "sc", "muslim", "other"))->q1
colnames(q1)<-c("rural", "urban")
q1
