#plotting career publication graphs from scrapped data
library(data.table)
library(reshape)
library(haven)
library(ggplot2)
library(openxlsx)
read_dta(careeranalysis.dta)->cdata
as.data.table(cdata)->cdata
as.factor(cdata$gs_name)->cdata$gs_name
split.data.frame(cdata, cdata$gs_name)->author
for (j in c(1:length(author))){
  for (i in c(1:length(author[[j]]$year))){
    author[[j]]$year[i]-author[[j]]$year[1]->author[[j]]$careeryear[i]
  }
}
unsplit(author, cdata$gs_name)->cdata1
cdata1[,c(1,2,3,4,11,19)]->cdata2
as.data.table(cdata2)->cdata2
cdata2[,sum(publications),by=.(careeryear, gender)]->publication
cdata2[,.N,by=.(careeryear, gender)]->numberofauthors
publication<-publication[order(publication$careeryear, publication$gender)]->publication
numberofauthors<-numberofauthors[order(numberofauthors$careeryear, numberofauthors$gender)]->numberofauthors
cdata[gender=="F", gs_name]
colnames(publication)[3]<- "publications"
merge(publication, numberofauthors, by = c("careeryear", "gender"))->avgpub
avgpub$ratio<-avgpub$publications/avgpub$N
split.data.frame(avgpub, avgpub$gender)->avgpublist
avgpublist[[1]]$cumulativeratio<-cumsum(avgpublist[[1]]$ratio)
avgpublist[[2]]$cumulativeratio<-cumsum(avgpublist[[2]]$ratio)
unsplit(avgpublist, avgpub$gender)->avgpub1
##########################################
ggplot(avgpub1, aes(careeryear, cumulativeratio, group=gender, color=gender))->p
p+geom_line(size=1)->p
p
ggsave(p, filename = "cumulativeavg.png")
#################################################
ggplot(avgpub1, aes(careeryear, ratio, group=gender, color=gender))->p
p+geom_line(size=1.2)->p
p
ggsave(p, filename = "avgpublication.png")
##################################################
createWorkbook()->wb
addWorksheet(wb, "data")
writeData(wb, 1, avgpub1)
saveWorkbook(wb, "publication.xlsx")
