data(iris)
iris$color <- sapply(iris$Species, function(x) switch(as.character(x),
                                                      setosa = "red",
                                                      versicolor = "green",
                                                      virginica = "blue"))

plot(iris$Sepal.Length,iris$Petal.Length, col= iris$color, pch = 16)
legend(7.2,3,legend=c("setosa","versicolor","virginica"), pch=16, 
       col=c("red","green","blue"),cex=0.7)