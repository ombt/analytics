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
mean(x[x>100])

mean(abs(x-mean(x)) > 2*sd(x))
mean(x[abs(x-mean(x)) > 2*sd(x)])
x[abs(x-mean(x)) > 2*sd(x)]

# 9.3 - tabulating factors and creating contingency tables
#
# build a contingency table for one or more factors
#
# table(f)
# table(f1, f2)
#

mtcars

table(mtcars$cyl)
table(mtcars$gear)

table(mtcars$gear, mtcars$cyl)

sum(mtcars$gear==4 & mtcars$cyl==6)

table(mtcars$gear, mtcars$cyl)

mtcars[mtcars$gear==4 & mtcars$cyl==6,]

# 9.4 - testing canonical variables for independence.
#
# use table function to produce a contingency table and 
# use summary function to perform a chi-2 test.
#
summary(table(mtcars$gear, mtcars$cyl))

# 9.5 - calculating quantiles and quartiles of a dataset.
#
# given a q, want to know which values are greater q and what
# percentage.
#
# quantile(vec, f)
# quantile(vec)

vec = runif(1000, min=0, max=1)
quantile(vec)
quantile(vec, 0.05)
quantile(vec, c(0.05, 0.95))

# 9.6 - inverting a quantile
#
# mean(vec<x)
#

vec = rnorm(1000, mean=100, sd=15)

mean(vec<80)
vec[vec<80]

# 9.7 - converting data to z-scores
#
# convert to z-scores is to normalize the data.
#
# scale(x)
#
# works for vectors, matrices, data frames,
#

vec = rnorm(100, mean=100, sd=15)

scale(vec)

y=120
(y-mean(vec))/sd(vec)


y = runif(100, min=(100-4*15), max=(100+4*15))
(y-mean(vec))/sd(vec)

# 9.8 - testing the mean of a sample (t test)
#
# with a sample of a population, want to know if
# the population could reasonably be a value m.
#
# apply t.test t0 sample x with argument mu=m,
#
# t.test(x, mu=m)
#
# output includes a p-value. if p<0.05, then the population
# mean unlikely to be m whereas p > 0.05 provides no evidence,
#
# if your sample size is small, then the underlying population
# must be normally distributed to get meaningfull results. rule of
# thumb, small size means n<30.
#

x = rnorm(500, mean=100, sd=15)
t.test(x, mu=95)

t.test(x, mu=100)

x = rnorm(500, mean=105, sd=15)
t.test(x, mu=95)

t.test(x, mu=100)

# 9.9 - confidence interval for a mean.
#
# use t-test.
#
# same as 9.8 since t.test gives a confidence interval.
#

x = rnorm(50, mean=100, sd=15)
t.test(x, mu=95)

t.test(x, mu=100)

x = rnorm(50, mean=105, sd=15)
t.test(x, mu=95, conf.level=0.99)

t.test(x, mu=100, conf.level=0.99)

# 9.10 - testing a sample proportion
#
# you have a sample of values from a population consisting
# successes and failures. you believe the true proportion of
# successes is p, and you want to test the hypothesis using the
# sample data.
#
# prop.test(x, n, p)
#
# where the sample size is n and the sample contains x successes.
#
# if the p-value < 0.05, then the true proportion is unlikely to be p.
# otherwise a p>0.05 give no evidenc to reject the hypothesis.
#

prop.test(11, 20, 0.5, alternative="greater")

# 9.12 - confidence interval for a proportion
#
# same as 9.11
#

prop.test(11, 20, 0.5, alternative="greater")
prop.test(11, 20, 0.5, alternative="greater", conf.level=0.99)

# testing for normality 
#
# does data follow a normal distribution.
#
# shapiro.test(x)
#
# p-value<0.05 means populations is NOT normal.
# p-value>0.05 means population is normal.
#

x = rnorm(100, mean=105, sd=15)
shapiro.test(x)

x = runif(100, min=(100-4*15), max=(100+4*15))
shapiro.test(x)

x = rexp(100, rate=1/5)
shapiro.test(x)

# other tests for normality are inclkud

install_and_load("normtest")

search()

ls("package:normtest")

#
# these tests are very conservatite, may give false positives.
# use histograms (10.18) and Q-Q plots (10.21) to determine if the 
# distribution is really normal.
#

