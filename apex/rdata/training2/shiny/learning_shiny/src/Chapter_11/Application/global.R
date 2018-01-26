library(shiny)
library(googleVis)
library(reshape2)
library(ggplot2)

load("rawdata_adult.rda")

factor.vars <- names(which(sapply(data.adult, class) == "factor"))
factor.vars <- setdiff(factor.vars,"earnings")
