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

write_sorted_count_csv <- function(scnts, file="sorted.counts.csv")
{
    write.table(scnts, 
                file=file, 
                quote=FALSE, 
                row.names=FALSE,
                col.names=TRUE,
                sep=";")
}
