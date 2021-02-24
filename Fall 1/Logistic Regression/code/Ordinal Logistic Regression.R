###############################
#                             #
#     Logistic Regression:    #
# Ordinal Logistic Regression #
#                             #
#        Dr Aric LaBarr       #
#                             #
###############################

# Needed Libraries for Analysis #
install.packages("MASS")
install.packages("car")
install.packages("ggplot2")
install.packages("brant")
install.packages("VGAM")

library(MASS)
library(car)
library(ggplot2)
library(brant)
library(VGAM)

# Load Needed Data Sets #
# Replace the ... below with the file location of the data sets #
setwd("...")

wallet <- read.csv(file = "wallet.csv", header = TRUE)

# Proportional Odds Model #
train <- wallet
train$punish <- factor(train$punish)

clogit.model <- polr(factor(wallet) ~ male + business + punish + explain, 
                     method = "logistic", data = train)
summary(clogit.model)

brant(clogit.model)

# Partial Proportional Odds - Further Study #
plogit.model <- vglm(factor(wallet) ~ male + business + punish + explain,
                     data = train, family = cumulative(parallel = F ~ business))
summary(plogit.model)

# Odds Ratios #
ORtable <- data.frame(OR = exp(coef(clogit.model)),
                      lower = exp(confint(clogit.model))[,1],
                      upper = exp(confint(clogit.model))[,2])
print(ORtable)

# Predicted Probabilities #
pred_probs <- predict(clogit.model, newdata = train, type = "probs")
head(pred_probs)
