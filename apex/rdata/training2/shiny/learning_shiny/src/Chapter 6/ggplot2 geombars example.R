library(ggplot2)

bar.graph <- ggplot(data=mpg)
bar.graph <- bar.graph + geom_bar(width=0.3, fill="red", aes(x=class))
plot(bar.graph)