library(googleVis)

#Generate random data with dependencies
regions <- c("World","America","Europe","Asia","South America",
             "North America","Western Europe","Eastern Europe", "Middle East",
             "Far East", "Argentina","Brazil","USA","Canada", "Germany",
             "France","Hungary","Russia","Israel","Saudi Arabia","China","Japan")
dependency <- c(NA,"World","World","World","America","America","Europe","Europe",
                "Asia","Asia","South America","South America","North America",
                "North America", "Western Europe", "Western Europe",
                "Eastern Europe", "Eastern Europe", "Middle East", "Middle East",
                "Far East", "Far East")

size <- runif(22,1,100)
color <- runif(22,1,100)

frame <- data.frame(regions=regions,dependency=dependency,size=size,color=color)

#Plot treemap
treemap <- gvisTreeMap(frame, "regions","dependency","size","color")
plot(treemap)