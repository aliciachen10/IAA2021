###############################
#                             #
#     Logistic Regression:    #
#  Binary Logistic Regression #
#                             #
#        Dr Aric LaBarr       #
#                             #
###############################

# Needed Libraries for Analysis #
install.packages("MASS")
install.packages("visreg")
install.packages("brglm")
install.packages("car")
install.packages("mgcv")

library(MASS)
library(visreg)
library(brglm)
library(car)
library(mgcv)

# Load Needed Data Sets #
# Replace the ... below with the file location of the data sets #
setwd("...")

bwt <- read.csv(file = "lowbwt.csv", header = TRUE)

# Linear Probability Model #
lp.model <- lm(low ~ age + ht + lwt + ptl + factor(smoke) + ui, data=bwt)

with(bwt, plot(x = age, y = low,
               main = 'OLS Regression?',
               xlab = 'Mother`s Age',
               ylab = 'Low Borth Weight'))
abline(lp.model)

summary(lp.model)

# Logistic Regression Model #
logit.model <- glm(low ~ age + lwt + factor(smoke) + factor(race), 
                   data = bwt, family = binomial(link = "logit"))
summary(logit.model)

# Overall Test for Categorical Variables #
logit.model.r <- glm(low ~ age + lwt + factor(smoke), 
                   data = bwt, family = binomial(link = "logit"))

anova(logit.model, logit.model.r, test = 'LRT')

# Checking Assumptions - Box-Tidwell #
boxTidwell(low ~ age + lwt, data = bwt)

# Checking Assumptions - GAM Logistic Regression #
fit.gam <- gam(low ~ s(age) + s(lwt) + smoke + factor(race),
               data = bwt, family = binomial(link = 'logit'),
               method = 'REML')
summary(fit.gam)
plot(fit.gam, shade = TRUE, jit = TRUE, seWithMean = TRUE)

# Odds Ratios #
exp(
  cbind(coef(logit.model), confint(logit.model))
  )

# Likelihood Ratio Test #
logit.model.r <- glm(low ~ 1, 
                     data = bwt, family = binomial(link = "logit"))

anova(logit.model, logit.model.r, test = 'LRT')

# Predicted Values #
newbw <- data.frame(age = c(21, 40, 31, 28, 35),
                     lwt = c(110, 120, 130, 140, 100),
                     race = c("white", "black", "other", "white", "black"),
                     smoke = c(0, 0, 1, 1, 0))

newbw <- data.frame(newbw, 'Pred' = predict(logit.model, newdata = newbw, type = "response"))

visreg(logit.model, "lwt", by = "race", scale = "response",
       cond = list(smoke = 0, lwt = 130),
       overlay = TRUE,
       xlab = 'Mother`s Weight',
       ylab = 'Low Birth Weight')

print(newbw)
