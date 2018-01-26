
#Generate aggregated data
aggregate.info <- aggregate(cbind(Sepal.Length, Sepal.Width) ~ Species,
                            data=iris, mean)

aggregate.info.num <- t(as.matrix(aggregate.info[,c("Sepal.Length","Sepal.Width")]))

#Add column names to new object, which will be each of the Species

colnames(aggregate.info.num) <- aggregate.info$Species

#Finally, plot
barplot(aggregate.info.num,beside=T)
