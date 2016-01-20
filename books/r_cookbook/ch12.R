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

#
# 12.10 - generating all combinations of several factors
#
# expand.grid(f,g)
#

sides = factor(c("heads","tails"))
faces = factor(c("1 pip", paste(2:6, "pips"))) 

expand.grid(faces, sides)
expand.grid(sides, sides)
expand.grid(faces, faces)

#
# flattening a data frame
#
# as.matrix(dfrm)
#
# mean(as.matrix(dfrm)
#

x = floor(rnorm(12,sd=30))
y = floor(rnorm(12,sd=30))
z = floor(rnorm(12,sd=30))

(d = data.frame(x=x,y=y,z=z))

mean(as.matrix(d))

#
# 12.12 - sorting a data frame
#
# dfrm = dfrm[order(dfrm$key),]
#

n=20

x = floor(rnorm(n,mean=100,sd=30))
x

y[1:n] = NA

x>=130
y[x>=130]
y[x>=130] = ">=1sigma";
y

x<=70
y[x<=70]
y[x<=70] = "<=-1sigma";
y

!((x<=70) | (x>=130))
y[!((x<=70) | (x>=130))]
y[!((x<=70) | (x>=130))] = "middle"
y

d = data.frame(x=x, y=y)
d$y = as.factor(d$y)
d

d=d[order(d$y),]
d

#
# 12.13 - sorting by two or more columns.
#
# dfrm = dfrm[order(dfrm$key1,dfrm$key2),]
#

#
# 12.14 srtipping attributes from a variable
#
# to remove all attributes:
#
# attributes(v) = NULL
#
# to remove a specific attribute:
#
# attr(v, "attributeName") = NULL

x = 1:20
y = 3*x

m = lm(y ~ x)

slope = coef(m)[2]
slope

attributes(slope) = NULL
slope

slope = coef(m)[2]
slope

attr(slope, "names") = NULL
slope

# 
# 12.15 - revealing the structure of an object.
#
# class(x)
# mode(x)
# str(x)
#

x = 1:20
y = 3*x
m = lm(y ~ x)

print(m)

class(m)

mode(m)

names(m)

m$coefficients

str(m)

#
# 12.16 - timing your code
#
# performance measures for executed code.
#
# system.time(...)
#

testfunc <- function(n) { sum(rnorm(n)) }

for (n in 2:7)
{
    print(paste("10^n is", 10^n))
    print(system.time(testfunc(10^n)))
}

#
# 12.17 - suppress warnings and error messages
#
# suppressMessage(annoyingFunction())
#
# suppressWarnings(annoyingFunction())
#

#
# 12.18 - taking function arguments from a list.
#
# do.call(function, list)
#

vec = c(1,3,5,7,9)
mean(vec)

numbers = list(1,3,5,7,9)
# does not work
# mean(numbers)

mean(unlist(numbers))

lists = list(col1=c(7,8,9), 
             col2=c(70,80,90),
             col2=c(700,800,900))

cbind(lists)

cbind(unlist(lists))

do.call(cbind, lists)

# the same as ...
cbind(lists[[1]], lists[[2]], lists[[3]])

#
# 12.19 - defining your binary operators
#
# any %...% where ... is any text can be assigned
# a two-argument function. 
#

"%+-%" <- function(x,margin) x + c(-1,1)*margin

100 %+-% 14

"%+%" <- function(s1,s2) paste(s1,s2,sep="")

"hello" %+% "world"

# be carefull wih precedence!
# all user-defined operators have the same precedence.
# higher than multiplication and division, but less than
# exponentiation and sequence creattion.
#

100 %+-% 2*15
100 %+-% (2*15)






