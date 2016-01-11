#
# create bar plot of LNB processing times for Angelo data.
#
am = angelo.means
#
# fields
#
names(am)
unique(am$filetype)
unique(am$output)
unique(am$label)
unique(am$machno)
# 
am$filetype = as.factor(am$filetype)
am$output = as.factor(am$output)
am$label = as.factor(am$label)
#
ft_no  = length(unique(am$filetype))
ft_no
out_no = length(unique(am$output))
out_no
lbl_no = length(unique(am$label))
lbl_no
mn_no = length(unique(am$machno))
mn_no
#
#amd = array(0, 
#            dim=c(ft_no, lbl_no, mn_no),
#            dimnames=c("filetype", "label", "machine"))
#
amd = matrix(0,nrow=lbl_no,ncol=mn_no)
#
colnames(amd) = as.character(unique(am$machno))
rownames(amd) = as.character(unique(am$label))
#
machnos = sort(unique(am$machno))
machnos
labels  = as.character(sort(unique(am$label[am$filetype=="u01"])))
labels
#
amd
amd[labels,machnos] = am[am$filetype=="u01" & 
                         am$machno %in% machnos &
                         am$label %in% labels, "seconds"]
amd
#
names(angelo.means)
#
tsecs_per_m_ft = aggregate(seconds ~ machno + filetype, 
                           angelo.means, 
                           sum)
tsecs_per_m_ft 
#
tsecs_per_m_ft_col_names = unique(tsecs_per_m_ft$filetype)
tsecs_per_m_ft_col_names 
tsecs_per_m_ft_row_names = unique(as.character(tsecs_per_m_ft$machno))
tsecs_per_m_ft_row_names 
#
tsecs_per_m_ft_filetypes = unique(tsecs_per_m_ft$filetype)
tsecs_per_m_ft_machnos   = unique(tsecs_per_m_ft$machno)
#
ttmsd = matrix(0, 
               nrow=length(tsecs_per_m_ft_row_names),
               ncol=length(tsecs_per_m_ft_col_names))
rownames(ttmsd) = tsecs_per_m_ft_row_names
colnames(ttmsd)  = tsecs_per_m_ft_col_names
ttmsd[tsecs_per_m_ft_row_names,tsecs_per_m_ft_col_names] =
    tsecs_per_m_ft[tsecs_per_m_ft$machno %in% tsecs_per_m_ft_machnos &
                   tsecs_per_m_ft$filetype %in% tsecs_per_m_ft_filetypes,
                   "seconds"]
barplot(ttmsd,
        main="Trace Proc Time per Machine and Type:",
        col=rainbow(nrow(ttmsd)),
        legend=rownames(ttmsd),
        ylim=c(0,6),
        xlab="File Type",
        ylab="Seconds")
        



# aggregate(seconds ~ label + machno + filetype, angelo.means, sum
# )
# aggregate(seconds ~ machno + filetype, angelo.means, sum)
# ttms = aggregate(seconds ~ machno + filetype, angelo.means, sum)
# ttms
# ttmsd = matrix(0, nrow=5,ncol=2)
# colnames(ttmsd = c("u01", "u02")
##  colnames(ttmsd) = c("u01", "u02")
# rownames(ttmsd) = as.character(c(1,2,3,4,5))
# ttmsd
# ttms
