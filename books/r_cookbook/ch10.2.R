#
# 10.6 - plotting the regression line of a scatter plot
#
# create a model object, plot the (x,y) points, then plot
# model object using abline().
#
# m = lm(y ~ x)
# plot(y ~ x)
# abline(m)
#

# par(mfrow=c(1,2))

install_and_load("faraway")

data(strongx)
strongx

m = lm(crossx ~ energy, data=strongx)
m

plot(crossx ~ energy, data=strongx)

abline(m)

#
# 10.7 - plotting all variables against all other variables.
#
# plot(dfrm)
#
x11()
head(iris)
plot(iris[,1:4])

# 10.8 - create a scatter plot for each factor level.
#
# coplot(y ~ x | f)
#

install_and_load("MASS")
x11()
data(Cars93, package="MASS")
coplot(Horsepower ~ MPG.city | Origin, data=Cars93)

#
# 10.18 - creating a bar chart
#
# barplot(c(height, ..., heightN))
#
# airquality is part of the default datasets coming with R
#

x11()
heights = tapply(airquality$Temp, airquality$Month, mean)
barplot(heights,
        main="Mean Temp. by Month",
        names.arg=c("May","Jun","Jul","Aug","Sep"),
        ylab="Temp (F)")


#
# 10.10 - adding confidence intervals to a bar chart
#
# uses gplots package
#
# library(gplots)
# barplot2(x, plot.ci=TRUE, ci.l=lower, ci.u=upper)
#
# can use t.test to calculate confidence limits of means.
#
# 

x11()

install_and_load("gplots")

library(gplots)

attach(airquality)

heights = tapply(Temp, Month, mean)
lower = tapply(Temp, Month, function(v) t.test(v)$conf.int[1])
upper = tapply(Temp, Month, function(v) t.test(v)$conf.int[2])

barplot2(heights, 
         plot.ci=TRUE, ci.l=lower, ci.u=upper,
         ylim=c(50,90), xpd=FALSE,
         main="Mean Temp. by Month",
         names.arg=c("May","Jun","Jul","Aug","Sep"),
         ylab="Temp (F)")

detach()

#
# 10.11 - coloting a bar graph
#
# barplot(heights, col=colors)
#

x11()
par(mfrow=c(1,2))

barplot(c(3,5,4), col=c("red","white","blue"))

#
# gray-scale plot
#

attach(airquality)

heights = tapply(Temp, Month, mean)
rel.hts = rank(heights)/length(heights)

# invert the colors
grays = gray(1 - rel.hts)

barplot(heights, col=grays)

detach()






