#
# chapter 10 - graphics
#
# high level plot functions start a plot, create a window
# if necessary:
#
# plot - generic plotting
# boxplot - create a box plot
# hist - create a histgram
# qqnorm = create a quantile plot (Q-Q).
# curve - graph a function
#
# low level graphics functions add to existing graphs/plots.
#
# points - add points
# lines - add lines
# abline - add a straight line
# segments - add line segment
# polygon - add a closed polygon
# text - add text
#
# other graphics packages - 
#
# lattice package
# ggplot2 package
#

# 10.1 - scatter plot of points
#
# plot(x,y)
#
# plot(dfrm)
#
# plot(car) - example of a plotting a dataframe
#

par(mfrow=c(1,2))

x = rexp(100, rate=1/3)
y = rexp(100, rate=1/4)

plot(x,y)

xy = data.frame(x=x, y=y)

plot(xy)

# 10.2 - adding a title and labels
#
# call plot and use parameters:
#
# main = title
# xlab = x-axis label
# ylab = y-axis label

x11()
par(mfrow=c(1,2))

plot(xy, main="x vs y", xlab = "exp(x/3)", ylab="exp(y/4)")

plot(cars,
     main="cars: speed vs. stopping distances (1920)",
     xlab="speed (mph)",
     ylab="stopping distance (ft)")

# 10.3 - adding a grid
#
# call plot with type="n" to init the graph and not show the data.
# call grid() to draw the grid.
# call low-level functions like points() and lines() to draw
# the graphics over the grid.
#

x11()
par(mfrow=c(1,2))

plot(x,y, type="n")
grid()
points(x,y)

plot(cars,
     type="n",
     main="cars: speed vs. stopping distances (1920)",
     xlab="speed (mph)",
     ylab="stopping distance (ft)")
grid()
points(cars)

# 10.4 - scatter plot of multiple groups
#
# want to plot x,y points distinguished by factors
#
# 

x11()
par(mfrow=c(1,2))

plot(x,y)

x = sort(rexp(100, rate=1/2))
y = sort(rexp(100, rate=1/3))
f = ifelse(runif(100, min=0, max=1) > 0.5, "red", "blue")
xyf = data.frame(x=x, y=y, f=f)
xyf$f = as.factor(xyf$f)
plot(xyf$x, xyf$y, pch=as.integer(xyf$f))


x11()
par(mfrow=c(1,2))

with(iris, plot(Petal.Length, Petal.Width))
with(iris, plot(Petal.Length, Petal.Width, pch=as.integer(Species)))

# 10.5 - add a legend
#
# after calling plot, then call legend. here's how{
#
# legend for points:
#    legend(x,y,labels,pch=c(pointtype1, pointtype2, ...))
#
# legend for lines:
#    legend(x,y,labels,lty=c(linetype1, linetype2, ...))
#
# legend for lines according to line width:
#    legend(x,y,labels,lwd=c(width1, width2, ...))
#
# legend for colors:
#    legend(x,y,labels,col=c(color1, color2, ...))

x11()
par(mfrow=c(1,2))

f <- as.factor(iris$Species)

with(iris, plot(Petal.Length, Petal.Width, pch=as.integer(Species)))
legend(1.5, 2.4, as.character(levels(f)), pch=1:length(levels(f)))

with(iris, plot(Petal.Length, Petal.Width, pch=as.integer(Species)))
legend(0.5, 95, c("estimate", "lower conf limit", "upper conf limit",
       lty=c("solid","dashed","dotted")))


