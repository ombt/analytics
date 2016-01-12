#
# create bar plot of LNB processing times for Angelo data.
#
angelo.mean.times
#
# output are all the same. remove column.
#
amt = angelo.mean.times
amt = amt[!((amt$label == "RH_process_trace_file_msg") |
            (amt$label == "process_u01_file") |
            (amt$label == "process_u03_file") |
            (amt$label == "RH_process_u01_file_msg") |
            (amt$label == "RH_process_u03_file_msg")),] 
amt
#
ftypes  = sort(unique(amt$filetype))
ftypes
machnos = sort(unique(as.character(amt$machno)))
machnos
labels  = unique(amt$label)
labels
#
tmsd = matrix(0,
              nrow=length(labels),
              ncol=(length(ftypes)*length(machnos)))
tmsd
#
colnames(tmsd) = sort(as.vector(outer(ftypes, machnos, paste)))
rownames(tmsd) = sort(labels)
tmsd
#
for (ftype in ftypes)
{
    for (machno in machnos)
    {
        ftype_machno = paste(ftype, machno)
        # print(ftype_machno);
        for (label in labels)
        {
            # print(label);
            # print(amt[(amt$filetype == ftype) & (amt$machno == as.integer(machno)),"label"])
            if (label %in% amt[(amt$filetype == ftype) &
                               (amt$machno == as.integer(machno)),"label"])
            {
                tmsd[label,ftype_machno] = 
                    amt[(amt$filetype == ftype) &
                        (amt$machno == as.integer(machno)) &
                        (amt$label == label), "seconds"]
            }
        }
    }
}
tmsd
#
par(mar=c(4,4,2,1))
par(oma=c(0,0,0,0))
barplot(tmsd,
        main="Trace Proc Times per U0X, Machine:",
        col=rainbow(nrow(tmsd)),
        legend=rownames(tmsd),
        ylim=c(0,1),
        xlab="U0X MACHINE",
        ylab="Seconds")
#
# remove "RH_process_u03_file_msg", etc since these
# are double counting.
#
