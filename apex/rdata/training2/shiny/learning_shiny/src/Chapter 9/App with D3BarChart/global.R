library(D3BarChart)
library(htmlwidgets)
data(iris)

names(iris) <- gsub("\\.","",names(iris))

aggreg.iris <- aggregate(.~Species,data = iris, FUN = mean)
