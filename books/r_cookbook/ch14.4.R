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

#
# order by machine,lane,timestamp
# group by machine,lane

grouped.sorted.cnts2 <- 
    split(sorted.cnts, 
          list(sorted.cnts$MACHINE,
               sorted.cnts$LANE))

nonzero.grouped.sorted.cnts2 <-
    grouped.sorted.cnts2[as.vector(lapply(grouped.sorted.cnts2, 
                                          nrow)) > 0]

lapply(nonzero.grouped.sorted.cnts2, nrow)

nz.grp.scnts2 <- nonzero.grouped.sorted.cnts2

fcnts2 <- nz.grp.scnts2

lapply(fcnts2,nrow)

for (name in names(fcnts2))
{
    orig_nrow     <- nrow(fcnts2[[name]])

    assign_seq_no <- 1:(orig_nrow-1)
    higher_seq_no <- 2:orig_nrow
    lower_seq_no  <- 1:(orig_nrow-1)

    for (fld in copy_only_flds)
    {
        fcnts2[[name]][assign_seq_no,fld] <-
            fcnts2[[name]][higher_seq_no,fld]
    }

    for (fld in calculate_flds)
    {
        fcnts2[[name]][assign_seq_no,fld] <-
            fcnts2[[name]][higher_seq_no,fld] -
            fcnts2[[name]][lower_seq_no,fld]
    }

    fcnts2[[name]] <- fcnts2[[name]][-orig_nrow,]
}

lapply(fcnts2,nrow)

data_fld_nms <- c("TPickup",
                  "TPMiss",
                  "TRMiss",
                  "TDMiss",
                  "THMiss",
                  "TRSMiss",
                  "TMMiss",
                  "TPlace",
                  "TErrors")

zoo.1.1 <- zoo(fcnts2[["1.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["1.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
zoo.2.1 <- zoo(fcnts2[["2.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["2.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
zoo.3.1 <- zoo(fcnts2[["3.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["3.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
zoo.4.1 <- zoo(fcnts2[["4.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["4.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
zoo.5.1 <- zoo(fcnts2[["5.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["5.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
xts.1.1 <- xts(fcnts2[["1.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["1.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
xts.2.1 <- xts(fcnts2[["2.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["2.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
xts.3.1 <- xts(fcnts2[["3.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["3.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
xts.4.1 <- xts(fcnts2[["4.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["4.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
xts.5.1 <- xts(fcnts2[["5.1"]][,data_fld_nms], 
               as.POSIXct(fcnts2[["5.1"]][,"TIMESTAMP"],
                            origin="1970-01-01"))
 
