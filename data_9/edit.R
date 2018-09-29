#MATLABの結果をgunplotで表示するための編集
library(tidyverse)
setwd("~/PF_MATLAB/data_9")
particle<- read.csv('filter_X.csv', header = F)
particle_weight <- read.csv('filter_weight.csv', header = F)
dt <- dim(particle)[1]
N <- dim(particle)[2]

particle <- cbind(dT = c(1:dt),particle)
tmp1 <- particle %>% gather(N, particle, -dT)

particle <- cbind(dT = c(1:dt),particle_weight)
tmp2 <- particle %>% gather(N, particle_weight, -dT)

particle_data <- right_join(tmp1,tmp2,by=c('dT','N'))
particle_data <- cbind(particle_data,particle_data$particle_weight*10)
write.table(particle_data,'plot_particle.csv',row.names = F, col.names = F,sep = ',')

filter_mean <- read.csv('filter_mean.csv',header = FALSE)
write.table(cbind(c(1:dt),filter_mean),'plot_filter_mean.csv',row.names = F, col.names = F,sep = ',')

smoothing_mean <- read.csv('smoothing_mean.csv',header = FALSE)
write.table(cbind(c(1:dt),smoothing_mean),'plot_smoothing_mean.csv',row.names = F, col.names = F,sep = ',')

X <- read.csv('X_plot.csv',header = FALSE)
write.table(cbind(c(1:dt),X[-1,]),'plot_answer_X.csv',row.names = F, col.names = F,sep = ',')

DR <- read.csv('DR_plot.csv',header = FALSE)
write.table(cbind(c(1:dt),DR[-1,]),'plot_DR.csv',row.names = F, col.names = F,sep = ',')
