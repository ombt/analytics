library(googleVis)

#Artificial Dataset generation
latitudes <- runif(10,27,49)
longitudes <- runif(10,-125,-72)
values <- runif(10,0,100)
us.dataset <- data.frame(lat=latitudes,long=longitudes,val=values)
#Generate a latlong variable as expected in 'locationvar'
us.dataset$latlong <- paste(us.dataset$lat,us.dataset$long,sep=":")
#Map HTML creation
us.map <- gvisGeoChart(us.dataset, locationvar="latlong",sizevar="val",
                       options = list(region="US"))
#Plotting
plot(us.map)