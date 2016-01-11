#
# read in CSV data and process
#
angelo=read.table(file="angelo.lnb.times.csv", 
                  header=TRUE, 
                  as.is=TRUE,sep=';')
#
# output 3 and 4 are the same.
#
angelo$output=3
#
nrow(angelo)
#
# get means for each factor
#
angelo.mean.times = aggregate(seconds ~ machno + filetype + output + label, 
                         data=angelo, 
                         mean)
#
angelo.total.times = aggregate(seconds ~ machno + filetype, 
                               angelo.mean.times,
                               sum)
