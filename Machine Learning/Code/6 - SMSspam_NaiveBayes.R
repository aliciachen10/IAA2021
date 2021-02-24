install.packages('e1071')
install.packages('gmodels')
library(tm) # Because we have a term-document matrix
library(e1071) # Where the naiveBayes function is found
library(gmodels) # Where the CrossTable function is found

#' Let's try to use Naive Bayes to classify the text messages. Naive bayes is typically trained on data 
#' with categorical inputs. We want to think of our observations not as a collection of word frequencies, 
#' but merely a collection of words, regardless of how many times the word appeared in the text message. 
#' For the vast majority of cases, the word frequency will be 1 anyway. To do that, we will convert our 
#' columns to factors with two levels indicating the presence or absense of a word.
#' First we write a function that does this for one column, then we apply it to all columns:
#' In the apply function, margin=2 says to operate along columns as opposed to rows (margin=1)

convert_counts <- function(x)
{y = ifelse(x>0,"yes","no") 
return(y) }
sms_subset1 = apply(sms_tdm,2,convert_counts)

#' Then we can train the model on our training data and see how it performs on the test dataset:
#' 
set.seed(11117)
train=sample(c(T,F),nrow(sms_subset1), replace=T, p=c(0.75,0.25))

model = naiveBayes(sms_subset1[train,], sms_raw$type[train])
pred = predict(model,sms_subset1[!train,], type="class")
CrossTable(pred, sms_raw$type[!train], prop.chisq=F, prop.t = F, dnn = c('Predicted','Actual'))
# Accuracy on Test Data
mean(pred==sms_raw$type[!train])

#' Can we improve model performance? Having a high false positive rate is undesirable because
#' it could result in someone missing an important text because we thought it was spam. The
#' Laplace estimator is one dial that will help tune the model. When the Laplace estimator is 0,
#' words that did not appear in any spam messages has an indisputable influence on the classification -
#' because P(X_k|C_i) = 0 ==> P(X|C_i) = 0 (even if all other probabilities are large!)
#' but simply because the word 'hello' may have appeared only in ham messages from our sample, 
#' it does not mean that every message containing that word should be classified as ham. 
#' 
#' The Laplace correction (or estimator) essentially adds a small specified number to every cell count in 
#' our table of words by class. If the sample size is sufficient, this will do very little to alter the
#' predicted probabilities, expect when the predicted probability is 0 (which is undesirable).
#' 
#' Let's see how we do when we add in this correction:

model2 = naiveBayes(sms_subset1[train,], sms_raw$type[train], laplace = 1)
pred2 = predict(model2,sms_subset1[!train,], type="class")
CrossTable(pred2, sms_raw$type[!train], prop.chisq=F, prop.t = F, dnn = c('Predicted','Actual'))
# Accuracy on Test Data
mean(pred2==sms_raw$type[!train])

#' We've lowered our false positive rate and improved our overall performance. Let's see what a 
#' different Laplace correction might do - perhaps this is a parameter we ought to fiddle with?
#' Nope. Everything looks the same. We'll stick with the convention of Laplace = 1.

model3 = naiveBayes(sms_subset1[train,], sms_raw$type[train], laplace = 0.05)
pred3 = predict(model3,sms_subset1[!train,], type="class")
CrossTable(pred3, sms_raw$type[!train], prop.chisq=F, prop.t = F, dnn = c('Predicted','Actual'))

#