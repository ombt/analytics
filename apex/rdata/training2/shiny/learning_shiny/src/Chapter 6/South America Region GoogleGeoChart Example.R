library(googleVis)

#Artificial Dataset Generation
countries <- c("BR","AR","PE","PY")
value1 <- runif(4,0,10)
value2 <- round(runif(4,0,100))
sa.dataset <- data.frame(countries=countries,val1=value1,val2=value2)

#Plot of the Map. '005' is the region code for South America
southamerica.map <- gvisGeoChart(sa.dataset, locationvar="countries",
                                 sizevar="val1",
                                 hovervar="val2",
                                 options = list(region="005",displayMode="regions"))

#Plotting

plot(southamerica.map)