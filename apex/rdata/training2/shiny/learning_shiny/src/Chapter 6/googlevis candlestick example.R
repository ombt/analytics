library(googleVis)

#Artificial dataset generation
example.data <- data.frame(year = 2005:2014, open = runif(10,0,100), close = runif(10,0,100))

example.data$low <- apply(example.data[,2:3],1, function(x) min(x) - runif(1,0,10))

example.data$high <- apply(example.data[,2:3],1, function(x) max(x) + runif(1,0,10))

#Plotting

candlestick.chart <- gvisCandlestickChart(example.data, xvar = "year",
                                          low="low",open="open",
                                          close="close",high="high")
plot(candlestick.chart)