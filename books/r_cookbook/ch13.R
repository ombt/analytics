#
# 13.1 - finding minumum or maximum of a single-parameter
# function.
#
# optimize(f, lower=lowerBound, upper=upperBound)
# optimize(f, lower=lowerBound, upper=upperBound, maximum=TRUE)

f <- function(x) 3*x^4-2*x^3+3*x^2-4*x+5

optimize(f, lower=-20, upper=20)
optimize(f, lower=-20, upper=20, maximum=TRUE)

#
# 13.2 - minimizing or maximizing a multiparameter function
#
# minimizing:
# optim(startingpoint, f)
#
# maximizing:
# optim(startingpoint, f, control=list(fnscale=-1))
#

f <- function(v) {
	a <- v[1]
	b <- v[2]
	sum(abs(z - ((x+a)^b)))
}

x <- -100:100
z <- x^2

optim(c(1,1), f)

# you can choose different search routines.

#
# 13.4 - performing principal component analysis
#
# r <- prcomp( ~ x + y + z)
#
# summary(r)
#
# two functions exist prcomp() and princomp(). prcomp()
# is the preferred method. use prcomp().
#

u <- 1:200
v <- (1:200) - 100
w <- (1:200) + 200

y <- u + 2*v*v + 3*w*w*w

r <- prcomp( ~ u + v + w + y)

print(r)

summary(r)

# plot(r)

#
# 13.5 - performing simple orthogonal regression
#
# create linear model using orthogonal regression where the
# variances of x and y are treated symetrically.
#
# usual linear regression minimizes the vertical distance
# from the y to the calulated value at x. if we reverse x and y,
# then we minimized the horizontal distance. the current
# method minimizes the distance to a line.
#
# r <- prcomp( ~ x + y)
# slope <- r$rotation[2,1] / r$rotation[1,1]
# intercept <- r$center[2] - slope*r$center[1]
#

#
# 13.6 - finding clusters in your data
#
# identify data points which are near to each other.
#
# d <- dist(n)             # compute distance between observations
# hc <- hclust(d)          # form hierarchical clusters
# clust <- cutree(hc, k=n) # organize into n largest clusters
# 
# dist() by default uses the euclidean distance, other options
# are available.
#
# hclust() calculates the clusters,
#
# cutree() pulls out the clusters.
#

means <- sample(c(-3,0,+3), 99, replace=TRUE)
x <- rnorm(99, mean=means)

tapply(x, factor(means), mean)

d <- dist(x)

hc <- hclust(d)

clust <- cutree(hc, k=3)

tapply(x, clust, mean)

par(mfrow=c(1,2))

plot(x ~ factor(means), 
     main="original clusters",
     xlab="cluster mean")
plot(x ~ factor(clust),
     main="identified cluster",
     xlab="cluster number")

#
# 13.7 - predicting a binary-valued variable (logistic regression)
#
# a regression model that predicts the probability of a binary event 
# occurring.
#
# call glm() with family=binomial to perform logistic regression. the 
# result is a model object.
#
# m <- glm(b ~ x1 + x2 + x3, family=binomial)
#
# here b is a factor with two levels (true or false, 0 or 1)
# and x1, x2, x3 are predictor variables
#
# use the model object, m, and the predict function to predict
# probability from new data.
#
# dfrm = data.frame(x1=value, x2=value, x3=value)
# predict(m, type="response", newdata=dfrm)
#

data(pima, package="faraway")

b <- factor(pima$test)

m <- glm(b ~ diastolic + bmi, family=binomial, data=pima)

summary(m)

# since only bmi is significant, then create a reduced model
# using only bmi.

m.red <- glm(b ~ bmi, family=binomial, data=pima)

newdata <- data.frame(bmi=32.0)
predict(m.red, type="response", newdata=newdata)

newdata <- data.frame(bmi=quantile(pima$bmi, 0.90))
predict(m.red, type="response", newdata=newdata)

#
# 13.8 - bootstrapping a statistic
#
# you have a data set and a function to calculate a statistic 
# for the data set. you want to estimate the confidence interval
# for the statistic,
#
# use the boot package. apply boo function to calculate replicates
# of the statistic.
#
# library(boot)
# bootfun <- function(data, indices) { ... ; return(statistic); }
# reps <- boot(data, bootfun, R=999)
#
# boot.ci(reps, type=c("perc","bca"))
#

#
# 13.9 - factor analysis
#
# want to perform a factor analysis on a data set to what the
# variables have in common.
#
# factanal(data, factors=n)
#
# 
