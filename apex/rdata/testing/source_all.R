#
# load rlib functions.
#
rlib_files <- list.files("rlib", pattern=".*.R")
#
for (rlib_file in rlib_files)
{
    source(paste("rlib", rlib_file, sep="/"))
}
#
# local loading data from db or csv
#
if (file.exists("load_data.R"))
{
    source("load_data.R")
}
#
