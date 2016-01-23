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


