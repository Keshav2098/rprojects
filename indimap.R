## here I have plotted the India heat maps for obesity bmi and life expectancy 
## since no ready-made package is avaialbe to plot india maps I have used the shape files. 
library("rgdal")
library(rgeos)
library(ggplot2)
library(tidyverse)
library(magrittr)
library(tidytable)
library(data.table)
library(reshape)
library(stringr)
library(viridis)
unzip("India_State_Shapefile.zip", overwrite = T)
india <- readOGR("India_State_Boundary.shp")
#plot(india)
india@data$ID<-as.numeric(rownames(india@data))



indiadata <- read_excel("indiadata.xlsx")
indiadata %>% 
  as_tidytable %>% 
  select.(state, year, female, obese) %>% 
  set_colnames(c("id", "year", "female", "Obese")) %>% 
  mutate.(year.f = paste(year,female, sep = ".")) %>% 
  select.(id, year.f, Obese) %>% 
  dcast(id~year.f)->indiaD

merge(india@data, indiaD, by.x = "Name", by.y = "id", all.x = T)->india@data
india@data<-india@data[order(india@data$ID),]

indiaF<-fortify(india, region = "Name")
indiaF<-merge(indiaF, india, by.x = "id", by.y = "Name")

### names of state chhatisgarh and telengana are different J and K is not coming
as.data.table(indiaF)->indiaF
melt(indiaF, id.vars = c("id", "long", "lat", "order", "hole", "piece", "group",
                         "Type", "ID"))->indiaF2 

indiaF2 %>% 
  mutate.(variable=as.character(variable)) %>% 
  separate.(variable, c("year", "female"), sep = ".") %>% 
  mutate.(sex = ifelse(female == "1", "Female", "Male")) %>% 
  rename.(Obese = value)->indiaF2
  
  


ggplot()+
  geom_polygon(data=indiaF2, aes(x = long, y= lat,
                                group = group, fill = BMI))+
  coord_equal()+facet_grid(year~sex)+scale_fill_gradientn(limits = c(18.5, 26),
                                                          colors = c("white", "red"))+
  theme_minimal()+theme(axis.text = element_blank(), axis.ticks = element_blank(),
                        panel.grid = element_blank(), axis.title = element_blank())->p
                        
ggplot()+
  geom_polygon(data=indiaF2, aes(x = long, y= lat,
                                 group = group, fill = ALE))+
  coord_equal()+facet_grid(year~sex)+scale_fill_gradient(low = "red", high = "white")+
  theme_minimal()+theme(axis.text = element_blank(), axis.ticks = element_blank(),
                        panel.grid = element_blank(), axis.title = element_blank())->p

ggplot()+
  geom_polygon(data=indiaF2, aes(x = long, y= lat,
                                 group = group, fill = Obese))+
  coord_equal()+facet_grid(year~sex)+scale_fill_gradientn(limits = c(0,14.3),
                                                          colors = c("white","red"))+
  theme_minimal()+theme(axis.text = element_blank(), axis.ticks = element_blank(),
                        panel.grid = element_blank(), axis.title = element_blank())->p
p
ggsave(filename = "indObese.png", height = 20, width = 15, units = "cm")