# 9.14 - testing for runs
#
# data is a run of yes-no, 0-1, true-false, or other two-value
# data. is the run random?
#
# library(tseries)
# runs.test(as.factor(s))
#
# where s is a two-value factor.
#

install_and_load("tseries")

s = sample(c(0,1), 100, replace=TRUE)
runs.test(as.factor(s))

s = c(0,0,0,0,1,1,1,1,0,0,0,0)
runs.test(as.factor(s))

# 9.15 - comparing the means of two samples.
#
# use t.test to compare the means.
#
# t.test(x, y)
#
# if the values are paired, dependent, then use paired=TRUE.
# if p-value<0.05, means are different.
# if p-value>0.05, means are the same.
#

x = rnorm(100, mean=100, sd=15)
y = rnorm(100, mean=105, sd=15)

t.test(x, y)

t.test(x, y, paired=TRUE)

# requires both samples be large (n>20) or the underlying
# distribution is normal of n < 20.
#
# if the populations are not normal or the sample sizes are small,
# consider using the wilcoxon-mann-whitney test.
#

# 9.16 - comparing the locations of two samples nonparametrically.
#
# you have two samples. the disrtibutions are unknown, but they
# have similar shapes. are the samples just shifted left or right?
#
# use wilcoxon-mann-whitney test. for paired observations, use
# paired=TRUE, else use the default of FALSE.
#
# wilcox.test(x,y,paired=TRUE)
# or
# wilcox.test(x,y)
#
# if p-value<0.05, then second sample is shifted.
# if p-value>0.05, then second sample is NOT shifted.
#
# wilcox.test(fav, unfav, paired=TRUE)
#

x = rnorm(10, mean=100, sd=15)
y = rnorm(10, mean=105, sd=15)

wilcox.test(x,y,paired=TRUE)
wilcox.test(x,y,paired=FALSE)

# 9.17 - testing a correlation for significance..
#
# calculate the correlation between two variables, and you want
# to know if the correlation is statistically significant.
#
# if variables are normally dietributed, then use pearson
# method, the default. if the variables are not normal, then
# use the Spearman method.
#
# cor.test(x, y)
#
# p<0.05 => correlation is significant.
# p.0.05 => correlation is NOT significant.
#
# cor.test(x, y, method="Spearman")
#

x = rnorm(10, mean=100, sd=15)
y = rnorm(10, mean=105, sd=15)

cor.test(x,y)

# 9.18 - testing groups for equal proportions.
#
# samples from two or more groups. group elements are
# binary values, success or failure. want to know if the
# if the groups have equal proportion of successes.
#
# ns = c(ns1, ns2, ..., nsN)
# nt = c(nt1, nt2, ..., ntN)
#
# prop.test(ns, nt)
#
# ns - number of successes in group
# nt - number of members in group
#
# p<0.05 => group proportions are different
# p>0.05 => group proportions are NOT different
#

successes = c(14,10)
trials = c(38, 40)

prop.test(successes, trials)

# 9.19 - performing piarwise comparisons between group means
#
# compare mean of each sample against the mean of every other sample.
#
# use 5.5 - combining vectors into one vector and a factor.

freshmen = c(0.6,0.35,0.44,0.62,0.60)
sophomores = c(0.70,0.61,0.63,0.87,0.85,0.70,0.64)
juniors = c(0.76, 0.71, 0.91, 0.87)

# the factors are v1,v2,v3,v4 and the values
# the vector of values as grouped by the
# factors v1,v2,v3,v3, in this case.
#
comb = stack(list(freshmen=freshmen, 
                  sophomores=sophomores, 
                  juniors=juniors))
comb

pairwise.t.test(comb$values, comb$ind)

# p<0.05 => different means
# p.0.05 => NOT different means


# 9.20 - testing two samples for the same distribution
#
# kolmogorov-smirnov test compares two samples and tests
# them for being drawn form the same distribution.
#
# ks.test(x,y)
#
# p<0.05 => different distributions
# p>0.05 => same distributions
#
# great test and non-parametric.
#

x = rnorm(100, mean=105, sd=15)
x2 = rnorm(100, mean=105, sd=15)
y = runif(100, min=(100-4*15), max=(100+4*15))

ks.test(x,x2)
ks.test(x,y)





