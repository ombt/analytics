#
# standard names for probability distributions
#
# dnorm - normal density
# pnorm - normal distribution function
# qnorm - normal quartile function
# rnorm - normal random variates
#
# discrete distrubutions
#
# binomial - binom(n=number of trials,
#                  p=probability of success for one trial)
# geometric - geom(p=probability of success for one trial)
# hypergeometric - hyper(m=number of white balls in urn,
#                        n=number of black bals in urn,
#                        k=number of balls drawn from urn)
# negative binomial - nbinom(size=number of successful trials,
#                            either prob = probability of successful
#                            trial or mu = mean)
#
# continuous distributions
#
# beta - beta(shape1, shape2)
# cauchy - cauchy(location, scale)
# chi-squared - chisq(df = degrees of inspection)
# exponential - exp(rate)
# F - f(df1,df2) = degrees of freedom,
# gamma  - gamma(rate, either rate or scale)
# log-normal <-- lnorm(meanlog = mean on log scale)
# logistic <- logis(location, scale)
# normal <- norm(mean, sd=standard deviation0
# student's t - t(df=degrees of separaions),
# uniform <- unif(min=lower limit, max= upper definition
# weibull <- weibull(shape, scale)
# wilcoxon -<- wilcox(m=number of samples in first example; 
#                     n=second=number-of-observations in second
#			sample.
# 
# use help(name) to ge help
#
# 8.1 - count the enumber of combinations of n items taken k at 
# a time.
# 
# choose(n,k)`
#
n=10
k=4
choose(n,k)

# how many ways can we choose 3 items from 5 items
choose(5,3)
# how many ways can we choose 3 items from 50)
choose(50,3)
# how many ways can we select 30 items from 50 items
choose(50,20)

# 8.2 - combination formula is:
#
#  c = n!/r!(n-r)!

# ch 8.2 - generating combination - generate all combinations
# of n items taken k at a time.
#
# combo(items, k) 
#
# # generate all combos from 1 to 5 taken 3 at a time.
#
combn(1:5,3)
#
combn(c("t1", "t2", "t3", "t3", "t4", "t5"), 3)
#

# 8.3 - generate random numbers.
#

runif(1)

runif(10)

runif(1, min=03, max=3)

rnorm(1)

rnorm(1, mean=100, sd=15)

rbinom(1, size=10, prob=0.5)

rpois(1, lambda=10)

rexp(1, rate=0.1)

rgamma(1, shape=2, rate=0.1)

rnorm(1, mean=c(-10,0,10), sd=1)

means <- rnorm(100, mean=0, sd=0.2)
rnorm(100, mean=means, sd=1)

# 8.4 - generating reproducible random numbers
#
# use set.seed() to generate the same list of random
# numbers.
#
set.seed(165)
runif(10)

set.seed(165)
runif(10)

# 8.5 generating a random sample
# randomly select n items from a vector,
#
# sample(vec, n)
#

n=1000
vec = c(1:100)
sample(vec, n, replace=TRUE)
mean(sample(vec, n, replace=TRUE))

# sample bootstrap

x = runif(100, min=0, max=100)

medians = numeric(1000)

for (i in 1:1000)
{
    medians[i] = median(sample(x, replace=TRUE))
}

ci = quantile(medians, c(0.025, 0.975))

cat("95% confidence interval is (", ci, ")\n")

# 8.6 generating random sequences

# simulate a series of coin tosses or a sequence of bernoulli 
# trials.
#
# sample(set, n, replace=TRUE)

sample(c("H","T"), 10, replace=TRUE)

sample(c(FALSE,TRUE), 20, replace=TRUE)

# for bernoulli, set the prob for each value in the vector.
#
sample(c(FALSE,TRUE), 20, replace=TRUE, prob=c(0.2,0.8))

rbinom(100, 1, 0.8)

# 8.7 - randomly permuting a vector
#
# if v is a vector, then sample(v) returns a random permutation.
#

v = 1:20
sample(v)
sample(v, size=length(v), replace=FALSE)

