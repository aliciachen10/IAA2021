#------------------------------------#
#        Trend and Season            #
#           Modelling                #
#                                    #
#       Dr Susan Simmons             #
#------------------------------------#

# LOAD R PACKAGES ------------------------

# We installed these packages in previous examples, uncomment code if needed
# (ie, you run library statement and get an error)
# install.packages('forecast', dependencies = TRUE)
# install.packages('fma')
# install.packages('tseries')
# install.packages('expsmooth')
# install.packages('lmtest')
# install.packages('zoo')
# install.packages('ggplot2')

# These haven't appeared in previous code examples
install.packages('haven')
install.packages('imputeTS')

library(forecast)
library(haven)
library(fma)
library(expsmooth)
library(lmtest)
library(zoo)
library(seasonal)
library(imputeTS)

# LOAD EXAMPLE DATA SETS ------------------------

# Change this for your computer
# This is the path for the folder where you saved/downloaded the SAS data sets 
# for this course from the class webpage. The default folder name was 'Class Data'
file.dir <- "Q:/My Drive/Fall 2017 - Time Series/Data/" 

# Names of the data files from 'Class Data' that we're going to use
input.file1 <- "usairlines.sas7bdat"
input.file2 <- "leadyear.sas7bdat"
input.file3 <- "ebay9899.sas7bdat"
input.file4 <- "fpp_insurance.sas7bdat" # this file doesn't exist??

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
USAirlines <- read_sas(paste(file.dir, input.file1,sep = ""))
Lead.Year <- read_sas(paste(file.dir, input.file2, sep = ""))
Ebay <- read_sas(paste(file.dir, input.file3, sep = ""))
Quotes<-read_sas(paste(file.dir, input.file4, sep = "")) # this file doesn't exist??
Passenger <- ts(USAirlines$Passengers, start=1990, frequency=12)


# Augmented Dickey-Fuller test example (Insurance data) -----------------------

# Fit a time series
Quotes.ts<-ts(Quotes$Quotes)

# Perform the ADF test (k=0)
adf.test(Quotes.ts, alternative = "stationary", k = 0)

# Run the ADF test on k=0,1,2 and save p-values in vector called ADF.Pvalues
ADF.Pvalues <- rep(NA, 3)
for(i in 0:2){
  ADF.Pvalues[i+1] <- adf.test(Quotes.ts, alternative = "stationary", k = i)$p.value
}

ADF.Pvalues

# Deterministic Trend Example -----------------------------

x=seq(1:length(Passenger))
lm.passenger=lm(USAirlines$Passengers~x)
summary(lm.passenger)
arima.trend=Arima(Passenger,xreg=x,order=c(0,0,0))

# View the model fit
summary(arima.trend)
 
# Let's perform an ADF test
adf.test(Passenger,alternative = "stationary", k = 0)
  # OUTPUT: 
  #
  # data:  y.ts
  # Dickey-Fuller = -6.528, Lag order = 0, p-value = 0.01
  # alternative hypothesis: stationary
adf.test(Passenger,alternative = "stationary", k = 1)
adf.test(Passenger,alternative = "stationary", k = 2)

# Random Walk with Drift Example (E-Bay Data) ------------------------------

# Fit a time series to the Ebay data
Daily.High <- ts(Ebay$DailyHigh)

# Interpolate the missing observations in this data set
Daily.High<-Daily.High %>% na_interpolation(option = "spline")

# Perform an ADF test
adf.test(Daily.High,alternative = 'stationary',k=0)

# Fit an ARIMA model and view the model fitting results
rw.drift=Arima(Daily.High,order=c(0,1,0))
summary(rw.drift)

