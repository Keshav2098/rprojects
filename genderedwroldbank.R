###this is an example of how a genered variable can be arranged in panel formation 
###the data is from world bank and any gendred variable from world bank website can be genereated along these lines
### copy the code and replace the name with desired variables names using ctrl+alt+shit+M 
lifeexpectancy_at_birth->alib
lifeexpectancy_at_birth_female->alibf
lifeexpectancy_at_birth_male->alibm
###########################################
variable<-"alibf"
as.data.table(alibf)->alibf
names2<- c("country", "country code", "year", variable)
colnames(alibf)[c(1,2)]<-names
melt(alibf, id.vars = names)->alibf
as.data.table(alibf)->alibf
colnames(alibf)<- names2
as.numeric(as.character(alibf$year))->alibf$year
alibf[year>= 2000,]->alibf
#####################################################
as.data.table(alibm)->alibm
colnames(alibm)[c(1,2)]<-names
variable<-"alibm"
names2<- c("country", "country code", "year", variable)
melt(alibm, id.vars = names)->alibm
as.data.table(alibm)->alibm
colnames(alibm)<- names2
as.numeric(as.character(alibm$year))->alibm$year
alibm[year>= 2000,]->alibm
####################################################
variable<-"alib"
as.data.table(alib)->alib
names2<- c("country", "country code", "year", variable)
colnames(alib)[c(1,2)]<-names
melt(alib, id.vars = names)->alib
as.data.table(alib)->alib
colnames(alib)<- names2
as.numeric(as.character(alib$year))->alib$year
alib[year>= 2000,]->alib
########################################################
merge(alibf, alibm, by = c("country code", "year","country"))->lifeexp
merge(lifeexp, alib, by = c("country code", "year","country"))->lifeexp
############################################################
melt(lifeexp, id.vars = c("country code", "year","country","alib"))->lifeexp
ifelse(lifeexp$variable=="alibf", 1, 0)->lifeexp$female
lifeexp[c(1,2,3,7,4,6)]->lifeexp
colnames(lifeexp)[c(5,6)]<-c("lifeexpectancy(total)", "lifeexpectancy")
