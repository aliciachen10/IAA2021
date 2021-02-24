#-------------------------------------#
#       Intervention Variables        #
#              ARIMAX                 #
#         Transfer Functions          #
#                                     #
#            Dr Simmons               #
#-------------------------------------#

# LOAD R PACKAGES ------------------------

# We installed these packages in previous examples, uncomment code if needed
# (ie, you run library statement and get an error)
# install.packages('forecast', dependencies = TRUE)
# install.packages('fma')
# install.packages('haven')
# install.packages('tseries')
# install.packages('expsmooth')
# install.packages('lmtest')
# install.packages('zoo')
# install.packages('caschrono')
# install.packages('TSA')

# We haven't used these packages in previous examples:
install.packages('fpp2')

# load the R packages
library(haven)
library(forecast)
library(tseries)
library(expsmooth)
library(lmtest)
library(zoo)
library(caschrono)
library(TSA)
library(quantmod)
library(fpp2)
library(MASS)
library(fma)
library(dplyr)

# TIME SERIES MODELING (HOUSING DATA SET, hstart) ------------------------

# We load the data set, "housing", from the fma package
# The 'fma::' part is to specify that we want 'housing' from fma
# and not 'housing' from MASS. ?housing for more info
hstart=as.vector(fma::housing[,1])
constr=1000*as.vector(fma::housing[,2])
interest=as.vector(fma::housing[,3])

# Build a time series on the housing data
hstart.ts=ts(hstart,frequency = 12)

# Build a model matrix for all the month variables
x.1<-c(rep(seq(1,12),6),seq(1,11))
x.2<-model.matrix(~as.factor(x.1))
x.mat<-x.2[-1,-1]

# plot the data
plot(hstart, type='l')
plot(constr,type='l')
plot(interest,type='l')
# A basic regression model for hstart 

model1<-lm(hstart~interest+constr)
# Plot the residuals from the linear regression model
plot(model1$residuals)
time=seq(1:length(constr))-mean(seq(1:length(constr)))
time2=time^2
# Check residuals of new model
model1<-lm(hstart~interest+constr+time+time2)
ndiffs(model1$residuals)
###Arima model
xreg.model2=cbind(interest,constr,time,time2)

model2=Arima(hstart.ts,order=c(17,0,0),seasonal = c(0,0,1),xreg=xreg.model2,fixed=c(0,0,0,0,0,0,0,0,0,0,0,0,NA,0,NA,0,NA,NA,NA,NA,NA,NA,NA))
summary(model2)
# plot and compute correlation function on the residuals
Acf(model2$residuals)$acf
Pacf(model2$residuals)$acf

# Compute the Ljung-Box test for lags 5-18 and store p-values in box.pvalue
box.pvalue=rep(NA,18)
for (i in 5:18){
  box.pvalue[i]=Box.test(model2$residuals,lag=i,type='Ljung-Box',fitdf=4)$p.value
}

# TIME SERIES PREDICTIONS (HOUSING DATA, contracts) ------------------

# Build a model with all terms, then use backward selection

int1<-lag(interest,1)
int2<-lag(interest,2)
int3<-lag(interest,3)
int4<-lag(interest,4)
int5<-lag(interest,5)
int6<-lag(interest,6)
int7<-lag(interest,7)
int8<-lag(interest,8)
int9<-lag(interest,9)
constr1<-lag(constr,1)
constr2<-lag(constr,2)
constr3<-lag(constr,3)
constr4<-lag(constr,4)
constr5<-lag(constr,5)
constr6<-lag(constr,6)
all.x.reg<-data.frame(cbind(hstart,interest,constr,int1,int2,int3,int4,int5,
                            int6,int7,int8,int9,constr1,constr2,constr3,constr4,
                            constr5,constr6))
model.all<-lm(hstart~.,data=all.x.reg)
step(model.all,direction="backward")
model.all2<-lm(hstart~1,data=all.x.reg)
step(model.all,direction="both")

choose.x1<-c(2,3,6,11,12,13,14,15)
choose.x2<-c(2,3,6,11,12,13:18)
choose.x3<-c(3,6,11,12,13,14,15)
x.arima1<-as.matrix(all.x.reg[,choose.x1])
x.arima2<-as.matrix(all.x.reg[,choose.x2])
x.arima3<-as.matrix(all.x.reg[,choose.x3])

# Fit model 1
model1<-Arima(hstart,order=c(0,0,1),xreg=x.arima1)
ndiffs(model1$residuals,test = 'adf')
Acf(model1$residuals)$acf
Pacf(model1$residuals)$acf
# Fit model 2
model2<-Arima(hstart,order=c(0,0,1),xreg=x.arima2)
Acf(model2$residuals)$acf
Pacf(model2$residuals)$acf

# Fit model 3
model3<-Arima(hstart,order=c(0,0,7),xreg=x.arima3,fixed=c(NA,0,0,0,0,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA))
Acf(model3$residuals)$acf
Pacf(model3$residuals)$acf
