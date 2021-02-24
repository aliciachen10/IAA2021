#-------------------------------------#
#        Seasonal ARIMA Models        #
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
input.file1 <- "Deer.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
Deer <- read_sas(paste(file.dir, input.file1,sep = ""))

# TIME SERIES MODELIING (Deer Accidents Data) ------------------------

# Creating Time Series Data Objects 
Deer.Accidents <- ts(Deer$deer, start = 2003, frequency = 12)

# Plot the time series object
plot(Deer.Accidents)


# Point (Pulse) Intervention - Deterministic #
# WARNING: arima() is a function in the package, TSA, and there is also 
# a function named arima() in the base stats package. The one in the TSA package
# is basically the same as in the stats package but allows transferfunctions. 
# Arima() is a function in the package, forecast. It's the same as the one 
# in the stats package, but it allows a drift term.
Deer.Model1 <- forecast::Arima(Deer.Accidents, xreg = Deer$Nov, method = "ML")
summary(Deer.Model1)

# Create variables to keep track of dates (month of November)
For.Month <- rep(0, 24) + 1:12
For.Nov <- rep(0, 24)
for(i in 1:24){
  if(For.Month[i] == 11){
    For.Nov[i] <- 1
  } else {
    For.Nov[i] <- 0
  }
}

# forecast using November as an external regressor
forecast(Deer.Model1, h = 24, xreg = For.Nov)

# Plot our forcast
plot(forecast(Deer.Model1, h = 24, xreg = For.Nov))

# Now let's fit an ARIMAX model: 
# Point (Pulse) Intervention - Stochastic + ARIMA Model #
Deer.Model2 <- arimax(Deer.Accidents, order = c(0, 0, 0), seasonal = list(order = c(1, 0, 0), period = 12),xtransf = Deer$Nov, transfer = list(c(1, 0)), method = 'ML')
summary(Deer.Model2)

