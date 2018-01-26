#Call WDI library

library(WDI)
library(reshape2)
library(googleVis)

#Load all indicators

all.indicators <- as.data.frame(WDIsearch())

#Take the first 6 indicators

used.indicators <- all.indicators[c(1:3,12,14,15),]

#Retrieve Data from indicators

countries <- c("AR","BR","DE","US","CA","FR","GB","CN","RU","JP")


frame <- WDI(country = countries, indicator = as.character(used.indicators[,1])
             , start = 2005, end=2013)

#Create indicator's vector

indicators.vector <- as.character(used.indicators[,1])
names(indicators.vector) <- as.character(used.indicators[,2])

#Create countrie's vector

countries.vector <- unique(frame$iso2c)
names(countries.vector) <- unique(frame$country)
