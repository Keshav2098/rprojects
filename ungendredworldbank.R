#### using this kind of code one can organized data from worlbank into panel data
#### download the relevant excel file from worldbnak website
#### import the excel file in R and use the following codes by replacing names of datasets with the appropriate name that you want
#### here the example of gini coefficient is provided
library(data.table)
library(rehsape)
ginicoefficient->gini
as.data.table(gini)->gini
variable<-"gini"
as.data.table(gini)->gini
names2<- c("country", "country code", "year", variable)
colnames(gini)[c(1,2)]<-names
melt(gini, id.vars = names)->gini
as.data.table(gini)->gini
colnames(gini)<- names2
as.numeric(as.character(gini$year))->gini$year
gini[year>= 2000,]->gini
