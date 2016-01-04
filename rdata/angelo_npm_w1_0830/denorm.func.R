#
# get unique range of values for denorm.count.
#
dn.count.ranges <- function(dncnt)
{
    print(paste(unique(dncnt$MACHINE), collapse=" "))
    print(paste(unique(dncnt$LANE), collapse=" "))
    print(paste(unique(dncnt$STAGE), collapse=" "))
    print(paste(unique(dncnt$PRODUCT), collapse=" "))
    dummy=1
}

