#------------------------------------#
#        Exponential Smoothing       #
#               Models               #
#                                    #
#           Dr Susan Simmons         #
#------------------------------------#

# LOAD R PACKAGES ------------------------

# We installed these packages in previous examples, uncomment code if needed
# (ie, you run library statement and get an error)
# install.packages('tseries')
# install.packages('forecast', dependencies = TRUE)
# install.packages('fma')
# install.packages('tseries')
# install.packages('expsmooth')
# install.packages('lmtest')
# install.packages('zoo')
# install.packages('ggplot2')

library(haven)
library(forecast)
library(fma)
library(tseries)
library(expsmooth)
library(lmtest)
library(zoo)
library(ggplot2)

# LOAD DATA FILES -------------------------------

# Change this for your computer
# This is the path for the folder where you saved the SAS data sets 
# for this course from the class webpage. The default folder name was 'Class Data'
file.dir <- "Q:/My Drive/Fall 2017 - Time Series/Data/" 

# Names of the data files from 'Class Data' that we're going to use
input.file1 <- "usairlines.sas7bdat"
input.file2 <- "steel.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
USAirlines <- read_sas(paste(file.dir, input.file1, sep = ""))
Steel <- read_sas(paste(file.dir, input.file2, sep = ""))

# TIME SERIES MODELING (STEEL DATA) -------------------------------

# Create time series object using passengers data
Passenger <- ts(USAirlines$Passengers, start = 1990, frequency = 12)

# Create time series object using steel data
SteelShp <- ts(Steel$steelshp, start = 1984, frequency = 12)

# SES Model ----------------------------- 

# Building a Single Exponential Smoothing (SES) Model - Steel Data #
SES.Steel <- ses(SteelShp, initial = "optimal", h = 24)
summary(SES.Steel)

# Plot the SES model on steel data
plot(SES.Steel, main = "US Steel Shipments with Simple ESM Forecast", xlab = "Date", ylab = "Shipments (Thousands of Net Tons)")
abline(v = 1992, col = "red", lty = "dashed") # adds vertical red dotted line to plot

# Computes accuracy statistics for SES model on steel data (training data...NOT validation nor test)
round(accuracy(SES.Steel),2) 
  # output: 
  #               ME   RMSE    MAE   MPE MAPE MASE  ACF1
  # Training set 4.82 458.94 364.19 -0.33 5.72 0.83 -0.04

# Create the same SES model plot using ggplot2 graphics
autoplot(SES.Steel)+
  autolayer(fitted(SES.Steel),series="Fitted")+ylab("US Steel Shipments with Simple ESM Forecast")

# LES Model ----------------------------- 

# Building a Linear Exponential Smoothing Model - Steel Data #
LES.Steel <- holt(SteelShp, initial = "optimal", h = 24)
summary(LES.Steel)

# Plote the LES model on steel data
plot(LES.Steel, main = "US Steel Shipments with Linear ESM Forecast", xlab = "Date", ylab = "Shipments (Thousands of Net Tons)")
abline(v = 1992, col = "red", lty = "dashed") # adds vertical red dashed line

# Create the same LES model plot using ggplot2 graphics
autoplot(LES.Steel)+
  autolayer(fitted(LES.Steel),series="Fitted")+ylab("US Steel Shipments with Holt ESM Forecast")

# LDES Model ----------------------------- 

# Build a LDES model (same as previous model but with damping)
LDES.Steel <- holt(SteelShp, initial = "optimal", h = 24, damped = TRUE)
summary(LDES.Steel)

# plot LDES model
plot(LDES.Steel, main = "US Steel Shipments with Linear Damped ESM Forecast", xlab = "Date", ylab = "Shipments (Thousands of Net Tons)")
abline(v = 1992, col = "red", lty = "dashed") # adds vertical red dashed line 

# Create the same LDES model plot using ggplot2 graphics
autoplot(LDES.Steel)+
  autolayer(fitted(LDES.Steel),series="Fitted")+ylab("US Steel Shipments")

# TIME SERIES MODELING (US AIRLINES DATA) -------------------------------


# LES Model ----------------------------- 

# Building a Linear Exponential Smoothing Model - US Airlines Data #
LES.USAir <- holt(Passenger, initial = "optimal", h = 24)
summary(LES.USAir)

# plot the LES model for Airlines Data
plot(LES.USAir, main = "US Airline Passengers with Linear ESM Forecast", xlab = "Date", ylab = "Passengers (Thousands)")
abline(v = 2008.25, col = "red", lty = "dashed") # adds the vertical red dashed line

# LDES Model ----------------------------- 

# Build the LDES model for Airlines Data (same as before, but with damping)
LDES.USAir <- holt(Passenger, initial = "optimal", h = 24, damped = TRUE)
summary(LDES.USAir)

# plot the LDES model for Airlines Data
plot(LDES.USAir, main = "US Airline Passengers with Linear Damped ESM Forecast", xlab = "Date", ylab = "Passengers (Thousands)")
abline(v = 2008.25, col = "red", lty = "dashed") # adds the vertical red dashed line

# Holt-Winters ESM Model ----------------------------- 

# Building a Holt-Winters ESM - US Airlines Data - Additive Seasonality#
HWES.USAir <- hw(Passenger, seasonal = "additive")
summary(HWES.USAir)

# plot the Holt-Winters ESM for Airlines Data (Additive)
plot(HWES.USAir, main = "US Airline Passengers with Holt-Winters ESM Forecast", xlab = "Date", ylab = "Passengers (Thousands)")
abline(v = 2008.25, col = "red", lty = "dashed") # adds vertical red dashed line

# Creates same Holt-Winters ESM plot for Airlines Data (now using ggplot2)
autoplot(HWES.USAir)+
  autolayer(fitted(HWES.USAir),series="Fitted")+ylab("Airlines Passengers")



# Building a Holt-Winters ESM - US Airlines Data - Multiplicative Seasonality
HWES.USAir <- hw(Passenger, seasonal = "multiplicative")
summary(HWES.USAir)

# plot the Holt-Winters ESM for Airlines Data (Multiplicative)
plot(HWES.USAir, main = "US Airline Passengers with Holt-Winters ESM Forecast", xlab = "Date", ylab = "Passengers (Thousands)")
abline(v = 2008.25, col = "red", lty = "dashed") # adds vertical red dashed line

# Creates same Holt-Winters ESM plot for Airlines Data (now using ggplot2)
autoplot(HWES.USAir)+
  autolayer(fitted(HWES.USAir),series="Fitted")+ylab("Airlines Passengers")


# Example of Using a Holdout Data Set ------------------------------------

# Create training set from overall Airlines Data
training=subset(Passenger,end=length(Passenger)-12)

# Create test set from overall Airlines Data
test=subset(Passenger,start=length(Passenger)-11)

# Fit Holt-Winters ESM (multiplicative seasonality) on training data
HWES.USAir.train <- hw(training, seasonal = "multiplicative",initial='optimal')

# Forecast predictions from fitted HW ESM model on test data
test.results=forecast(HWES.USAir.train,h=12)

# Calculate prediction errors from forecast
error=test-test.results$mean

# Calculate prediction error statistics (MAE and MAPE)
MAE=mean(abs(error))
MAPE=mean(abs(error)/abs(test))
 
#######ETS....Error, Trend, Seasonality

ets.passenger<-ets(training)
summary(ets.passenger)
ets.forecast.passenger<-forecast(ets.passenger,h=12)
error=test-ets.forecast.passenger$mean
error=test-test.results$mean
ets.passenger<-ets(training)

