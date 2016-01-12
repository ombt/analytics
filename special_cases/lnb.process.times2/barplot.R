#
# create bar plot of LNB processing times for Angelo data.
#
angelo.total.times
#
tsecs_per_m_ft_col_names = 
    unique(angelo.total.times$filetype)
tsecs_per_m_ft_col_names 
#
tsecs_per_m_ft_row_names = 
    unique(as.character(angelo.total.times$machno))
tsecs_per_m_ft_row_names 
#
tsecs_per_m_ft_filetypes = 
    unique(angelo.total.times$filetype)
tsecs_per_m_ft_machnos = 
    unique(angelo.total.times$machno)
#
ttmsd = matrix(0, 
               nrow=length(tsecs_per_m_ft_row_names),
               ncol=length(tsecs_per_m_ft_col_names))
rownames(ttmsd) = tsecs_per_m_ft_row_names
colnames(ttmsd)  = tsecs_per_m_ft_col_names
ttmsd[tsecs_per_m_ft_row_names,tsecs_per_m_ft_col_names] =
    angelo.total.times[angelo.total.times$machno %in% 
        tsecs_per_m_ft_machnos &
    angelo.total.times$filetype %in% 
        tsecs_per_m_ft_filetypes,
    "seconds"]
#
barplot(ttmsd,
        main="Trace Proc Time per Machine and Type:",
        col=rainbow(nrow(ttmsd)),
        legend=rownames(ttmsd),
        ylim=c(0,6),
        xlab="File Type",
        ylab="Seconds")
