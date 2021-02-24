#-------------------------------------#
#           ARIMA Forecasting         #
#           & Identification          #
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

# We haven't installed these packages in previous code examples
# Do you want to install from sources the package which needs compilation?
# => Type y
install.packages(c("caschrono", "TSA"))

# Load the libraries
# If you get an error here, then you may want to check 
# that the package was installed properly. TSA and caschrono were 
# built under R version 3.4.4; this should be ok for this example
library(haven)
library(forecast)
library(fma)
library(tseries)
library(expsmooth)
library(lmtest)
library(zoo)
library(caschrono)
library(TSA)
library(imputeTS)

# LOAD EXAMPLE DATA SETS ------------------------

# Change this for your computer
# This is the path for the folder where you saved/downloaded the SAS data sets 
# for this course from the class webpage. The default folder name was 'Class Data'
file.dir <- "Q:/My Drive/Fall 2017 - Time Series/Data/" 

# Names of the data files from 'Class Data' that we're going to use
input.file1 <- "Hurricanes.sas7bdat"
input.file2 <- "SimARMA.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
Hurricane <- read_sas(paste(file.dir, input.file1,sep = ""))
SimARMA <- read_sas(paste(file.dir, input.file2, sep = ""))


# TIME SERIES MODELIING (Simulated ARMA data) ------------------------

# Build a time series object from the simulated data
Y <- ts(SimARMA$Y)

# Plot the correlation functions' output (simARMA data)
Acf(Y, lag = 10)
Pacf(Y, lag = 10)

# Build an Autoregressive Moving Average Model (SimARMA data)
ARMA.Model <- Arima(Y, order = c(1, 0, 1))

# Plot the correlation functions' output (ARMA residuals)
Acf(ARMA.Model$residuals, main = "")$acf
Pacf(ARMA.Model$residuals, main = "")$acf

# Compute the Ljung-Box Test statistics for lags 1,2,...,10
# Then store them in the vector, White.LB
White.LB <- rep(NA, 10)
for(i in 1:10){
  White.LB[i] <- Box.test(ARMA.Model$residuals, lag = i, type = "Ljung", fitdf = 2)$p.value
}

# p-values >= 0.2 are recorded as 0.2 (for plotting purposes)
White.LB <- pmin(White.LB, 0.2)

# Let's look at a plot of these p-values (lags 1,2,...,10)
# The horizontal lines let us see which lags have p-values <0.05 and <0.01
barplot(White.LB, main = "Ljung-Box Test P-values", ylab = "Probabilities", xlab = "Lags", ylim = c(0, 0.2))
abline(h = 0.01, lty = "dashed", col = "black")
abline(h = 0.05, lty = "dashed", col = "black")


# TIME SERIES MODELIING (Hurricane Data) ------------------------

# Build a time series from the Hurricane data
Hurricane.ts <- ts(Hurricane$MeanVMax)

# Impute the missing values via interpolation
Hurricane.ts2<-Hurricane.ts%>% na_interpolation(option = "spline")

# Fit an ARIMA model for the hurricane time series
auto.arima(Hurricane.ts2)


# Fit an ARIMA(2,0,3) model on hurricane data
Hurricane.model<-Arima(Hurricane.ts2,order=c(*,0,*))

# View the fit of this ARIMA model
summary(Hurricane.model)

# Compute the Ljung-Box Test statistics for lags 1,2,...,12
# Then store them in the vector, White.LB
White.LB <- rep(NA, 12)
for(i in 1:12){
  White.LB[i] <- Box.test(Hurricane.model$residuals, lag = i, type = "Ljung", fitdf = *)$p.value
}
# Notice that for i=1, we have lag - fitdf = 1 - 2 < 0. The p-value is NaN 
# when the statistic's degrees of freedom is negative. Also, for i=2 we 
# have lag - fitdf = 2 - 2 = 0. The p-value = 0 when the statistic's null 
# distribution is chi-squared with df=0. 

# p-values >= 0.2 are recorded as 0.2 (for plotting purposes)
White.LB <- pmin(White.LB, 0.2)

# Let's look at a plot of these p-values (lags 1,2,...,12)
# The horizontal lines let us see which lags have p-values <0.05 and <0.01
barplot(White.LB, main = "Ljung-Box Test P-values", ylab = "Probabilities", xlab = "Lags", ylim = c(0, 0.2))
abline(h = 0.01, lty = "dashed", col = "black")
abline(h = 0.05, lty = "dashed", col = "black")

# Forecasting (and plotting) using the model fit on hurricane data
forecast(Hurricane.model, h = 10)
plot(forecast(Hurricane.model, h = 10))

# HOW TO SIMULATE AN ARMA MODEL --------------------

# use simulation function to create time series
time1=arima.sim(n = 50, list(ar = c(0.8),ma=c(0.6)))

# Plot correlation functions' output
Acf(time1)$acf
Pacf(time1)$acf

# Run ARIMA on the simulated time series data
arima.time1=Arima(time1,order=c(1,0,1)) 

# View the model fit and correlation functions' output
summary(arima.time1)
Acf(arima.time1$residuals)$acf
Pacf(arima.time1$residuals)$acf
