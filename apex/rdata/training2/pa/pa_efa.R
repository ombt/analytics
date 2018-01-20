# install_and_load("psych")

# pa=get_pa_data_per_project("training_data2")

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

fa <- fa(paln, nfactors=3, rotate="none", fm="pa")

fa

