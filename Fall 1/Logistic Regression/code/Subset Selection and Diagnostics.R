###############################
#                             #
#     Logistic Regression:    #
#      Subset Selection &     #
#         Diagnostics         #
#                             #
#        Dr Aric LaBarr       #
#                             #
###############################

# Needed Libraries for Analysis #
install.packages("MASS")
install.packages("car")
install.packages("rJava")
install.packages("glmulti")
install.packages("givitiR")

library(MASS)
library(car)
library(rJava)
library(glmulti)
library(givitiR)

# Load Needed Data Sets #
# Replace the ... below with the file location of the data sets #
setwd("...")

bwt <- read.csv(file = "lowbwt.csv", header = TRUE)

# Logistic Regression Model - Subset Selection #
logit.model <- glmulti(low ~ age + lwt + factor(smoke) + factor(race), 
                       data = bwt, 
                       level = 1,
                       method='h',
                       crit='aic',
                       confsetsize = 5,
                       plotty = TRUE,
                       fitfunction = 'glm',
                       family = binomial)
logit.model@formulas
logit.model@objects

# Logistic Regression Model - Stepwise Selection #
full.model <- glm(low ~ age + lwt + factor(smoke) + factor(race), 
                  data = bwt, family = binomial(link = "logit"))

empty.model <- glm(low ~ 1, data = bwt, family = binomial(link = "logit"))

step.model <- step(empty.model, 
                   scope = list(lower=formula(empty.model), upper=formula(full.model)), 
                   direction = "both")
summary(step.model)

# Logistic Regression Model - Backward Selection #
back.model <- step(full.model, direction = "backward")
summary(back.model)

# Logistic Regression Model - Forward Selection for Interactions #
main.model <- glm(low ~ age + lwt + factor(smoke) + factor(race), 
                  data = bwt, family = binomial(link = "logit"))

int.model <- glm(low ~ age + lwt + factor(smoke) + factor(race) +
                       age*lwt + age*factor(smoke) + age*factor(race) +
                       lwt*factor(smoke) + lwt*factor(race) + factor(smoke)*factor(race), 
                       data = bwt, family = binomial(link = "logit"))

for.model <- step(main.model, 
                  scope = list(lower=formula(main.model), upper=formula(int.model)), 
                  direction = "forward")
summary(for.model)

# Diagnostics #
logit.model <- glm(low ~ lwt + factor(smoke) + factor(race), 
                   data = bwt, family = binomial(link = "logit"))
summary(logit.model)

head(influence.measures(logit.model)$infmat)

plot(logit.model, 4)

dfbetasPlots(logit.model, terms = "lwt", id.n = 5,
             col = ifelse(logit.model$y == 1, "red", "blue"))

# Calibration Curve - Further Study #
logit.model <- glm(low ~ lwt + factor(smoke) + factor(race), 
                   data = bwt, family = binomial(link = "logit"))
summary(logit.model)

cali.curve <- givitiCalibrationBelt(o = bwt$low, 
                                    e = predict(logit.model, type = "response"), 
                                    devel = "internal",
                                    maxDeg = 5)
plot(cali.curve, main = "Birth Weight Model Calibration Curve",
                 xlab = "Predicted Probability",
                 ylab = "Observed Low Birth Weight")
