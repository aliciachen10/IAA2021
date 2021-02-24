#-------------------------------------#
#        Seasonal ARIMA Models        #
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
# install.packages('ggplot2')

# Load the R packages
 library(haven)
 library(forecast)
 library(fma)
 library(tseries)
 library(expsmooth)
 library(lmtest)
 library(zoo)
 library(ggplot2)
 
# LOAD EXAMPLE DATA SETS ------------------------

# Change this for your computer
# This is the path for the folder where you saved/downloaded the SAS data sets 
# for this course from the class webpage. The default folder name was 'Class Data'
file.dir <- "/Users/kmartin9/Downloads/Class Data/" 

# Names of the data files from 'Class Data' that we're going to use
input.file1 <- "usa_tx_noaa.sas7bdat"
input.file2 <- "airline.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
tx <- read_sas(paste(file.dir, input.file1, sep = ""))
airline <- read_sas(paste(file.dir, input.file2, sep = ""))
 
 # TIME SERIES MODELIING () ------------------------

 # Separate TX data into training and test data sets
 tx.test<-tx$Temperature[1359:1370]
 
 # Fit a time series on training set
 tx.ts<-ts(tx$Temperature[1:1358],frequency = 12)
 
 # Set the TX month variable in training set to a factor
 month.tx=factor(tx$Month[1:1358])
 
 # Create a model matrix on this TX month variable
 reg.tx=model.matrix(~month.tx)
 reg.tx=reg.tx[,-1] # delete the first column
 
 # Fit an ARIMA model on TX time series (training), using the 
 # month factor as dummy variables
 tx.seas=Arima(tx.ts,xreg=reg.tx)
 
 # View this seasonal model
 summary(tx.seas)
 
 
# TIME SERIES MODELING WITH SINE AND COSINE IN ARIMA ---------

 #Fourier or Sin/Cos
 index.ts=seq(1,length(tx.ts))
 x1.sin=sin(2*pi*index.ts*1/12)
 x1.cos=cos(2*pi*index.ts*1/12)
 x2.sin=sin(2*pi*index.ts*2/12)
 x2.cos=cos(2*pi*index.ts*2/12)
 x3.sin=sin(2*pi*index.ts*3/12)
 x3.cos=cos(2*pi*index.ts*3/12)
 x4.sin=sin(2*pi*index.ts*4/12)
 x4.cos=cos(2*pi*index.ts*4/12)
 x.reg=cbind(x1.sin,x1.cos,x2.sin,x2.cos,x3.sin,x3.cos,x4.sin,x4.cos)
 
 # Fit an ARIMA model using sine and cosine regressors
 arima.1<-Arima(tx.ts,order=c(0,0,0),xreg=x.reg)
 summary(arima.1)
 
 # Fit an ARIMA model using Fourier regressors
 arima.2<-Arima(tx.ts,order=c(0,0,0),xreg=fourier(tx.ts,K=4))
 summary(arima.2)
 
# CREATING AN STL WITH MULTIPLE SEASONS ---------------------
 
 # DATA SET: 
 # Number of calls handled on weekdays between 7:00 am and 9:05 pm
 # Five-minute call volume from March 3, 2003, to May 23, 2003
 # in a large North American commercial bank.
 calls <- unlist(read.csv("https://robjhyndman.com/data/callcenter.txt",
                          header=TRUE,sep="\t")[,-1])
 
 calls <- msts(calls, start=1, seasonal.periods = c(169, 169*5))
 # There is 169 5-minute intervals in one day 7:00 am to 9:05 pm.
 # Center is open 5 day in one week.
 # Above multiple season time series incorporates a daily season (169)
 # and a weekly season 5*169=845...no yearly season...not enough data!
 
 # Plot the call data and separate by trend, season, and remainder
 calls %>% mstl() %>%
   autoplot() + xlab("Week")
 
 # Fit an ARIMA model using Fourier regressors
 fit <- auto.arima(calls, seasonal=FALSE,
                   xreg=fourier(calls, K=c(10,10)))
 # View the model fit
 summary(fit)
 
 # Forecast and plot using the model that we just fit
 fit %>%
   forecast(xreg=fourier(calls, K=c(10,10), h=2*169)) %>%
   autoplot(include=5*169) +
   ylab("Call volume") + xlab("Weeks")
 
 # Forecast and plot using the model that we just fit
 fit %>%
   forecast(xreg=fourier(calls, K=c(10,10), h=2*169)) %>%
   autoplot(include=3*169) +
   ylab("Call volume") + xlab("Weeks")
 
 # Number of differences required for a seasonally stationary series
 nsdiffs(tx.ts)
 nsdiffs(tx.ts,test='ch')
 
 
 # TIME SERIES MODELING (airline data set) ---------
 
 # Fit a time series object
 air.ts<-ts(airline$LogPsngr,frequency = 12)
 
 # Fit an ARIMA model with seasonality
 S.ARIMA <- Arima(air.ts, order=c(0,1,1), seasonal=c(0,1,1), method="ML")
 summary(S.ARIMA)
 
 # Fit a multiplicative model
 S.ARIMA <- Arima(air.ts, order=c(0,1,13), seasonal=c(0,1,0),fixed=c(NA,0,0,0,0,0,0,0,0,
                                                                     0,0,NA,NA),method="ML")
 summary(S.ARIMA)
 
 