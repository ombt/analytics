read_count_csv <- function(file="count.csv")
{
    read.table(file=file,
               header=TRUE,
               sep=";",
               stringsAsFactors=FALSE)
}

sort_count_csv <- function(cnts)
{
    cnts[order(cnts$MACHINE, 
               cnts$LANE, 
               cnts$STAGE,
               cnts$TIMESTAMP),]
}

unsorted.counts <- read_count_csv()

attach(unsorted.counts)
TErrors <- TPMiss+TRMiss+TDMiss+THMiss+TRSMiss+TMMiss
TPlace  <- TPickup-TErrors
detach()

counts <- sort_count_csv(cbind(unsorted.counts,TPlace,TErrors))

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


#
# read in CSV file
#
read_count_csv <- function(file="count.csv")
{
    read.table(file=file,
               header=TRUE,
               sep=";",
               stringsAsFactors=FALSE)
}

#
# > names(counts)
# [1] "MACHINE"   "LANE"      "STAGE"     "PRODUCT"   "TIMESTAMP" "FID" 
# [7] "FNAME"     "OUTPUT"    "SERIAL"    "PRODUCTID" "TPickup"   "TPMiss"
# [13] "TRMiss"    "TDMiss"    "THMiss"    "TRSMiss"   "TMMiss"    "TPlace"
#
sort_count_csv <- function(cnts)
{
    cnts[order(cnts$MACHINE, 
               cnts$LANE, 
               cnts$STAGE,
               cnts$TIMESTAMP),]
}

#
# write sorted count data frame to a csv file
#
write_sorted_count_csv <- function(scnts, file="sorted.counts.csv")
{
    write.table(scnts, 
                file=file, 
                quote=FALSE, 
                row.names=FALSE,
                col.names=TRUE,
                sep=";")
}

#
# processing to create time series
#
cnts <- 
    read_count_csv()

attach(cnts)
TErrors = TPMiss+TRMiss+TDMiss+THMiss+TRSMiss+TMMiss
TPlace = TPickup-TErrors
detach()

sorted.cnts <- 
    sort_count_csv(cbind(cnts,TPlace,TErrors))

write_sorted_count_csv(sorted.cnts)

grouped.sorted.cnts <- 
    split(sorted.cnts, 
          list(sorted.cnts$MACHINE,
               sorted.cnts$LANE,
               sorted.cnts$STAGE,
               sorted.cnts$PRODUCT))

nonzero.grouped.sorted.cnts <-
    grouped.sorted.cnts[as.vector(lapply(grouped.sorted.cnts, 
                                         nrow)) > 0]

lapply(nonzero.grouped.sorted.cnts, nrow)

nz.grp.scnts <- nonzero.grouped.sorted.cnts

# x11()
# par(mfrow=c(5,2))
# 
# for (i in 1:10)
# {
#     cntsi <- nz.grp.scnts[[i]]
# 
#     errsi <- cntsi$TErrors - min(cntsi$TErrors)
# 
#     ie <- seq_along(errsi)
#     ip1e <- seq_along(errsi)+1
# 
#     ie <- ie[-length(ie)]
#     ip1e <- ip1e[-length(ip1e)]
# 
#     derrsi = errsi[ip1e] - errsi[ie]
#     derrsi
#     sum(derrsi)
# 
#     plot(1:length(derrsi), derrsi)
# }

copy_only_flds <- c("MACHINE",
                    "LANE",
                    "STAGE",
                    "PRODUCT",
                    "TIMESTAMP",
                    "FID",
                    "FNAME",
                    "OUTPUT",
                    "SERIAL",
                    "PRODUCTID")

calculate_flds <- c("TPickup",
                    "TPMiss",
                    "TRMiss",
                    "TDMiss",
                    "THMiss",
                    "TRSMiss",
                    "TMMiss",
                    "TPlace",
                    "TErrors")

fcnts <- nz.grp.scnts

lapply(fcnts,nrow)

for (name in names(fcnts))
{
    orig_nrow     <- nrow(fcnts[[name]])

    assign_seq_no <- 1:(orig_nrow-1)
    higher_seq_no <- 2:orig_nrow
    lower_seq_no  <- 1:(orig_nrow-1)

    for (fld in copy_only_flds)
    {
        fcnts[[name]][assign_seq_no,fld] <-
            fcnts[[name]][higher_seq_no,fld]
    }

    for (fld in calculate_flds)
    {
        fcnts[[name]][assign_seq_no,fld] <-
            fcnts[[name]][higher_seq_no,fld] -
            fcnts[[name]][lower_seq_no,fld]
    }

    fcnts[[name]] <- fcnts[[name]][-orig_nrow,]
}

