#
install_and_load("sqldf")
#
sqlcmd = paste("select ",
               "fd.*,",
               "c.* ",
               "from FID_DATA fd ",
               "inner join 'Count' c on fd.FID = c.FID",
               sep="")
