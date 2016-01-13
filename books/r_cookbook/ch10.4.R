#
# 10.18 - create a histogram
#
# hist(v) - v is a vector of values
#


v = exp(seq(from=0,to=2,length.out=100))-1
hist(v)

x11()
par(mfrow=c(1,2))

data(Cars93, package="MASS")

hist(Cars93$MPG.city)
hist(Cars93$MPG.city, 20, main="City MPG (1993)", xlab="MPG")

#
# 10.19 - adding a density estimate to a histogram
#
# hist(x, prob=TRUE) # use probability scale
# lines(density(x))
#

x11()
par(mfrow=c(1,3))

samp = rgamma(500, 2, 2)
hist(samp, 10, prob=T)

# density smoothly fits the data
lines(density(samp))

#
# 10.20 - creating a discrete histogram
#
# plot(table(x), type="h")
#
x = c(1,2,3,4,5,5,3,2,5,5,5,7,7,7,8,8,8,9,10)

plot(table(x), type="h", lwd=5, ylab="freq")
plot(table(x)/length(x), type="h", lwd=5, ylab="freq")

#
# 10.21 - creating a normal quantile-quantile (Q-Q) plot
#
# qnorm(x)
# qqline(x)
#

x11()
par(mfrow=c(1,2))

data(Cars93, package="MASS")

qqnorm(Cars93$Price, main="Q-Q Plot: price")
qqline(Cars93$Price)

qqnorm(log(Cars93$Price), main="Q-Q Plot: log(price)")
qqline(log(Cars93$Price))

#
# 10.22 - creating other Q-Q plots
# 
# want a Q-Q plot of data, but the data are not normal.
#
# need to have some idea of the underlying distribution.
#
# procedure:
#
# use ppoints() to generate a sequence of points from 0 to 1.
# transform these points to quantiles using the quantile function
# for the assumed distribution.
# sort the sample data.
# plot the sorted data against the computed quantiles.
# use abline() to plot the diagonal line.
#
# this example assumes the distribution is student's T distribution.
# quantile function for T distribution is qt.
#
# plot(qt(ppoints(y),5), sort(y))
# abline(a=0,b=1)
#

x11()
par(mfrow=c(1,2))

N <- 100
RATE <- 1/10
y <- rexp(N, RATE)

sum(ppoints(y))

plot(qexp(ppoints(y), rate=RATE), sort(y))
abline(a=0, b=1)

plot(qexp(ppoints(y), rate=RATE), sort(y),
     main="Q-Q Plot", 
     xlab="Theoretical Quantiles", 
     ylab="Sample Quantiles")
abline(a=0, b=1)


#
# 10.23 - plotting a variable in multiple colors
#
# use plot(..., col="some color")
# use plot(..., col=c(colors))
#

x11()
par(mfrow=c(1,2))

x = runif(50, min=-1, max=1)

colors = ifelse(x >= 0, "red", "blue")

plot(x, type="h", lwd=3, col=colors)
abline(h=0)

# cannot use vectorof colors for lines. the first color
# is chosen and the remaining ones are ignored.
#

#
# 10.24 - graphing a function
#
# use curve(...)
#
# curve(sin, -3, 3)
#

x11()
par(mfrow=c(1,2))

curve(dnorm, -3.5, 3.5, main="Std. Normal Density")

f <- function(x) { exp(-abs(x))*sin(2*pi*x) }
curve(f, -5, +5, main="Dampened Sine Wave")

#
# 10.25 - pausing between plots
#
# pausing between plots
#
# par(ask=TRUE)
# to enable
#
# par(ask=FALSE)
# to disable
#

#
# 10.26 - displaying several figures on one page.
#
# par(mfrow=c(N,M))
# graphs are filled by row.
# or
# par(mfcol=c(N,M))
# graphs are filled by column.
#

#
# 10.27 - opening addition graphics windows
#
# win.graph()
#
# win.graph(width=7.0, height=5.5)
#

#
# 10.28 - writing your plot to a file.
#
# savePlot(filename="filename.ext", type="some type")
#
# common types are "jpeg" and "png".
#
# in batch scripts, do this:
#
# png() or jpeg()
# plot(...)
# dev.off() 
#
#
# png("myPlot.png", width=600, height=400)
# plot(x,y, main="Scatter plot of X, Y")
# dev.off()
#

#
# 10.29 - change graphical paramters
#
# par(...)
#
# parameters are:
#
# ask=TRUE or FALSE
# bg="some color:"
# cex=number
# col="some color"
# fg="some color"
# lty="line type"
# lwd=number, 1=normal, 2=thicker, 3=even thicker, etc.
# mfcol=c(N,M) or
# mfrow=c(N,M)
# new=TRUE or FALSE
# pch=point type
# xlog=TRUE or FALSE
# ylog=TRUE or FALSE
#

