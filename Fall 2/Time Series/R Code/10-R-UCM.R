library(haven)
library(rucm)

file.dir <- "Q:/My Drive/Fall 2017 - Time Series/Data/"
input.file1 <- "Airline.sas7bdat"
Airline <- read_sas(paste(file.dir, input.file1, sep = ""))
model1=ucm(formula=LogPsngr~0,data=Airline,irregular=T,level=T,slope=T,season = T,season.length = 12)
model1
fit.model1=predict(model1)
model2=ucm(formula=LogPsngr~0,data=Airline,irregular=T,level=T,slope=T,slope.var=0,season = T,season.length = 12)
model2
fit.model2=predict(model2)

###Not great output nor informative (yet)