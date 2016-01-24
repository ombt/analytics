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


