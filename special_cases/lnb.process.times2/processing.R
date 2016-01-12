#
# read in CSV data and process
#
angelo=read.table(file="angelo.lnb.times2.csv", 
                  header=TRUE, 
                  as.is=TRUE,sep=';')
#
# output 3 and 4 are the same.
#
angelo$output=3
#
# combine label and end lineno. start lineno is not needed.
#
angelo$start=NULL
angelo$label=paste(angelo$label, angelo$end, sep="-")
angelo$end=NULL
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
# mean time to print out a snapshot. this time can be
# removed if snapshots overlap.
#
# start    start2    end2 print2 end print
#   |--------|--------|-----|-----|----|
# 
# t =e-s
# t2=e2-s2
#
mean(angelo.mean.times[angelo.mean.times$label=="RH_process_trace_file_msg-408", "seconds"])
#
mean(angelo.mean.times[angelo.mean.times$label=="RH_process_trace_file_msg-409", "seconds"])

#
# calculate total times. must remove overlapping times.
#
angelo.mean.nonoverlap.times = angelo.mean.times
#
angelo.total.times = aggregate(seconds ~ machno + lane + filetype, 
                               angelo.mean.nonoverlap.times,
                               sum)
angelo.total.times

