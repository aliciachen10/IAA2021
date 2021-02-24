#-------------------------------------#
#         Autoregressive Models       #
#                                     #
#            Dr  Simmons              #
#-------------------------------------#

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
library(haven)
library(forecast)
library(fma)
library(tseries)
library(expsmooth)
library(lmtest)
library(zoo)
library(dyn)

# LOAD EXAMPLE DATA SETS ------------------------

# Change this for your computer
# This is the path for the folder where you saved/downloaded the SAS data sets 
# for this course from the class webpage. The default folder name was 'Class Data'
file.dir <- "Q:/My Drive/Fall 2017 - Time Series/Data/" 

# Names of the data files from 'Class Data' that we're going to use
input.file1 <- "ar2.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
AR2 <- read_sas(paste(file.dir, input.file1, sep = ""))



# TIME SERIES MODELIING (AR2 DATA) ------------------------

# Creating Time Series Data Object (AR2 Data)
Y <- ts(AR2$Y)

# Building an Autoregressive Model (AR2 Data)
AR.Model <- Arima(Y, order = c(2, 0, 0))

# View the autoregressive model fit
summary(AR.Model)

# View and plot the correlation functions' output for the response
Acf(Y, main = "")$acf
Pacf(Y, main = "")$acf

# View and plot the correlation functions' output for the residuals
Acf(AR.Model$residuals, main = "")$acf
Pacf(AR.Model$residuals, main = "")$acf

# Compute the Ljung-Box Test statistics for lags 1,2,...,10
# Then store them in the vector, White.LB
White.LB <- rep(NA, 10)
for(i in 1:10){
  White.LB[i] <- Box.test(AR.Model$residuals, lag = i, type = "Ljung", fitdf = 2)$p.value
}
  # Notice that for i=1, we have lag - fitdf = 1 - 2 < 0. The p-value is NaN 
  # when the statistic's degrees of freedom is negative. Also, for i=2 we 
  # have lag - fitdf = 2 - 2 = 0. The p-value = 0 when the statistic's null 
  # distribution is chi-squared with df=0. 

# p-values >= 0.2 are recorded as 0.2 (for plotting purposes)
White.LB <- pmin(White.LB, 0.2)

# Let's look at a plot of these p-values (lags 1,2,...,10)
# The horizontal lines let us see which lags have p-values <0.05 and <0.01
barplot(White.LB, main = "Ljung-Box Test P-values", ylab = "Probabilities", xlab = "Lags", ylim = c(0, 0.2))
abline(h = 0.01, lty = "dashed", col = "black")
abline(h = 0.05, lty = "dashed", col = "black")

# OTHER EXAMPLES ----------------------------------------

# If you want to skip some values:
AR.Model <- Arima(Y, order = c(2, 0, 0),fixed=c(0,NA,NA))
summary(AR.Model)

# For example, we can build a model with just AR terms of 1,2,4
AR.Model <- Arima(Y, order = c(4, 0, 0),fixed=c(NA,NA,0,NA,NA))
summary(AR.Model)

# As an example data set, let's simulate an arima data set
# We're creating a 'pretend' time series data set with 100 observations
# and MA coefficient = 0.9
# We also set the seed, so randomly generates the same values / data set 
# each time the R code is run. 
set.seed(9276) 
y<-arima.sim(model=list(ma=c(.9)),n=100) 

# Let's compute / view / plot the ACF and PACF 
# for our 'pretend' data set. 
Acf(y, main = "")$acf
Pacf(y, main = "")$acf

# Fit a MA model on this 'pretend' data
MA.Model <- Arima(y, order = c(0, 0, 1))

# View the model fit
summary(MA.Model)

# Compute / View / Plot the ACF and PACF for the MA model residuals
Acf(MA.Model$residuals, main = "")$acf
Pacf(MA.Model$residuals, main = "")$acf


