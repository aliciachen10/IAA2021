###############################
#                             #
#     Logistic Regression:    #
#     Multinomial Logistic    #
#                             #
#        Dr Aric LaBarr       #
#                             #
###############################

# Needed Libraries for Analysis #
install.packages("MASS")
install.packages("car")
install.packages("ggplot2")
install.packages("nnet")
install.packages("visreg")

library(MASS)
library(car)
library(ggplot2)
library(nnet)
library(visreg)

# Load Needed Data Sets #
# Replace the ... below with the file location of the data sets #
setwd("...")

gator <- read.csv(file = "gator.csv", header = TRUE)

# Multinomial Logistic Regression #
gator$food <- factor(gator$food)
gator$food <- relevel(gator$food, ref = "Fish")

glogit.model <- multinom(food ~ size + lake + gender, weight = count, data = gator)
summary(glogit.model)

# Relative Risk Ratios #
exp(coef(glogit.model))

# Predicted Probabilities #
pred_probs <- predict(glogit.model, newdata = gator, type = "probs")
head(pred_probs)