# 8.8 - calculating probabilties for discrete dirtibutoins
#
# want to calculate the simple or cumulative probability for
# a discrete random variable.
#
# for simple probability, P(X=x) uses the density. 
# for cumulative probability, F(X<=x) uses the distribution function.
# all built-in probabilties have a distribution function starting
# with "p".
#
# we have a binomial randm variable X over 10 trials where each
# trial has a success probability = 0.5.
# calculate the probability of x=7
#
dbinom(7, size=10, prob=0.50)

# cumulative probability for P(X<=7)
#
pbinom(7, size=10, prob=0.5)


# distribution	density function	distribution function
#		P(X=x)			P(X<=x)
# binomial	dbinomial(x,size,prob)	pbinom(x,size,prob)
# geometric	dgeom(x,prob)		pgeom(x,size,prob)
# poisson	dpois(x,lambda)		pgeom(x,lambda)

# complement of distribution is the survival function
# given by P(X>x). specify lower.tail=FALSE in a distribution
# to get this.

pbinom(7, size=10, prob=0.5, lower.tail=FALSE)

# to get P(x1<X<x2) = P(X<=x2)- P(X<=x1)
#
# to get P(3<X<=7)
#
pbinom(7,size=10,prob=0.5) - pbinom(3,size=10,prob=0.5)

# can calculate for a vector of values
pbinom(c(3,7), size=10, prob=0.5)
diff(pbinom(c(3,7), size=10, prob=0.5))

# 8.9 - calculating probs for continuous distributions

# calculate the distribution functions(DF) or cumulative distribution
# function for a continuous random variable.
#
# for continuous distributions P(X=x) does not exist.
#

# distribution	distribution function'
# normal	pnorm(x,mean,sd)
# students t	pt(x, df)
# exponential	pexp(x, rate)
# gamma		pgamme(x, shape, rate)
# chi-squared	pchisq(x, df)
#

# want P(X<=66) for X ~ N(mean=70, sd=3)
pnorm(66, mean=70, sd=3)

# probability of exponential variable with a mean of 40 has a 
# value less than 20.
pexp(20, rate=1/40)

# exponential P(20<X<50)
pexp(50, rate=1/40) - pexp(20, rate=1/40)

# 8.10 converting probs to quantiles
#
# given a probability p and a distribution, you want to determine
# quantile for p, that is, the value x s.t. P(X<=x) = p
#
qnorm(0.05, mean=100, sd=15)
qnorm(c(0.05,0.5,0.95,0.99,0.999), mean=100, sd=15)
pnorm(c(139,150,180,200), mean=100, sd=15)

# distribution	quantile function
# binomial	qbinom(p, size, prob)
# geometric	qgeom(p, prob)
# poisson	qpois(p, lambda)
#
# normal	qnorm(p, mean, sd)
# students t	qt(p, df)
# exponential	qexp(p, rate)
# gamma		qgamma(p, shape, rate=rate)
# 		or
#		qgamma(p, shape, scale=scale)
# chi-squared	qchisq(p, df)
#

# 8.11 - plotting density function

x = seq(from=-3, to=3, length.out=100)
plot(x, dnorm(x))

x11()
x = seq(from=0,to=6,length.out=100)

ylim=c(0,0.6)

par(mfrow=c(2,2))

plot(x, dunif(x,min=2,max=4), main="uniform",
        type='l', ylim=ylim)
plot(x, dnorm(x,mean=3,sd=1), main="normal",
        type='l', ylim=ylim)
plot(x, dexp(x,rate=1/4), main="exponential",
        type='l', ylim=ylim)
plot(x, dgamma(x,shape=2,rate=1), main="gamma",
        type='l', ylim=ylim)

x11()
x = seq(from=-3,to=3,length.out=100)
y = dnorm(x)

plot(x,y,main="standard normal distribution", type='l',
     ylab="density", xlab="quantile")
abline(h=0)

region.x = x[1<=x & x<=2]
region.y = y[1<=x & x<=2]

region.x = c(region.x[1], region.x, tail(region.x,1))
region.y = c(          0, region.y,               0)

polygon(region.x, region.y, density=-1, col="red")



