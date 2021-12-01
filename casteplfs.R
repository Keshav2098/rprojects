#obtaining proportion of household caste wise using PLFS data
#download the fwf file from MOPSI website 
#then code along the following lines
library(data.table)
library(reshape)
library(Hmisc)
library(ggplot2)
#defining variables
st = 1
sc = 2
muslim = 2
others = 9
rural = 1
urban = 2
#defining matrix to contain the data
tab1<- data.frame(rural = c(1,2,3,4),
                  urban = c(1,2,3,4),
                  total = c(1,2,3,4), row.names = c("st", "sc", "others", "muslim"))
hhdata[,weight*hhd_size]-> hhdata$coef
#obtaining values sc st others
x=1
for (i in c(1,2,9)){
  for (j in c(rural, urban)){
    hhdata[(sector==j & social_group==i),
           sum(coef)]->numerator
    hhdata[(sector==j), sum(coef)]-> denominator
    numerator*100/denominator->tab1[x,j]
  }
x=x+1}
#obtaining values for muslims
for (i in c(rural, urban)){
  hhdata[(religion==muslim & sector==i) &
           (social_group!=sc & social_group!=st),
         sum(coef)]->numerator
  hhdata[(sector==i), sum(coef)]->denominator
  numerator*100/denominator->tab1[4,i]
}
#obtaining for total
x=1
for (i in c(1,2,9)){
  hhdata[social_group==i, sum(coef)]->numerator
  hhdata[,sum(coef)]->denominator
  numerator*100/denominator->tab1[x,3]
  x=x+1
}
hhdata[(religion==muslim)&(social_group!= sc & social_group!= st),
       sum(coef)]*100/hhdata[,sum(coef)]->tab1[4,3]
tab1
