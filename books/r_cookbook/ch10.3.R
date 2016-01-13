#
# 10.12 - plotting a line through (x,y) points
#
# plot(x,y,type="l")
#
# if the data is stored in a 2-column dataframe, then you 
# can do this:
#
# plot(dfrm, type="l")
#
par(mfrow=c(1,3))
plot(pressure)
plot(pressure, type="l")
plot(pressure, type="l")
points(pressure)

#
# 10.13 - changing line type, width, or color.
#
# line type:
#
# lty="solid" or lty=1 (default)
# lty="dashed" or lty=2
# lty="dotted" or lty=3
# lty="dotdash" or lty=4
# lty="longdash" or lty=5
# lty="twodash" or lty=6
# lty="blank" or lty=0 (no drawing)
#
# line width:
#
# lwd to set line width
#
# color:
#
# col to set colors

x = 1:25
y = x*x

x11()
par(mfrow=c(1,4))

plot(x,y, type="l", lwd=2, lty="dotdash")

plot(x,y, type="l", lty="dotdash")

plot(x,y, type="l", lwd=2, lty="dotdash")

plot(x,y, type="l", lwd=2, lty="dotdash", col="green")

#
# 10.14 - plotting multiple data sets.
#
# initialize plot with plot or curve, then add addtional
# data using line() or points()
#

x11()
par(mfrow=c(1,4))

x1 = 1:15
y1 = x1*x1

x2 = 5:20
y2 = 2*x2*x2+5

xlim = range(c(x1, x2))
ylim = range(c(y1, y2))

plot(x1, y1, type="l", xlim=xlim, ylim=ylim, col="green")
lines(x2, y2, xlim=xlim, ylim=ylim, col="red")

# plotting points are the same problem

plot(x1, y1, type="p", xlim=xlim, ylim=ylim, col="green")
points(x2, y2, xlim=xlim, ylim=ylim, col="red")

plot(x1, y1, type="l", xlim=xlim, ylim=ylim, col="green")
lines(x2, y2, xlim=xlim, ylim=ylim, col="red")
points(x1, y1, type="p", xlim=xlim, ylim=ylim, col="red")
points(x2, y2, xlim=xlim, ylim=ylim, col="green")

#
# 10.15 - adding vertical or horizontal lines
#
# abline(v=x) for vertical line
# or
# abline(h=y) for horizontal line
#
# use to draw the axes through origin
#
# abline(v=0)
# abline(h=0)
#

x = -5:5
y = x*x*x

xlim = range(x)
ylim = range(y)

plot(x, y, type="l", xlim=xlim, ylim=ylim, col="green")
points(x, y, xlim=xlim, ylim=ylim, col="red")
abline(v=0)
abline(h=0)

#
# 10.16 - create a boxplot
#
# use boxplot(x)
#

x11()
par(mfrow=c(1,3))

x = c(5^3, (1:5)^2)
boxplot(x)

#
# 10.17 - create one box plot for each factor level.
#
# boxplot(x ~ f)
#

data(UScereal, package="MASS")
UScereal
names(UScereal)

boxplot(sugars ~ shelf, 
        data=UScereal,
        main="Sugar Content by Shelf",
        xlab="Shelf",
        ylab="Sugar (grams per portion)")


