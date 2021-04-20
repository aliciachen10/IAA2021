load("/Users/shaina/Library/Mobile Documents/com~apple~CloudDocs/Social Network Analysis/SLACK/slack2021/SlackNetworkData2021.RData")
library(igraph)

##################################################################
##################################################################
###########    Create Adjacency Matrix for Gender    #############
##################################################################
##################################################################

##################################################################
slackInteract = as_adj(slack)
##################################################################

##################################################################
##################################################################
# Let's simulate this situation 1000 times, effectively the reassigning
# individuals to their blue/orange cohorts randomly and
#  see what the distribution of the chi-squared
# statistic looks like under the null hypothesis that there is no 
# relationship 
##################################################################
##################################################################


# What about cohort membership? Is the average degree different between cohorts?
# This first method isolates the cohorts and drops the edges BETWEEN them, only focusing on
# intra-cohort activity.
blue = induced_subgraph(slack, V(slack)$Cohort=="b")
orange = induced_subgraph(slack, V(slack)$Cohort=="o")
(mean(degree(blue)))
(mean(degree(orange)))
(diffMeansObserved_within =(mean(degree(blue)))-(mean(degree(orange))))


# This second method explores degree in the overall graph and how it differs 
# between Blue and Orange
V(slack)$degree = degree(slack)
(mean(V(slack)$degree[V(slack)$Cohort=="b"]))
(mean(V(slack)$degree[V(slack)$Cohort=="o"]))
(diffMeansObserved = mean(V(slack)$degree[V(slack)$Cohort=="b"])-mean(V(slack)$degree[V(slack)$Cohort=="o"]))
# Either way we cut this, looks like Blue and Orange have different degree distributions.
# Are these numbers within the bounds of what we'd expect if there was no relationship between cohort and degree?
# Let's see:
##################################################################
##################################################################
# First View: WITHIN-Cohort Activity
##################################################################
##################################################################
SimulatedValues = vector()
n=vcount(slack)
for (sim in 1:1000){
  randperm = sample(1:n,n,replace=F,prob=NULL)
  simC = V(slack)$Cohort[randperm]
  blue = induced_subgraph(slack, simC=="b")
  orange = induced_subgraph(slack, simC=="o")
  (mean(degree(blue)))
  (mean(degree(orange)))
  diffMeans =(mean(degree(blue)))-(mean(degree(orange)))
  SimulatedValues[sim] = diffMeans
}
hist(SimulatedValues,col='gray',main="",xlab = 'Chi-Squared Statistic', ylab = 'Number of Simulations')
points(diffMeansObserved_within, 0, pch = "X", cex=2)
# Now calculate the true p-value as the proportion of simulations >= observed statistic
sum(SimulatedValues>=diffMeansObserved_within)/1000

##################################################################
##################################################################
# Second View: Overall Activity
##################################################################
##################################################################
SimulatedValues = vector()
n=vcount(slack)
for (sim in 1:1000){
  randperm = sample(1:n,n,replace=F,prob=NULL)
  simC = V(slack)$Cohort[randperm]
  diffMeans = mean(V(slack)$degree[simC =="b"])-mean(V(slack)$degree[simC =="o"])
  SimulatedValues[sim] = diffMeans
}
hist(SimulatedValues,col='gray',main="",xlab = 'Chi-Squared Statistic', ylab = 'Number of Simulations')
points(diffMeansObserved, 0, pch = "X", cex=2)
# Now calculate the true p-value as the proportion of simulations >= observed statistic
sum(SimulatedValues>=diffMeansObserved)/1000

# The difference we're observing has more to do with natural variance in degree 
# than the actual attribute cohort!

