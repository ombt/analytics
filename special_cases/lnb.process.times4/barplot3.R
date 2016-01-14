#
angelo.mean.times
#
amt = angelo.mean.times
#
plot_angelo <- function(amt,
                        ftypes,
                        machnos,
                        labels,
                        lanes,
                        ylim,
                        beside=FALSE)
{
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
    x11()
    par(mar=c(4,4,2,1))
    par(oma=c(0,0,0,0))
    #
    barplot(tmsd,
            main="Trace Proc Times per U0X, Machine, Lane",
            col=rainbow(nrow(tmsd)),
            legend=rownames(tmsd),
            ylim=ylim, beside=beside,
            xlab="U0X MACHINE LANE",
            ylab="SECONDS")
}
#
# both u01 and u03
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
ylims = c(0, max(unique(amt[,"seconds"])))
#
plot_angelo(amt, 
            ftypes, 
            machnos, 
            labels, 
            lanes, 
            c(0,0.5),
            FALSE)
#
# only u01
#
ftypes = "u01"
ftypes
labels  = unique(amt[amt$filetype=="u01","label"])
labels
ylims = c(0, max(unique(amt[amt$filetype=="u01","seconds"])))
#
plot_angelo(amt, 
            ftypes, 
            machnos, 
            labels, 
            lanes, 
            # c(0,0.2), 
            1.5*ylims,
            TRUE)
#
# only u03
#
ftypes = "u03"
ftypes
labels  = unique(amt[amt$filetype=="u03","label"])
labels
ylims = c(0, max(unique(amt[amt$filetype=="u03","seconds"])))
#
plot_angelo(amt, 
            ftypes, 
            machnos, 
            labels, 
            lanes, 
            # c(0,0.2), 
            1.5*ylims,
            TRUE)
#
