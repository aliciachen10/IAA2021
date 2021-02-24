#' Original data consisted of 5574 Text messages, containing 7K+ unique words AFTER basic preprocessing
#' We then removed words that happened infrequently. The tm package made this easy.
#' This is feature selection. Only included words that occured at least 4 times in collection.
# That left 1833 words/features
load('/Users/shaina/Library/Mobile Documents/com~apple~CloudDocs/Linear Algebra/Linear Algebra 2020/Code/sms_subset.Rdata')
# Some preliminary analysis with PCA:
library(tm)

train = sample(c(T,F),nrow(sms_raw),replace=T,p=c(0.9,0.1))
pca = prcomp(sms_subset[train,]) 

# Screeplot
plot(pca$sdev^2)


# Plot of the 1833 dimensional data projected onto a plane
plot(pca$x[,1:2], col=c(rgb(66/245, 1, 149/245,alpha=0.2),rgb(206/245, 66/245, 245/245,alpha=0.2))[sms_raw$type], pch=19)
legend(x='topleft', c('Ham','Spam'), pch=19, col=c(rgb(66/245, 1, 149/245,alpha=0.5),rgb(206/245, 66/245, 245/245,alpha=0.5)), pt.cex=1.5)

# Plot of the 1833 dimensional data projected onto 3-dimensional subspace
library(rgl)
library(car)
scatter3d(pca$x[,1],pca$x[,2],pca$x[,3], groups=sms_raw$type, surface=F)

# Let's see if we can use some principal components as input to a model.
# Let k be the number of components used:
k=3
new_data = data.frame(pca$x[,1:k])
new_data = cbind(sms_raw$type[train], new_data)
colnames(new_data)[1]="type"

# Make a logistic regression model:
model = glm(type ~ . , family="binomial", data=new_data)
summary(model)
# Accuracy on training data
(c=table(model$fitted.values>0.5,sms_raw$type[train])) 
(misclass=(c[1,2]+c[2,1])/5574)

# Score the test set according to principal components found on training data
# then create predictions from logistic regression model and check accuracy
g = data.frame(predict(pca,sms_subset[!train,]))
pred=predict(model, g, type="response")
mean((pred>0.5)==(sms_raw$type[!train]=='spam'))
(c=table(pred>0.5,sms_raw$type[!train])) 
(misclass=(c[1,2]+c[2,1])/5574)

#' Technical note: This is not necessarily the prescribed method for modelling this problem. 
#' It is merely an illustration of the power of dimension reduction to force related observations
#' and variables close to one another. 
#' 
#' We will revisit this dataset later in the semester. Naive Bayes Classifiers tend to be well suited
#' for this type of problem, although they can be far slower to implement with new data, which can be 
#' problematic in a fast-paced solution environment.
#' 



