#
# default options
#
# do not convert strings to factors by default
#
options(stringsAsFactors=FALSE)
#
# maximum number of lines to print
#
options(max.print=100)
#
# start of session
#
.First <- function()
{
    #
    # required DB packages
    #
    library(DBI)
    library(RSQLite)
    library(RPostgreSQL)
    library(ggplot2)
    library(sqldf)
    library(plyr)
    library(shiny)
    #
    if (file.exists("source_all.R"))
    {
        #
        # local version
        #
        source("source_all.R")
    }
}
#
# end of session
#
.Last <- function()
{
    closealldevs()
}
