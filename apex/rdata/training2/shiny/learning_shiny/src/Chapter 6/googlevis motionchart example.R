#Install WDI to obtain data from the World Bank API and call the
library(googleVis)

install.packages("WDI")
library(WDI)
# Load some data
indicators <- c("BM.KLT.DINV.GD.ZS","BG.GSR.NFSV.GD.ZS","EN.ATM.CO2E.
                PP.GD","NY.GDP.MKTP.CD")
countries <- c("AR","BR","DE","US","CA","FR","GB","CN","RU","JP")
frame <- WDI(country = countries, indicator = indicators, start =2005, end=2013)

#Change indicator names just to make it easier to understand
names(frame)[4:7] <- paste0("indicator",1:4)

#Graph HTML Creation
motionchart <- gvisMotionChart(data = frame, idvar = "iso2c", timevar= "year", 
                               xvar = "indicator1", yvar = "indicator2", 
                               sizevar ="indicator3", colorvar = "indicator4")
#Plotting
plot(motionchart)