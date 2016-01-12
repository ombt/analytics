#
# create bar plot of LNB processing times for Angelo data.
#
att = angelo.total.times
att
#
ftypes = unique(att$filetype)
ftypes
#
machnos = unique(as.character(att$machno))
machnos
#
lanes = unique(as.character(att$lane))
lanes
#
ttmsd = matrix(0, 
               nrow=length(machnos),
               ncol=length(ftypes)*length(lanes))
ttmsd
#
colnames(ttmsd) = 
    sort(as.vector(outer(ftypes, lanes, FUN=paste)))
rownames(ttmsd) = sort(machnos)
ttmsd
#
for (ftype in ftypes)
{
    for (lane in lanes)
    {
        ftype_lane = paste(ftype, lane)
        for (machno in machnos)
        {
            if (machno %in% att[(att$filetype == ftype) &
                                (att$lane == as.integer(lane)),
                                "machno"])
            {
                ttmsd[machno,ftype_lane] =
                    att[(att$filetype == ftype) &
                        (att$machno == as.integer(machno)) &
                        (att$lane == as.integer(lane)), "seconds"]
            }
        }
    }
}
ttmsd
#
par(mar=c(4,4,2,1))
par(oma=c(0,0,0,0))
barplot(ttmsd,
        main="Machine Trace Proc Times per U0X, Lane",
        col=rainbow(nrow(ttmsd)),
        legend=rownames(ttmsd),
        ylim=c(0,2),
        xlab="U0X LANE",
        ylab="SECONDS")
