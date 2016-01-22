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

par(mfrow=c(5,2))

for (i in 1:10)
{
    plot(nz.grp.scnts[[i]]$TPickup-min(nz.grp.scnts[[i]]$TPickup),
         nz.grp.scnts[[i]]$TErrors-min(nz.grp.scnts[[i]]$TErrors))
}