lapply(fcnts,nrow)


library(zoo)
library(xts)
#
# 14.3 - extracting oldest and newest observations
#
# head(ts)
# tail(ts)

pickup <- counts$TPickup
place <- counts$TPlace
cnt.dfrm <- data.frame(pickup=pickup, place=place)

dt <- as.POSIXct(counts$TIMESTAMP, origin="1970-01-01")

suppressWarnings(zoo.counts.ts <- zoo(cnt.dfrm, dt))
head(zoo.counts.ts)

xts.counts.ts <- xts(cnt.dfrm$pickup, dt)
head(xts.counts.ts)

head(zoo.counts.ts)
tail(zoo.counts.ts)

first(xts.counts.ts, "5 minutes")
last(xts.counts.ts, "5 minutes")
last(xts.counts.ts, "6 minutes")


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






library(zoo)
library(xts)

#
# read in csv files
#
read_count_csv <- function(file="count.csv")
{
    read.table(file=file,
               header=TRUE,
               sep=";",
               stringsAsFactors=FALSE)
}

#
# > names(counts)
# [1]  "MACHINE"   "LANE"      "STAGE"     "PRODUCT"   "TIMESTAMP" "FID" 
# [7]  "FNAME"     "OUTPUT"    "SERIAL"    "PRODUCTID" "TPickup"   "TPMiss"
# [13] "TRMiss"    "TDMiss"    "THMiss"    "TRSMiss"   "TMMiss"    "TPlace"
#
sort_count_csv <- function(cnts)
{
    cnts[order(cnts$MACHINE, 
               cnts$LANE, 
               cnts$STAGE,
               cnts$TIMESTAMP),]
}

#
# processing to create time series
#
# read in raw data
#
cnts <- 
    read_count_csv()

#
# calculate placement and total error counts
#
attach(cnts)
TErrors = TPMiss+TRMiss+TDMiss+THMiss+TRSMiss+TMMiss
TPlace = TPickup-TErrors
detach()

#
# create final raw data 
#
scnts <- 
    sort_count_csv(cbind(cnts,TPlace,TErrors))

#
# group data by factors: machine, lane (stage is always 1)
#
grp.scnts <- 
    split(scnts, 
          list(scnts$MACHINE,
               scnts$LANE))
#
# remove any factor combination with NO data.
#
nz.grp.scnts <-
    grp.scnts[as.vector(lapply(grp.scnts, nrow)) > 0]

lapply(nz.grp.scnts, nrow)

#
# create a data frame with delta'ed data.
#
copy_only_flds <- c("MACHINE",
                    "LANE",
                    "STAGE",
                    "PRODUCT",
                    "TIMESTAMP",
                    "FID",
                    "FNAME",
                    "OUTPUT",
                    "SERIAL",
                    "PRODUCTID")

calculate_flds <- c("TPickup",
                    "TPMiss",
                    "TRMiss",
                    "TDMiss",
                    "THMiss",
                    "TRSMiss",
                    "TMMiss",
                    "TPlace",
                    "TErrors")

all_flds <- c("MACHINE",
              "LANE",
              "STAGE",
              "PRODUCT",
              "TIMESTAMP",
              "FID",
              "FNAME",
              "OUTPUT",
              "SERIAL",
              "PRODUCTID",
              "TPickup",
              "TPMiss",
              "TRMiss",
              "TDMiss",
              "THMiss",
              "TRSMiss",
              "TMMiss",
              "TPlace",
              "TErrors")

delta.cnts <- nz.grp.scnts
total.cnts <- nz.grp.scnts

lapply(delta.cnts, nrow)

for (name in names(delta.cnts))
{
    orig_nrow     <- nrow(delta.cnts[[name]])

    assign_seq_no <- 1:(orig_nrow-1)
    higher_seq_no <- 2:orig_nrow
    lower_seq_no  <- 1:(orig_nrow-1)

    for (fld in copy_only_flds)
    {
        delta.cnts[[name]][assign_seq_no,fld] <-
            delta.cnts[[name]][higher_seq_no,fld]
    }

    for (fld in calculate_flds)
    {
        delta.cnts[[name]][assign_seq_no,fld] <-
            delta.cnts[[name]][higher_seq_no,fld] -
            delta.cnts[[name]][lower_seq_no,fld]
    }

    delta.cnts[[name]] <- delta.cnts[[name]][-orig_nrow,]

    for (fld in all_flds)
    {
        total.cnts[[name]][assign_seq_no,fld] <-
            total.cnts[[name]][higher_seq_no,fld]
    }

    total.cnts[[name]] <- total.cnts[[name]][-orig_nrow,]
}

