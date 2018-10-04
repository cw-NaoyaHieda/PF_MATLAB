library(ggplot2)
library(tidyverse)


para <- read.csv('data_ens/parameter.csv',header = F)
colnames(para) <- c("group","x","beta","q","rho","Q")

para['beta'] <- sig(para['beta'])
para['rho'] <- sig(para['rho'])

plot_d <- para %>% gather(variable,value,-group,-x)





ggplot(plot_d,aes(x=x,y=value,color=as.factor(group))) +
  geom_line() + facet_wrap(~variable, scales="free")


para <- read.csv('data_ens/parameter20180929.csv',header = F)
colnames(para) <- c("group","x","beta","q","rho","Q")

para['beta'] <- sig(para['beta'])
para['rho'] <- sig(para['rho'])
plot_d <- para %>% gather(variable,value,-group,-x)


ggplot(plot_d,aes(x=x,y=value,color=as.factor(group))) +
  geom_line() + facet_wrap(~variable, scales="free")

para <- read.csv('data_ens/parameter_0929_2330.csv',header = F)
colnames(para) <- c("group","x","beta","q","rho","Q")

para['beta'] <- sig(para['beta'])
para['rho'] <- sig(para['rho'])
plot_d <- para %>% gather(variable,value,-group,-x)


ggplot(plot_d,aes(x=x,y=value,color=as.factor(group))) +
  geom_line() + facet_wrap(~variable, scales="free")


para <- read.csv('data_ens/parameter0930_2226_1000_800.csv',header = F)
colnames(para) <- c("group","x","beta","q","rho","Q")

para <-para[1:510,]


para['beta'] <- sig(para['beta'])
para['rho'] <- sig(para['rho'])
plot_d <- para %>% gather(variable,value,-group,-x)

plot_d[plot_d$variable == 'Q' & plot_d$x==0,'value'] <- NA

ggplot(plot_d,aes(x=x,y=value,color=as.factor(group))) +
  geom_line() + facet_wrap(~variable, scales="free")


