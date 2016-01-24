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

ts.ibm.daily <- ts(ibm.daily[,"Open"], 
                   start=as.Date(ibm.daily[1,"Date"]))
acf(ts.ibm.daily)

#
#


