#
# there are three R packages: ts, zoo and xts.
# ts is rather limited. zoo and xts are better.
#
# date vs datetime: doesn't matter which is used. you
# are dealing with a time series of values either way.
#

install_and_load("zoo")

install_and_load("xts")

x <- counts$TPickup
dt <- as.POSIXct(counts$TIMESTAMP, origin="1970-01-01")

suppressWarnings(zoo.ts <- zoo(x, dt))
head(zoo.ts)

xts.ts <- xts(x, dt)
head(xts.ts)

# for zoo, the vector of dates can be Date, POSIXct, integers
# or floating point numbers, 
# for xts, the vector of dates can be yearmon, yearqtr, dateTime
# objects.

prices <- c(132.45, 130.85, 129.55, 130.85)
dates <- as.Date(c("2010-01-04","2010-01-05","2010-01-06",
                  "2010-01-07","2010-01-08"))
ibm.daily <- zoo(prices, dates)
print(ibm.daily)

prices <- c(191.18, 131.20, 131.17, 131.15, 131.17)
seconds <- c(9.5,9.500378,9.500556,9.500833,9.501111)
ibm.secs <- zoo(prices, seconds)
print(ibm.secs)

#
# you can capture several time-series in a dataframe, then doing
# this:
#
# ts = zoo(dfrm, dt)
# or
# ts = xts(dfrm, dt)
#
# to exrract data:
#
# coredata(ibm.daily)
#
# index(ibm.daily)
#

x1 <- 1:5
x2 <- x1^2
dates <- as.Date(c("2010-01-04","2010-01-05","2010-01-06",
                    "2010-01-07","2010-01-08"))

dfrm <- data.frame(x1=x1,x2=x2)

zoo.ts <- zoo(dfrm, dates)
zoo.ts 

xts.ts <- xts(dfrm, dates)
xts.ts 

# 
# can also use timeSeries which is part of Rmetrics.
#
# > install_and_load("Rmetrics")
# Installing package into ‘/usr/lib/R/site-library’
# (as ‘lib’ is unspecified)
# Error in library("Rmetrics") : there is no package called ‘Rmetrics’
# In addition: Warning message:
# package ‘Rmetrics’ is not available (for R version 3.1.3) 
#

pickup <- counts$TPickup
place <- counts$TPlace
cnt.dfrm <- data.frame(pickup=pickup, place=place)

dt <- as.POSIXct(counts$TIMESTAMP, origin="1970-01-01")

suppressWarnings(zoo.counts.ts <- zoo(cnt.dfrm, dt))
head(zoo.counts.ts)

xts.counts.ts <- xts(cnt.dfrm$pickup, dt)
head(xts.counts.ts)

par(mfrow=c(1,2))
suppressWarnings(plot(zoo.counts.ts))

x11()
par(mfrow=c(1,2))
plot(xts.counts.ts)

x11()
plot(zoo.counts.ts,screens=c(2,1))

x11()
z.cnts.ts <- zoo.counts.ts[1:200,]
plot(z.cnts.ts,screens=c(2,1))

x11()
xlab="Date/Time"
ylab=c("Place","Pickup")
main="Pickup,Placement vs Time"
lty=c("dotted","solid")
ylim=range(coredata(z.cnts.ts))

plot(z.cnts.ts,
     screens=c(1,2),
     lty=lty,
     main=main,
     xlab=xlab,
     ylab=ylab,
     ylim=ylim)

x11()
plot(z.cnts.ts,
     screens=1,
     lty=lty,
     main=main,
     ylog=TRUE,
     xlab=xlab,
     ylab=ylab)


#
# 14.3 - extracting oldest and newest observations
#
# head(ts)
# tail(ts)

head(zoo.counts.ts)
tail(zoo.counts.ts)


