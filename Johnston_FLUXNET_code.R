library(readr)
library(lme4)
library(foreach)
library(doParallel)
library(MuMIn)

setwd(".")

data <-read_csv("FLUXNET_dataset.csv") 
attach(data)

### temperature breakpoint 1 for air temperature (replace with S_TEMP for soil temperature) 
tb1 <- function(A_TEMP, tbp) ifelse(A_TEMP < tbp, tbp - A_TEMP, 0)
tb2 <- function(A_TEMP, tbp) ifelse(A_TEMP < tbp, 0, A_TEMP - tbp)

tbp<-seq(3.131,4.353,by=0.001) 

numCores <- detectCores()
registerDoParallel(20)

aic<-foreach (i=tbp,.combine=c) %dopar% {
  AIC(lmer(TER ~ tb1(A_TEMP,i) + tb2(A_TEMP,i) + (1|FLUXNET_site) + (1|Lat), data = data))
}

stopImplicitCluster()

at_tbp1<-cbind.data.frame(tbp,aic)
write.csv(at_tbp1,"air_tbp1.csv")

### Linear - air temp
All.L1 <- lmer(TER ~ A_TEMP + (1|FLUXNET_site) + (1|Lat), data = data)
sink("Linear_model_air.txt")
print(summary(All.L1))
print(AIC(All.L1))
print(r.squaredGLMM(All.L1))
sink()
### first temperature breakpoint identified by calculating delta AIC's between the linear and best-performing threshold model

### model with two temperature breakpoints for air temperature
p2_tb1 <- function(A_TEMP, p2_tbp1) ifelse(A_TEMP <= p2_tbp1, p2_tbp1 - A_TEMP, 0)
p2_tb2 <- function(A_TEMP, p2_tbp1, tbp2) ifelse(A_TEMP <= p2_tbp1, 0, ifelse(A_TEMP <= p2_tbp2, A_TEMP-p2_tbp1, p2_tbp2-p2_tbp1))
p2_tb3 <- function(A_TEMP, p2_tbp2) ifelse(A_TEMP <= p2_tbp2, 0, A_TEMP - p2_tbp2)
p2_tbp2 = 4.027 

p2_tbp1<-seq(3.131,4.353,by=0.001) 

numCores <- detectCores()
registerDoParallel(20)

aic<-foreach (i=p2_tbp1,.combine=c) %dopar% {
  AIC(lmer(TER ~ p2_tb1(A_TEMP,i) + p2_tb2(A_TEMP,i,p2_tbp2) + p2_tb3(A_TEMP, p2_tbp2) + (1|FLUXNET_site) + (1|Lat), data = data))
}

stopImplicitCluster()

at_tbp2<-cbind.data.frame(p2_tbp1,aic)
write.csv(at_tbp2,"air_tbp2.csv")

### P1 - air temp
p1_tb1 <- function(A_TEMP, p2_tbp2) ifelse(A_TEMP < p2_tbp2, p2_tbp2 - A_TEMP, 0)
p1_tb2 <- function(A_TEMP, p2_tbp2) ifelse(A_TEMP < p2_tbp2, 0, A_TEMP - p2_tbp2)
All.P1 <- lmer(TER ~ p1_tb1(A_TEMP,p2_tbp2) + p1_tb2(A_TEMP,p2_tbp2) + (1|FLUXNET_site) + (1|Lat), data = data)
sink("T1_model_air.txt")
print(summary(All.P1))
print(AIC(All.P1))
print(r.squaredGLMM(All.P1))
sink()
## second temperature breakpoint determined by calculating delta AICs between the single (P1) and two (P2) temperature breakpoint models 

## P2 - air temp
tb1 <- function(A_TEMP, tbp1) ifelse(A_TEMP <= tbp1, tbp1 - A_TEMP, 0)
tb2 <- function(A_TEMP, tbp1, tbp2) ifelse(A_TEMP <= tbp1, 0, ifelse(A_TEMP <= tbp2, A_TEMP-tbp1, tbp2-tbp1))
tb3 <- function(A_TEMP, tbp2) ifelse(A_TEMP <= tbp2, 0, A_TEMP - tbp2)
tbp1 = 3.469 
tbp2 = 4.027 
All.P2 <- lmer(TER ~ tb1(A_TEMP,tbp1) + tb2(A_TEMP,tbp1,tbp2) + tb3(A_TEMP, tbp2) + (1|FLUXNET_site) + (1|Lat), data = data)

### model prediction using activation energy of -7.50 K predicted by metabolic theory
All.Met <- lmer(TER ~ 1 + offset(-7.5*A_TEMP) + (1|FLUXNET_site) + (1|Lat), data = data)

## Anova of all models (metabolic theory prediction, linear, single temperature breakpoint, and two temperature breakpoints)
anova(All.Met,All.L1,All.P1,All.P2, test = "Chisq")
