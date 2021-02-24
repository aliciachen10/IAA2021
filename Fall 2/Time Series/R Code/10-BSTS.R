install.packages("bsts")
install.packages("tidyverse")


library(bsts)
library(tidyverse)
air.bsts=airline$LogPsngr
model_components=list()
model_components <- AddLocalLevel(model_components, 
                                  y = air.bsts)
fit.level=bsts(air.bsts, model_components, niter = 2000)
plot(fit.level$final.state,type='l')
pred.level<-predict(fit.level,burn = 500,horizon = 24)
plot(pred.level)


model_components=AddLocalLinearTrend(model_components, 
                                     y = air.bsts)
fit.trend=bsts(air.bsts, model_components, niter = 2000)
plot(fit.trend$final.state,type='l')
pred.trend<-predict(fit.trend,burn = 500,horizon = 24)
plot(pred.trend)

model_components=list()
model_components = AddLocalLevel(model_components, 
                                 y = air.bsts)
model_components=AddTrig(model_components, y = air.bsts, 
                         period  = 12,frequencies = 1:6)

fit.season=bsts(air.bsts, model_components, niter = 2000)
plot(fit.season$final.state[,2],type='l')
pred.season<-predict(fit.season,burn = 500,horizon = 24)
plot(pred.season)
