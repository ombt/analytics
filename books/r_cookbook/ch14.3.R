library(zoo)
library(xts)
#
names(fcnts)
#
mysrc("count4.R")
#


#
# 14.2 - ptotting time series data
#
# plot(x)
#
# plot(v) or plot(v,type="l")
#

x11()
plot(zoo.1.1[,"TPickup"], screens=1)

x11()
plot(zoo.1.1[,c("TPickup","TErrors")], screens=c(1,2))

x11()
xlab="Time"
ylab=c("TPickup","TErrors")
main="Time vs (Pickups, Errors)"

lty=c("dotted","solid")
ylim=range(zoo.1.1[,c("TPickup","TErrors")])

plot(zoo.1.1[,c("TPickup","TErrors")], 
     screens=c(1,2),
     lty=lty,
     main=main,
     xlab=xlab,
     ylab=ylab,
     ylim=ylim)

x11()
plot(zoo.1.1[,c("TPickup","TErrors")], 
     screens=1,
     lty=lty,
     main=main,
     xlab=xlab,
     ylab="TPickup,TErrors")

#
# 14.4 - subsets of time series
#
# ts[i]
#
# ts[j,i]
#

fcnts[[1]][1,2:11]
fcnts[[1]][1,11]

names(fcnts2)

x1.1=fcnts2[["1.1"]]

head(x1.1[,"TIMESTAMP"])

x1.1[,"TIMESTAMP"]=as.POSIXct(x1.1[,"TIMESTAMP"],origin="1970-01-01")

head(x1.1[,"TIMESTAMP"])

data_fld_nms <- c("TPickup",
                  "TPMiss",
                  "TRMiss",
                  "TDMiss",
                  "THMiss",
                  "TRSMiss",
                  "TMMiss",
                  "TPlace",
                  "TErrors")

zoo11 <- zoo(fcnts2[["1.1"]][,data_fld_nms], 
             as.POSIXct(fcnts2[["1.1"]][,"TIMESTAMP"],
                        origin="1970-01-01"))

xts11 <- xts(fcnts2[["1.1"]][,data_fld_nms], 
             as.POSIXct(fcnts2[["1.1"]][,"TIMESTAMP"],
                        origin="1970-01-01"))

zoo21 <- zoo(fcnts2[["2.1"]][,data_fld_nms], 
             as.POSIXct(fcnts2[["2.1"]][,"TIMESTAMP"],
                        origin="1970-01-01"))

xts21 <- xts(fcnts2[["2.1"]][,data_fld_nms], 
             as.POSIXct(fcnts2[["2.1"]][,"TIMESTAMP"],
                        origin="1970-01-01"))

zoo31 <- zoo(fcnts2[["3.1"]][,data_fld_nms], 
             as.POSIXct(fcnts2[["3.1"]][,"TIMESTAMP"],
                        origin="1970-01-01"))

xts31 <- xts(fcnts2[["3.1"]][,data_fld_nms], 
             as.POSIXct(fcnts2[["3.1"]][,"TIMESTAMP"],
                        origin="1970-01-01"))

head(zoo11,n=2)
tail(zoo11,n=2)

head(xts11,n=2)
tail(xts11,n=2)


# this requires an exact match on the sequence time values.
pct.seq = seq(from=as.POSIXct("2013-08-30 02:50:56"), 
              to=as.POSIXct("2013-08-30 02:51:41"), 
              length.out=2)

xts11[pct.seq]
zoo11[pct.seq]

# this gives boundaries and reports all cases within
# the boundaries.
window(xts11,
       start=as.POSIXct("2013-08-30 02:00:00"), 
       end=as.POSIXct("2013-08-30 03:00:00"))

window(zoo11,
       start=as.POSIXct("2013-08-30 02:00:00"), 
       end=as.POSIXct("2013-08-30 03:00:00"))

#
# 14.5 - merging serveral time series
#
# use zoo and merge()
#

zoo.123.1 <- merge(zoo11, zoo21, zoo31)
zoo.123.1

# use last value seen "last observation carried forward")
zoo.123.1 <- na.locf(merge(zoo11, zoo21, zoo31))
zoo.123.1

# use intersection of times, not union
zoo.123.1 <- merge(zoo11, zoo21, zoo31, all=FALSE)
zoo.123.1

#
# 14.6 - filling or padding a time series
#
# empty <- zoo(,dates)
# merge(ts, empty, all=TRUE)
#

by.day <- seq(from=as.Date("2005-01-01"), 
              to=as.Date("2005-01-31"), 
              by=1)
head(by.day,n=2)
tail(by.day,n=2)

by.week <- seq(from=as.Date("2005-01-01"), 
               to=as.Date("2005-01-31"), 
               by=7)
head(by.week,n=2)
tail(by.week,n=2)

empty.day <- zoo(,by.day)
empty.day

vals.week <- zoo(1:5,by.week)
vals.week

merged.month <- merge(vals.week,empty.day,all=TRUE)
merged.month

merged.month <- na.locf(merge(vals.week,empty.day,all=TRUE))
merged.month






