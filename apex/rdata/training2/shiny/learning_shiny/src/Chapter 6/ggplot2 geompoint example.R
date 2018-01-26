library(ggplot2)

points.graph <- ggplot(data=iris)
points.graph <- points.graph + geom_point(aes(x=Sepal.Length,y=Sepal.Width, colour=Species))
plot(points.graph)