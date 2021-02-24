#-------------------------------------#
#           Neural Networks           #
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
# install.packages('quantmod')
# install.packages('TSA')

# Load the R packages
library(haven)
library(forecast)
library(fma)
library(tseries)
library(expsmooth)
library(lmtest)
library(zoo)
library(caschrono)
library(TSA)
library(quantmod)


# LOAD EXAMPLE DATA SETS ------------------------

# Change this for your computer
# This is the path for the folder where you saved/downloaded the SAS data sets 
# for this course from the class webpage. The default folder name was 'Class Data'
file.dir <- "Q:/My Drive/Fall 2017 - Time Series/Data/" 

# Names of the data files from 'Class Data' that we're going to use
input.file1 <- "usairlines.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
USAirlines <- read_sas(paste(file.dir, input.file1,sep = ""))

# TIME SERIES MODELIING (Airlines Data) ------------------------

# Creating Time Series Data Objects 
Passenger <- ts(USAirlines$Passengers, start = 1990, frequency = 12)

# Autoregressive Neural Network Model and Forecast
NN.Model <- nnetar(diff(Passenger, 12), p = 2, P = 1, size = 2)
NN.Forecast <- forecast(NN.Model, h = 24)
plot(NN.Forecast)

# Neural Network Model on ARIMA residuals and forecast
xreg1<-cbind(fourier(Passenger,K=5),seq(1,length(Passenger)))
colnames(xreg1)<-c('s1','c1','s2','c2','s3','c3','s4','c4','s5','c5','time')
Model.four<-Arima(Passenger,order=c(0,0,0),xreg=xreg1)
NN.Model2<-nnetar(Model.four$residuals,p=2,P=1,size=2)
NN.Forecast2<-forecast(NN.Model2,h=24)
plot(NN.Forecast2)

# Forecast passengers for next year by adding to previous year's passenger data
Pass.Forecast <- rep(NA, 24)
for(i in 1:12){
  Pass.Forecast[i] <- Passenger[length(Passenger) - 12 + i] + forecast(NN.Model, h = 24)$mean[i]
}

# Forecast passengers for next year by adding to the previously forecasted values
for(i in 13:24){
  Pass.Forecast[i] <- Pass.Forecast[i - 12] + forecast(NN.Model, h = 24)$mean[i]
}

# Now, let's view our forecast: 

# Put the forecasted values into a time series object
Pass.Forecast <- ts(Pass.Forecast, start = c(2008, 4), frequency = 12)

# Plot the original (black) and our forecast (blue)
plot(Passenger, main = "US Airline Passengers ARIMA Model Forecasts", xlab = "Date", ylab = "Passengers (Thousands)", xlim = c(1990, 2010), ylim = c(30000,80000))
lines(Pass.Forecast, col = "blue")
abline(v = 2008.25, col = "red", lty = "dashed")

# ANOTHER FORECAST ------------------------------------------

# Add the NN forecasted mean to a fourier time series forecast
for.seq<-seq(220,243)
xreg2<-cbind(fourier(Passenger,K=5,h=24),for.seq)
colnames(xreg2)<-c('s1','c1','s2','c2','s3','c3','s4','c4','s5','c5','time')
Base.forecast<-forecast(Model.four,xreg=xreg2,h=24)
Pass.Forecast2 <- Base.forecast$mean+NN.Forecast2$mean

# Put our second forecast into a time series object
Pass.Forecast2 <- ts(Pass.Forecast2, start = c(2008, 4), frequency = 12)

# Plot the original data (black) and our new forecast (orange)
plot(Passenger, main = "US Airline Passengers ARIMA Model Forecasts", xlab = "Date", ylab = "Passengers (Thousands)", xlim = c(1990, 2010), ylim = c(30000,80000))
lines(Pass.Forecast2, col = "orange")
abline(v = 2008.25, col = "red", lty = "dashed")

