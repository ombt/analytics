#
# create bar plot of LNB processing times for Angelo data.
#
angelo.mean.times
#
# output are all the same. remove column.
#
amt = angelo.mean.times
#
#amt = amt[!((amt$label == "RH_process_trace_file_msg") |
#            (amt$label == "process_u01_file") |
#            (amt$label == "process_u03_file") |
#            (amt$label == "RH_process_u01_file_msg") |
#            (amt$label == "RH_process_u03_file_msg")),]
#
#
#labels_to_keep = c("copy_file-return",
#                   "management_reset-return",
#                   "postprocess_u0X_file-return",
#                   "preprocess_u0X_file-return",
#                   "process_mount_log_file_data-return",
#                   "prod_general_processing-return",
#                   "prod_nozzle_processing-return",
#                   "prod_unitreel_processing-return",
#                   "trace_processing-return")
#
#amt = amt[amt$label %in% labels_to_keep,]
amt
#
ftypes  = sort(unique(amt$filetype))
ftypes
machnos = sort(unique(as.character(amt$machno)))
machnos
labels  = unique(amt$label)
labels
lanes = sort(unique(as.character(amt$lane)))
lanes
#
tmsd = matrix(0,
              nrow=length(labels),
              ncol=(length(ftypes)*length(machnos)*length(lanes)))
tmsd
#
colnames(tmsd) = 
    sort(as.vector(outer(as.vector(outer(ftypes, machnos, paste)),
                         lanes,
                         paste)))
rownames(tmsd) = sort(labels)
tmsd
#
for (ftype in ftypes)
{
    for (machno in machnos)
    {
        for (lane in lanes)
        {
            ftype_machno_lane = paste(ftype, machno, lane)
            # print(ftype_machno);
            for (label in labels)
            {
                # print(label);
                # print(amt[(amt$filetype == ftype) & (amt$machno == as.integer(machno)),"label"])
                if (label %in% amt[(amt$filetype == ftype) &
                                   (amt$machno == as.integer(machno)) &
                                   (amt$lane == as.integer(lane)),"label"])
                {
                    tmsd[label,ftype_machno_lane] =
                        amt[(amt$filetype == ftype) &
                            (amt$machno == as.integer(machno)) &
                            (amt$lane == as.integer(lane)) &
                            (amt$label == label), "seconds"]
                }
            }
        }
    }
}
tmsd
#
par(mar=c(4,4,2,1))
par(oma=c(0,0,0,0))
barplot(tmsd,
        main="Trace Proc Times per U0X, Machine, Lane",
        col=rainbow(nrow(tmsd)),
        legend=rownames(tmsd),
        ylim=c(0,0.6),
        xlab="U0X MACHINE LANE",
        ylab="SECONDS")
#
# remove "RH_process_u03_file_msg", etc since these
# are double counting.
#
jpeg()
par(mar=c(4,4,2,1))
par(oma=c(0,0,0,0))
barplot(tmsd,
        main="Trace Proc Times per U0X, Machine, Lane",
        col=rainbow(nrow(tmsd)),
        legend=rownames(tmsd),
        ylim=c(0,1),
        xlab="U0X MACHINE LANE",
        ylab="SECONDS")
dev.off()


