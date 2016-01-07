#
# null hypothesis - assumes nothing happened. 
# other hypothesis - something did happen. 
#
# which hypothesis supported by the data?
#
# 1) to begin, assume the null hypotheis is true.
# 2) calculate a test statistic. it can be the mean
# or something complex. critical assumption is that
# we must know the distribution of the sample mean.
# we can use the Central Limit theorem to get an 
# estimate.
# 3) from statistic and its distrobution, then calculate 
# a p-value, the probability of a test statistic value as
# extreme ormore extreme that one we observed, while assuming 
# null hypothesis is true.
# 4) if the p-value is too small, then we have evidence against
# the null hypothesis. called rejecting the null hypothesis.
# 5) if the p-value is not small then we have no such evidence.
# this is called failing to reject the null hypothesis.
#
# choose a p < 0.05 to reject the null hypothesis and p > 0.05 as 
# resaon to fail to reject the null hypothesis.
#
# confidence intervals - bounds on the parameters used in the
# tests. can be used for means, medians, and proportions of
# a population.
#
# 

# 9.1 - summarizing the data
#
# use the summary function.
#
vec = runif(50, min=0, max=10)
vec

summary(vec)

mat = matrix(runif(30, min=0, max=10), c(10,3))
mat
summary(mat)

lvals = list(l1=runif(20,min=0,max=10),
             l2=rnorm(20,mean=100,sd=15),
             l3=rexp(20, rate=1/10))
lvals
summary(lvals)

lapply(lvals, summary)

# 9.2 - calculating relative frequencies.
#
# count relative frequencies for values in sample.
#
# mean( x>0 )
#

x = rnorm(100, mean=100, sd=15)
mean(x>100)






