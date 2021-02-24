#------------------------------------#
#    Introduction to Time Series     #
#      & Time Series Structure       #
#                                    #
#           Dr Susan Simmons           #
#------------------------------------#

# Needed Libraries for Analysis ---------------------------
# TROUBLESHOOTING:
# Run this code chunk to install / load the required packages
# If asked 
# 'Do you want to install from sources the packages which need compilation? y/n: '
# choose 'y' (some packages run C++ or another compiled language in the background 
# to make the code faster, and the package is asking your permission to do this)
install.packages('tseries')
install.packages('forecast',dependencies = T)
install.packages(c('expsmooth','lmtest','zoo','seasonal','haven','fma'))
library(tseries)
library(forecast)
library(haven)
library(fma)
library(expsmooth)
library(lmtest)
library(zoo)
library(seasonal)

# Saving File Locations and Uploading SAS File ---------------------------

# Change this for your computer
# This is the path for the folder where you saved the SAS data sets 
# for this course from the class webpage. The default folder name was 'Class Data'
file.dir <- "Q:\\My Drive\\Fall 2017 - Time Series\\Data\\" 

# Names of the data files from 'Class Data' that we're going to use
input.file1 <- "usairlines.sas7bdat"
input.file2 <- "ar2.sas7bdat"

# Reads the data at specified directory
# If the file directory is incorrect, then this won't run
USAirlines <- read_sas(paste(file.dir, input.file1,sep = ""))
AR2 <- read_sas(paste(file.dir, input.file2, sep = ""))


# Time series modeling ----------------------------------------------------

# Creation of Time Series Data Object #
Passenger <- ts(USAirlines$Passengers, start = 1990, frequency =12)

# head(Passenger)
# Jan   Feb   Mar   Apr   May   Jun
# 1990 34348 33536 40578 38267 38249 40792

# Time Series Decomposition ...STL#
decomp_stl <- stl(Passenger, s.window = 20)

# Plot the individual components of the time series
plot(decomp_stl)

# Plot the non-decomposed ts (grey), with trend component overlay (red)
plot(Passenger, col = "grey", main = "US Airline Passengers - Trend/Cycle", xlab = "", ylab = "Number of Passengers (Thousands)", lwd = 2)
lines(decomp_stl$time.series[,2], col = "red", lwd = 2)

# Plot the non-decomposed ts (grey), with seasonal component overlay (red)
seas_pass=Passenger-decomp_stl$time.series[,1]
plot(Passenger, col = "grey", main = "US Airline Passengers - Seasonally Adjusted", xlab = "", ylab = "Number of Passengers (Thousands)", lwd = 2)
lines(seas_pass, col = "red", lwd = 2)

# Plot seasonal subseries by months
monthplot(decomp_stl$time.series[,"seasonal"], main = "US Airline Passengers - Monthly Effects", ylab = "Seasonal Sub Series", xlab = "Seasons (Months)", lwd = 2)

# Extra Examples ---------------------------------------------
#####For fun....X13
decomp_x13=seas(Passenger)
summary(decomp_x13)
install.packages('seasonalview')
library(seasonalview)
view(decomp_x13)
