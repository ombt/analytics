library(ggplot2)

line.graph <- ggplot(data=iris, aes(group=Species))
line.graph <- line.graph + geom_line(aes(x=Sepal.Length,y=Sepal.Width,colour=Species))
plot(line.graph)