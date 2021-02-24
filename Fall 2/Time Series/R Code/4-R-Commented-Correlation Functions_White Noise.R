#------------------------------------#
#        Correlation Functions       #
#                                    #
#           Dr Susan Simmons         #
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

# dyn hasn't appeared in previous examples
install.packages('dyn')

# Load the libraries
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
input.file1 <- "usairlines.sas7bdat"
input.file2 <- "ar2.sas7bdat"
input.file3 <- "steel.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
USAirlines <- read_sas(paste(file.dir, input.file1,sep = ""))
AR2 <- read_sas(paste(file.dir, input.file2, sep = ""))
Steel <- read_sas(paste(file.dir, input.file3, sep = ""))


# TIME SERIES MODELIING (AR2 DATA) ------------------------

# Creating Time Series Data Object (AR2 Data) #
Y <- ts(AR2$Y)

# Let's plot the fit of this AR2 time series object
# Lag Plot of Y #
lag.plot(Y, lag = 2, main = "Scatterplots of Y with First 2 Lags", diag = FALSE, layout = c(1, 2))


# TIME SERIES MODELIING (AIRLINE DATA) ------------------------

# Creating Time Series Data Object (Airline Data) #
Passenger <- ts(USAirlines$Passengers, start = 1990, frequency = 12)

# Now, let's compute and plot the correlation functions (Airline Data)
Acf(Passenger, lag = 40, main = "Autocorrelation Plot for US Airline Passengers")$acf
Pacf(Passenger, lag = 40, main = "Partial Autocorrelation Plot for US Airline Passengers")$acf

# TIME SERIES MODELIING (STEEL DATA) ------------------------

# Create Time Series Data Object (Steel Data)
SteelShp <- ts(Steel$steelshp, start = 1984, frequency = 12)

# Now, let's compute and plot the correlation functions (Steel Data)
Acf(SteelShp, lag = 10)$acf
Pacf(SteelShp, lag = 10)$acf

# Ljung-Box Test for Steel ES Model (Steel Data)#
SES.Steel <- ses(SteelShp, initial = "optimal", h = 24)

# Perform Ljung-Box test with lag 1,2,...,10, then store p-values in White.LB
White.LB <- rep(NA, 10)
for(i in 1:10){
  White.LB[i] <- Box.test(SES.Steel$residuals, lag = i, type = "Lj", fitdf = 1)$p.value
}


# p-values >= 0.2 are recorded as 0.2 (for plotting purposes)
White.LB <- pmin(White.LB, 0.2)

# Let's look at a plot of these p-values (lags 1,2,...,10)
# The horizontal lines let us see which lags have p-values <0.05 and <0.01
barplot(White.LB, main = "Ljung-Box Test P-values", ylab = "Probabilities", xlab = "Lags", ylim = c(0, 0.2))
abline(h = 0.01, lty = "dashed", col = "black")
abline(h = 0.05, lty = "dashed", col = "black")

