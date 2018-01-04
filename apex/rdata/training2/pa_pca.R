# install_and_load("psych")

pa=get_pa_data_per_project("training_data2")

pa_clean = pa[pa$dpc_tpickup>=1,]

pa_clean_prods=split(pa_clean, pa_clean$upx_mjsid)

pa_clean_prod=pa_clean_prods[["NISSAN_DA_RS_RR_MASTER-part4"]]

#
# choose lane 1 or lane 2
#
pa_clean_prod_lane=pa_clean_prod[pa_clean_prod$ufd_lane_no==1,]
# pa_clean_prod_lane=pa_clean_prod[pa_clean_prod$ufd_lane_no==2,]

paln=subset(pa_clean_prod_lane, select=pa_count_time_hclust_cols)
# paln=subset(pa_clean_prod_lane, select=pa_count_hclust_cols)
# paln=subset(pa_clean_prod_lane, select=pa_time_hclust_cols)

paln.pr=prcomp(paln,scale=TRUE)

paln.pr.var=paln.pr$sdev^2
paln.pr.var

paln.pr.pve=paln.pr.var/sum(paln.pr.var)
paln.pr.pve

closedevs()

# plot(paln.pr.pve, xlab="principal component", ylab="proportion of variance explained", ylim=c(0,1), type='b')
plot(cumsum(paln.pr.pve), xlab="principal component", ylab="cumulative proportion of variance explained", ylim=c(0,1), type='b')

