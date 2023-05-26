library(rpart)
library(rpart.plot)
library(ggplot2)
library(pROC)
library(RColorBrewer)
library(randomForest)
rm(list=ls())

big_data =read.csv(choose.files(), header=T, stringsAsFactors = TRUE)
head(big_data)

big_data1 = big_data[,-c(1,3,8,9,14)]
head(big_data1)
attach(big_data1)

m0=lm(total_payment~1)
#Null model with no variables
summary(m0)

m1=lm(total_payment~bodily_injury_count, line_of_business, loss_cause,loss_datetime,detailed_loss_cause,number_of_vehicles_on_claim
      ,reported_by,loss_county,loss_state,days_open,insured_fault_pct)
summary(m1)
#Full model with all the X's

step(m0, scope=list(lower=m0, upper=m1, direction ="both"))