lapply(delta.cnts,nrow)
lapply(total.cnts,nrow)

data_fld_nms <- c("TPickup",
                  "TPMiss",
                  "TRMiss",
                  "TDMiss",
                  "THMiss",
                  "TRSMiss",
                  "TMMiss",
                  "TPlace",
                  "TErrors")

zoo.delta.1.1 <- zoo(delta.cnts[["1.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["1.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.delta.2.1 <- zoo(delta.cnts[["2.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["2.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.delta.3.1 <- zoo(delta.cnts[["3.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["3.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.delta.4.1 <- zoo(delta.cnts[["4.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["4.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.delta.5.1 <- zoo(delta.cnts[["5.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["5.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.delta.1.1 <- xts(delta.cnts[["1.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["1.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.delta.2.1 <- xts(delta.cnts[["2.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["2.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.delta.3.1 <- xts(delta.cnts[["3.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["3.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.delta.4.1 <- xts(delta.cnts[["4.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["4.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.delta.5.1 <- xts(delta.cnts[["5.1"]][,data_fld_nms], 
                     as.POSIXct(delta.cnts[["5.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.total.1.1 <- zoo(total.cnts[["1.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["1.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.total.2.1 <- zoo(total.cnts[["2.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["2.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.total.3.1 <- zoo(total.cnts[["3.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["3.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.total.4.1 <- zoo(total.cnts[["4.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["4.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
zoo.total.5.1 <- zoo(total.cnts[["5.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["5.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.total.1.1 <- xts(total.cnts[["1.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["1.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.total.2.1 <- xts(total.cnts[["2.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["2.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.total.3.1 <- xts(total.cnts[["3.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["3.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.total.4.1 <- xts(total.cnts[["4.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["4.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
xts.total.5.1 <- xts(total.cnts[["5.1"]][,data_fld_nms], 
                     as.POSIXct(total.cnts[["5.1"]][,"TIMESTAMP"],
                                origin="1970-01-01"))
 
#
# 14.7 - lagging a time series 
#
# lag(ts,k)
#

lag(xts.total.1.1, lag=5)
lag(xts.total.1.1, lag=5, na.pad=TRUE)

lag(xts.total.1.1, lag=-5)
lag(xts.total.1.1, lag=-5, na.pad=TRUE)

#
# 14.8 - computing successive differences
#
# diff(ts)
#

diff(xts.total.1.1)
diff(xts.total.1.1,lag=2)
diff(xts.total.1.1,lag=5)

#
# 14.9 - performing calculations on time series.
#

diff(xts.total.1.1[,1])/xts.total.1.1[,1]

m11=mean(xts.delta.1.1[,1])
sd11=sd(xts.delta.1.1[,1])

xts.delta.1.1[xts.delta.1.1[,1]>(m11+2*sd11),1]

exp(xts.delta.1.1[xts.delta.1.1[,1]>(m11+2*sd11),1])

diff(log(xts.delta.1.1[,1]))

#
# 14.10 - compute a moving average
#
# library(zoo)
# ma <- rollmean(ts, k)
#

ma <- rollmean(xts.total.1.1[,1],k=5)
head(ma,n=10)

#
# 14.11 - applying a function by calendar period
#
# apply.daily(ts, f)
# apply.weekly(ts, f)
# apply.monthly(ts, f)
# apply.quarterly(ts, f)
# apply.yearly(ts, f)
#

ibm.daily=read_csv_file(".","IBM.daily.csv",separator=",")

head(ibm.daily, n=10)

plot.dates = dates=seq(from=as.Date("2005-02-01"),
                       to=as.Date("2005-03-01"),
                       by=1)
plot.dates

# remove first column, the date
names(ibm.daily)
ibm.cols = names(ibm.daily)[-1]

zoo.ibm.daily <- zoo(ibm.daily[,ibm.cols], 
                     as.POSIXct(ibm.daily[,"Date"],
                                origin="1970-01-01"))

# head(apply.daily(zoo.ibm.daily, mean), n=10)
head(apply.weekly(zoo.ibm.daily, mean), n=10)
head(apply.monthly(zoo.ibm.daily, mean), n=10)
head(apply.quarterly(zoo.ibm.daily, mean), n=10)
head(apply.yearly(zoo.ibm.daily, mean), n=10)

#
# 14.12 - apply a rolling function
#
# library(zoo)
# rollapply(ts, width, f)
# rollapply(ts, width, f, align="right")
#

# rollapply(zoo.ibm.daily, 10, mean, align="right")

d20050201_20050501 = seq(from=as.Date("2005-02-01"),
                         to=as.Date("2005-05-01"),
                         by=1)

rollapply(window(zoo.ibm.daily,
                 start=as.POSIXct("2005-02-01"),
                 end=as.POSIXct("2005-05-01")),
          10, 
          mean, 
          align="right")

#
# 14.13 - plotting auto-correlation fcuntion
#
# acf(ts)
#

ts.ibm.open.daily <- ts(ibm.daily[,"Open"], 
                        start=as.Date(ibm.daily[1,"Date"]))
x11()
acf(ts.ibm.open.daily)

#
# 14.14 - testing a series for autocorrelation
# 
# Box.test(ts)

# p-value < 0.05 means autocorrelations exist
Box.test(ts.ibm.open.daily)

# for small samples, use this:
Box.test(ts.ibm.open.daily, type="Ljung-Box")

#
# 14.15 - plotting partial autocorrelation function
#
x11()
# lag k=1 and k=2 are significant. ARIMA model would start
# with 2 AR coefficients.
#
pacf(ts.ibm.open.daily)

#
# 14.16 - finding lagged correlations between two time series
#
# you have two time series and want to determine if there
# lagged correlations between them
#
ts.ibm.high.daily <- ts(ibm.daily[,"High"], 
                        start=as.Date(ibm.daily[1,"Date"]))

ccf(ts.ibm.open.daily, ts.ibm.high.daily, main="IBM: Open vs High")

cor(ts.ibm.open.daily, ts.ibm.high.daily)

#
# 14.17 - detrending a time series
#
# time series contains a trend that you want removed.
#

m <- lm(coredata(ts.ibm.open.daily) ~ index(ts.ibm.open.daily))
m

detr <- zoo(resid(m), index(ts.ibm.open.daily))
detr

x11()
par(mfrow=c(1,2))
plot(ts.ibm.open.daily)
plot(detr)

#
# 14.18 - fitting an ARIMA model
#
# want to fit an ARIMA model to a time series
#
# library(forecast)
# auto.arima(x)
#
# or if parameters are known, p,d,q, then:
#
# arima(x, order=c(p,d,q))
#

library(forecast)
auto.arima(ts.ibm.open.daily)
m <- arima(ts.ibm.open.daily, order=c(1,1,1))
confint(m)

#
# 14.19 - removing insignificant ARIMA coefficients
#
# arima(x, order=c(2,1,2), fixed=c(0,NA,o,NA))
#
m <- arima(ts.ibm.open.daily, order=c(1,1,1), fixed=c(NA,0))
confint(m)

#
# 14.20 - running diagnostics in an ARIMA model
#
# m <- arima(ts.ibm.open.daily, order=c(1,1,1), fixed=c(NA,0), transform=.pars=FALSE)
# tsdiag(m)
m <- arima(ts.ibm.open.daily, 
           order=c(1,1,1), 
           fixed=c(NA,0), 
           transform.pars=FALSE)
#
# 3 graphs are displayed. these are good things:
#
# standardized residuals do not show clusters of volatility
# autocorrelation shows no significant autocorrelation with the residuals
# p-values for ljung-box test are large. this means only noise is
# left in the residuals.
#
tsdiag(m)


#
# 14.21 - making forecasts from an ARIMA model.
#
m <- arima(ts.ibm.open.daily, 
           order=c(1,1,1), 
           fixed=c(NA,0), 
           transform.pars=FALSE)
predict(m, n.ahead=10)

#
# 14.22 - testing for mean reversion.
#
# use the Augmented-Dickey-Fuller (ADF) test to see if a 
# time series reverts back to the mean.
#
# library(tseries)
# adf.test(coredata(ts))
#

# this test detrends a series
adf.test(coredata(ts.ibm.open.daily))

library(fUnitRoots)
# this test has an option to center (detrend) or not center (nc).
adfTest(coredata(ts.ibm.open.daily), type="nc")

#
# 14.23 - smoothing a time series
#
# smooth a noisy time series
#
# library(KernSmooth)
# gridsize <- length(y)
# bw <- dpill(t,y,gridsize=gridsize)
# lp <- locpoly(x=t, y=y, bandwidth=bw, gridsize=gridsize)
# smooth <- lp$y
#
# t is the time variable and t is the time series

# other smoothing functions are:
# ksmooth
# lowess
# HoltWinters
# 
# also expsmooth package implements exponential smoothing
#


