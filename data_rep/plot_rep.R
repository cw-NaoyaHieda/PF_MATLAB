library(ggplot2)
library(tidyverse)


para <- read.csv('data_rep/parameter_mini.csv',header = F)
colnames(para) <- c("group","x","beta","q","rho","Q")

para['beta'] <- sig(para['beta'])
para['rho'] <- sig(para['rho'])
plot_d <- para %>% gather(variable,value,-group,-x)


ggplot(plot_d,aes(x=x,y=value,color=as.factor(group))) +
  geom_line() + facet_wrap(~variable, scales="free")


para <- read.csv('data_rep/parameter.csv',header = F)
colnames(para) <- c("group","x","beta","q","rho","Q")

para['beta'] <- sig(para['beta'])
para['rho'] <- sig(para['rho'])
plot_d <- para %>% gather(variable,value,-group,-x)


ggplot(plot_d,aes(x=x,y=value,color=as.factor(group))) +
  geom_line() + facet_wrap(~variable, scales="free")


para <- read.csv('data_rep/parameter_1002_1515_100_1000.csv',header = F)
colnames(para) <- c("group","x","beta","q","rho","Q")

para['beta'] <- sig(para['beta'])
para['rho'] <- sig(para['rho'])
plot_d <- para %>% gather(variable,value,-group,-x)

plot_d[plot_d$variable == 'Q' & plot_d$x==0,'value'] <- NA

plot_d[plot_d$group == 1 & plot_d$x==1,'value'] <- NA

ggplot(plot_d,aes(x=x,y=value,color=as.factor(group))) +
  geom_line() + facet_wrap(~variable, scales="free")

