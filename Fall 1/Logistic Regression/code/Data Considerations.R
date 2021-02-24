###############################
#                             #
#     Logistic Regression:    #
#     Data Considerations     #
#                             #
#        Dr Aric LaBarr       #
#                             #
###############################

# Needed Libraries for Analysis #
install.packages("MASS")
install.packages("unbalanced")
install.packages("multcomp")
install.packages("brglm")
install.packages("car")

library(MASS)
library(unbalanced)
library(multcomp)
library(brglm)
library(car)

# Load Needed Data Sets #
# Replace the ... below with the file location of the data sets #
setwd("...")

churn <- read.csv(file = "tele_churn.csv", header = TRUE)

# Rare Event Sampling #
table(churn$churn)
prop.table(table(churn$churn))

# Create Training and Validation #
set.seed(12345)
train_id <- sample(seq_len(nrow(churn)), size = floor(0.7*nrow(churn)))

train <- churn[train_id,]
valid <- churn[-train_id,]

table(train$churn)
table(valid$churn)

# Oversampling and Undersampling #
prop.table(table(train$churn))

inputs <- train[,1:18]
target <- train[,19]
over_sam <- ubOver(X = inputs, Y = target)
train_o <- cbind(over_sam$X, over_sam$Y)
train_o$churn <- train_o$`over_sam$Y`
train_o$`over_sam$Y` <- NULL

table(train_o$churn)
prop.table(table(train_o$churn))

inputs <- train[,1:18]
target <- train[,19]
under_sam <- ubUnder(X = inputs, Y = target)
train_u <- cbind(under_sam$X, under_sam$Y)
train_u$churn <- train_u$`under_sam$Y`
train_u$`under_sam$Y` <- NULL

table(train_u$churn)
prop.table(table(train_u$churn))

# Sampling Adjustment - Adjust Intercept #
logit.model <- glm(churn ~ factor(international.plan) + 
                           factor(voice.mail.plan) + 
                           total.day.charge + 
                           customer.service.calls, 
                   data = train_u, family = binomial(link = "logit"))
summary(logit.model)

valid_p_bias <- predict(logit.model, newdata = valid, type = "response")
valid_p <- (valid_p_bias*0.5*(154/3004))/((1-valid_p_bias)*0.5*(2850/3004)+valid_p_bias*0.5*(154/3004))

# Sampling Adjustment - Weighted Observations #
train_u$weight <- ifelse(train_u$churn == 'TRUE', 0.1026, 1.8974)

logit.model.w <- glm(churn ~ factor(international.plan) + 
                             factor(voice.mail.plan) + 
                             total.day.charge + 
                             customer.service.calls, 
                     data = train_u, family = binomial(link = "logit"), 
                     weights = weight)
summary(logit.model.w)

valid_p_w <- predict(logit.model.w, newdata = valid, type = "response")

# Categorical Variables #
logit.model.w <- glm(churn ~ factor(international.plan) + 
                             factor(voice.mail.plan) + 
                             total.day.charge + 
                             factor(customer.service.calls), 
                     data = train_u, family = binomial(link = "logit"), 
                     weights = weight)
summary(logit.model.w)

# Contrasts - Further Study #
train_u$fcsc <- factor(train_u$customer.service.calls)

logit.model.w.2 <- glm(churn ~ factor(international.plan) + 
                               factor(voice.mail.plan) + 
                               total.day.charge + 
                               fcsc, 
                       data = train_u, family = binomial(link = "logit"), 
                       weights = weight)
summary(logit.model.w.2)

summary(glht(logit.model.w.2, linfct = mcp(fcsc = "Tukey")))

# Convergence Problems - Penalized Maximum Likelihood #
table(train_u$customer.service.calls, train_u$churn)

logit.model.w <- brglm(churn ~ factor(international.plan) + 
                               factor(voice.mail.plan) + 
                               total.day.charge + 
                               factor(customer.service.calls), 
                       data = train_u, family = binomial(link = "logit"), 
                       weights = weight)
summary(logit.model.w)

# Convergence Problems - Combining Categories #
train_u$customer.service.calls.c <- as.character(train_u$customer.service.calls)
train_u$customer.service.calls.c[which(train_u$customer.service.calls > 3)] <- "4+"

table(train_u$customer.service.calls.c, train_u$churn)

logit.model.w <- glm(churn ~ factor(international.plan) + 
                             factor(voice.mail.plan) + 
                             total.day.charge + 
                             factor(customer.service.calls.c), 
                     data = train_u, family = binomial(link = "logit"), 
                     weights = weight)
summary(logit.model.w)