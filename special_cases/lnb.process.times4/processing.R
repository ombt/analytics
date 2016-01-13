#
# read in CSV data and process
#
angelo=read.table(file="angelo.lnb.times4.csv", 
                  header=TRUE, 
                  as.is=TRUE,sep=';')
#
# output 3 and 4 are the same.
#
angelo$output=3
#
# only function names, remove lnno.
#
angelo$lnno=NULL
#
head(angelo)
#
nrow(angelo)
#
# get means for each factor
#
angelo.mean.times = 
    aggregate(seconds ~ machno + lane + filetype + label,
              data=angelo, 
              mean)
#
write.table(angelo.mean.times, 
            file="angelo.means.times.out", 
            row.names=FALSE, 
            quote=FALSE)
#
# calculate total times.
#
angelo.total.times = aggregate(seconds ~ machno + lane + filetype, 
                               angelo.mean.times,
                               sum)
angelo.total.times

