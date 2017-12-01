#
# load rlib functions.
#
# generic utils
#
source(paste("rlib",
             "generic_utils.R",
             sep="/"))
#
# loading package utils
#
source(paste("rlib",
             "package_utils.R",
             sep="/"))
#
# db utils
#
source(paste("rlib",
             "sqlite_utils.R",
             sep="/"))
#
source(paste("rlib",
             "postgresql_utils.R",
             sep="/"))
#
# loading csv file utils
#
source(paste("rlib",
             "csv_utils.R",
             sep="/"))
#
# loading u0x db utils
#
source(paste("rlib",
             "u0x_sqlite_utils.R",
             sep="/"))
#
source(paste("rlib",
             "u0x_postgresql_utils.R",
             sep="/"))
#
# local loading data from db or csv
#
if (file.exists("load_data.R"))
{
    source("load_data.R")
}
#
