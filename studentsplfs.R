#obtaining proportion of students in plfs data
#plotting the same 
library(data.table)
library(ggplot2)
as.numeric(perdata$age)->perdata$age
male = 1
female = 2
urban = 2
rural = 1
student<- c(22:43)
names<-list(c("06to16", "17to20", "21to24"), c("RM", "RF","UM", "UF"))
ifelse(perdata$age%in%c(6:16), "06to16",
       ifelse(perdata$age%in%c(17:20),"17to20",
       ifelse(perdata$age%in%c(21:24), "21to24", "older")))->perdata$age1
perdata[attendance%in%student&sex!=3&age1!="older", sum(weight), by = .(sector, sex, age1)]->num
num[order(num),]->num
perdata[sex!=3&age1!="older", sum(weight), by = .(sector, sex, age1)]->den
den[order(den),]->den
merge(num, den, by = c("sector", "sex", "age1"))->t3
t3$value<-t3$V1.x*100/t3$V1.y
q3<-as.data.frame(matrix(t3$value, nrow = 3, ncol = 4, dimnames = names))
q3
#plotting the results
q3[,5]<- row.names(q3)
melt(q3)->q5
colnames(q5)<- c("age", "sector.sex", "%student")
ggplot(data=q5, mapping = aes(x=age, y= `%student`, fill=sector.sex))->p
p+geom_col(position = "dodge")->p
p+geom_text(aes(label=round(`%student`,1)),position = position_dodge(0.9), vjust = -0.25, size = 3)->p
p+ggtitle("proportion of student in population(age,region,sex)")->p
p
