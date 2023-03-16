library(usmap)
library(ggplot2)
library(magrittr)
library(reshape)
library(tidyverse)
library(data.table)
library(tidytable)
usadata <- read_excel("usstate6.xlsx")
usadata %>% 
  as_tidytable %>% 
  select.(year, female, state_name, obese) %>% 
  filter.(year %in% c(2005, 2015, 2018)) %>% 
  rename.(state = state_name) %>% 
  rename.(Obese = obese) %>% 
  mutate.(female = ifelse(female==1, "Female", "Male"))->usadata

plot_usmap(data = usadata, values = "Obese")+
  scale_fill_gradientn(limits = c(15, 45), colors = c("white", "red"))+
  facet_grid(year~female)+theme_minimal()+
  theme(axis.text = element_blank(), axis.ticks = element_blank(),
        panel.grid = element_blank(), axis.title = element_blank())->p
p
ggsave("usObese.png", height = 20, width = 15, units = "cm")
