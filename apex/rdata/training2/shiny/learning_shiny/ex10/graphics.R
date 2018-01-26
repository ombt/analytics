
plot_iris <- function(what_to_plot)
{
    plot(iris[[what_to_plot]])
}

barplot_iris <- function()
{
    # Generate aggregated data
    aggregate.info <- 
        aggregate(cbind(Sepal.Length, Sepal.Width) ~ Species,
                  data=iris, 
                  mean)

    # Select the numeric variables of aggregate.info, convert it to 
    # matrix and transpose it
    aggregate.info.num <- 
        t(as.matrix(aggregate.info[,c("Sepal.Length","Sepal.Width")]))
    colnames(aggregate.info.num) <- aggregate.info$Species

    # Finally, plot
    barplot(aggregate.info.num, beside=T)
}

histograms_iris <- function()
{
    names(hist(iris$Sepal.Length,breaks=c(4,6,8,10)))
}

boxplot_iris <- function()
{
    boxplot(Sepal.Length ~ Species, data=iris)
}

pie_iris <- function()
{
    pie(table(iris$Species))
}

points_iris <- function()
{
    plot(iris$Sepal.Length)
    points(iris$Sepal.Length, col="red")
}

lines_iris <- function()
{
    plot(iris$Sepal.Length)
    lines(iris$Sepal.Length, pch=18, col="red")
}

lines_points_iris <- function()
{
    plot(iris$Sepal.Length)
    points(iris$Sepal.Length, col="red")
    lines(iris$Sepal.Length, pch=18, col="green")
}

plotting_options_iris <- function()
{
    plot(iris$Sepal.Length,
         pch=1:20, # cycle thru different types characters for points
         main="this is main title",
         xlab="this is x-label",
         ylab="this is y-label",
         xlim=c(0,150),
         ylim=c(4,9))
    points(iris$Sepal.Length, col="red")
    lines(iris$Sepal.Length, pch=18, col="green")
}

legends_iris <- function()
{
    old_mfrow <- par()$mfrow

    par(mfrow=c(2,1))

    plot(iris$Sepal.Length)
    legend(7.5, c("aaa","bbb"))

    plot(iris$Sepal.Length)
    legend(120,5.5, c("aaa","bbb"))

    par(mfrow=old_mfrow)
}

colors_iris <- function()
{
    iris$color <- 
    sapply(iris$Species, 
           function(x) {
               switch(as.character(x),
                      setosa = "red",
                      versicolor = "green",
                      virginica = "blue") } )

    plot(iris$Sepal.Length,
         iris$Petal.Length, 
         col = iris$color, 
         pch = 16)

    legend(7.2,
           3,
           legend=c("setosa",
                    "versicolor",
                    "virginica"), 
           pch=16, 
           col=c("red",
                 "green",
                 "blue"),cex=0.7)
}

final_plot_iris <- function()
{
    iris$color <- 
        sapply(iris$Species, 
               function(x) switch(as.character(x),
                                  setosa = "red",
                                  versicolor = "green",
                                  virginica = "blue"))

    plot(iris$Sepal.Length,
         iris$Petal.Length, 
         col=iris$color, 
         pch=16,
         main="Sepal Length/Petal Length dispersion graph",
         xlab ="Sepal Length", 
         ylab="Petal Length",
         cex=0.8, 
         ylim=c(0,8))
    legend(7.2, 3,
           legend=c("setosa",
                    "versicolor",
                    "virginica"), 
           pch=16, 
           col=c("red",
                 "green",
                 "blue"),
           cex=0.7)

}


