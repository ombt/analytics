library(ggplot2)

data(anscombe)
sorted.anscombe <- anscombe[order(anscombe$x2),]
anscombe.graph <- ggplot(data=sorted.anscombe)
anscombe.graph <- anscombe.graph + geom_point(colour =
                                                "blue",aes(x=x2,y=y2))

anscombe.graph <- anscombe.graph + geom_segment(colour = "red",
                                                aes(x=x2[1],xend=x2[nrow(anscombe)],
                                                  y=y2[1],yend=y2[nrow(anscombe)]))
plot(anscombe.graph)