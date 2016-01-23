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


