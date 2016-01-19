#
# 12.4 - summing rows or columns
#
# rowSums(m)
# colSums(m)
#

x = matrix(1:30, nrow=1, ncol=30)
x
y = matrix(1:30, nrow=30, ncol=1)
y

x = matrix(runif(80,min=1,max=10), nrow=16, ncol=5)
x

rowSums(x)

colSums(x)

rbind(x,totals=colSums(x))
cbind(x,totals=rowSums(x))

#
# 12.5 - printing data in columns
#

x = runif(80,min=1,max=10)
print(x)

y = runif(80,min=1,max=10)
print(y)

print(cbind(x,y,total=x+y))

#
# 12.6 - binning your data
#
# split data according to intervals.
#
# f < cut(x, breaks)
#

x <- rnorm(1000)

# this defines 6 intervals.
# -3 to -2, -2 to -1, -1 to 0, 0 to 1, 1 to 2, 2 to 3
breaks <- -3:3
f <- cut(x, breaks)

# this summary identifies the intervals as (-3,-2], (-2,-1].
# which means:
#
# -3 < x <= -2, -2 < x <= -1, etc.
#
summary(f)

# can assign labels to factors
f <- cut(x, breaks, labels=c("bottom","low","neg","pos","high","top"))
summary(f)

#
# 12.7 - finding the position for a particular value.
#
# use match(), or which.min() or which.max()
#

x = floor(rnorm(100,sd=30))
x

y = floor((x[50]+x[52])/2)
y

match(y,x)

which.min(x)
which.max(x)

#
# 12.8 - select every nth element of a vector.
#
# v[(seq_along(v) %% n ) == 0]

v = floor(rnorm(100,sd=30))
v

n=5
v[(seq_along(v) %% n ) == 0]

v[c(FALSE,TRUE)]
v[c(TRUE,FALSE)]

#
# 12.9 - finding pairwise minimums or maximums
#
# minimums for rows of values or maximums.
#

x1 = floor(rnorm(30,sd=50))
x2 = floor(rnorm(30,sd=50))
x3 = floor(rnorm(30,sd=50))

df = data.frame(x1=x1,
                x2=x2,
                x3=x3,
                pmin=pmin(x1,x2,x3),
                pmax=pmax(x1,x2,x3))
df




