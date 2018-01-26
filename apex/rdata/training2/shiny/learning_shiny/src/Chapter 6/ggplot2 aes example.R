library(ggplot2)

ggplot.graph <- ggplot(data=iris)
ggplot.graph <- ggplot.graph + geom_point(aes(1:50,Sepal.Length[1:50],colour="red"))
ggplot.graph <- ggplot.graph + geom_point(aes(51:100,Sepal.Length[51:100]))
plot(ggplot.graph)