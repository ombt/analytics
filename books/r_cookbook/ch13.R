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

