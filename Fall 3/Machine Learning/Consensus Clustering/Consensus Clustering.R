# library(pracma) # tic toc function

load("/Users/shaina/Library/Mobile Documents/com~apple~CloudDocs/Datasets and Code/UCI Adult data/adult.RData")

#####################################################
###############  Explore your data
###############
###############
###############  Transform your data
#####################################################
adult$nativeCountry2=as.character(adult$nativeCountry)
adult$nativeCountry2[adult$nativeCountry2!=' United-States'] = 'notUS'
adult$nativeCountry2[adult$nativeCountry2==' United-States'] = 'US'
adult$nativeCountry=factor(as.character(adult$nativeCountry2))
adult$nativeCountry2=NULL
adult$capitalGain = log(adult$capitalGain+1)
adult$capitalLoss = log(adult$capitalLoss+1)
#####################################################
###############  Dummy Code the factors
#####################################################
adult.x = model.matrix(~. ,contrasts.arg = lapply(adult[,sapply(adult,is.factor) ], 
                                                  contrasts, contrasts=FALSE),
                       data = adult)
dim(adult.x)
# Get rid of constant columns
adult.x = adult.x[,apply(adult.x, 2, sd)>0 ]
dim(adult.x)
#####################################################
###############  Go to Principal Components
#####################################################
pca = prcomp(adult.x, scale = T)
#Screeplot
par(mfrow=c(1,1))
plot(pca$sdev^2)
# CONCLUSION: USE 7 COMPONENTS FOR CLUSTERING
#####################################################
###############  Consensus Matrix Function
#####################################################
#' This function will create the matrix H referenced in the slides
#' To create the Consensus Matrix, C, you must do the extra step
#' C = H %*% t(H). This is computationally (storage) expensive for more than 
#' 10K observations

MakeConsensus = function(M){
  kn = dim(M)[2]
  m = dim(M)[1] # number of observations
  A = matrix(NA,nrow=m,ncol=1)
  A = A[,-1] # empty adjacency matrix
  for(j in 1:kn){
    k = max(M[,j]) # number of clusters in clustering
    
    for(i in 1:k){
      A = cbind(A,matrix(as.numeric(M[,j] == i)))
    }
    if (sum(is.na(A))>0) stop('Still missing values in adjacency matrix. Something went wrong.')
  }
  return(A)
}


#####################################################
###############  Make a bunch of Clusterings
#####################################################

#' This empty matrix will store all the cluster solution vectors
#' that are output from each run of k-means as columns.
#' So if I make 4 clusterings, this clusters matrix will be nx4 
#' and each entry will tell me what cluster number each observation 
#' was in for each clustering.
clusters = matrix(NA,45222,1)
clusters=clusters[,-1] # Hack to make it empty

#' now, for k=3,4,5,6,7 I'll cluster the data (actually the 
#' first 7 principal components of the data). I will do so 10 times
#' for each value of k resulting in 10*(sum(3:7)) = 250 individual 
#' clusters from the 10*(5)=50 clusterings
 # tic()
set.seed(11117)
for(k in 3:7){
  iter=1
  while(iter<11){
    clusters=cbind(clusters, kmeans(pca$x[,1:7],k)$cluster)
    iter=iter+1
  }
}
 # toc(echo=T)
# elapsed time is 3.614000 seconds 

#####################################################
###############  Make a pre-Consensus Matrix
###############  Observe singular values
#####################################################
 
# tic()
J= MakeConsensus(clusters)
# toc(echo=T)
# elapsed time is 6.806000 seconds 

# tic()
svd.j = svd(J, nu = 100,nv=100)
# toc(echo=T)
# elapsed time is 8.135000 seconds 

plot(svd.j$d^2)
# I see 4 clusters
#####################################################
###############  Compute a final Clustering Solution
###############  OR repeat the above steps on the 
###############  pre-consensus matrix J
#####################################################
set.seed(11117)
finalClusters = kmeans(svd.j$u[,1:4], 4)

#####################################################
###############  Visualize your final cluster solution
###############  using the original principal components
#####################################################
samplePoints = sample(1:45222, 8000, replace=F)
par(mfrow=c(1,1))
plot(pca$x[samplePoints,1:2],col=finalClusters$cluster[samplePoints])
par(mfrow=c(3,3),mar=c(4,4,1,1))
plot(pca$x[samplePoints,c(1,2)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(1,3)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(1,4)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(1,5)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(2,3)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(2,4)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(2,5)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(3,4)],col=finalClusters$cluster[samplePoints])
plot(pca$x[samplePoints,c(3,5)],col=finalClusters$cluster[samplePoints])

#####################################################
###############  Profile your final cluster solution
###############  using the original variables
#####################################################

#####################################################
###############  Cluster Profile Function
#####################################################

clusterProfile = function(df, clusterVar, varsToProfile){
  k = max(df[,clusterVar])
  for(j in varsToProfile){
    if(is.numeric(df[,j])){
      for(i in 1:k){
        hist(as.numeric(df[df[,clusterVar]==i ,j ]), breaks=50, freq=F, col=rgb(1,0,0,0.5),
             xlab=paste(j), ylab="Density", main=paste("Cluster",i, 'vs all data, variable:',j))
        hist(as.numeric(df[,j ]), breaks=50,freq=F, col=rgb(0,0,1,0.5), xlab="", ylab="Density", add=T)
        
        legend("topright", bty='n',legend=c(paste("cluster",i),'all observations'), col=c(rgb(1,0,0,0.5),rgb(0,0,1,0.5)), pt.cex=2, pch=15 )}
    }
    if(is.factor(df[,j])){
      (counts = table( df[,j],df[,clusterVar]))
      (counts = counts%*%diag(colSums(counts)^(-1)))
      barplot(counts, main=paste(j, 'by cluster'),
              xlab=paste(j),legend = rownames(counts), beside=TRUE)
    }
  }
}
#####################################################
###############  Using the Profile Function
#####################################################
adult$finalCluster=finalClusters$cluster

varsToProfile = c("age" , "workclass","education","maritalStatus","occupation","relationship","race","sex",
                  "capitalGain","capitalLoss","hoursPerWeek","nativeCountry","incomeLevel")
par(mfrow=c(3,3))
clusterProfile(df=adult, clusterVar ='finalCluster',varsToProfile)

