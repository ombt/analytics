# pa_count_logit_cols <- c(
#     "p_cmp",
#     "dpc_fwait",
#     "dpc_mcfwait",
#     "dpc_mcrwait",
#     "dpc_rwait",
#     "dpc_scestop",
#     "dpc_scstop",
#     "dpc_tpickup",
#     "dpc_tpmiss",
#     "dpc_trmiss"
# )
# 
# pa_time_logit_cols <- c(
#     "p_cmp",
#     "dpt_brcg",
#     "dpt_mcfwait",
#     "dpt_mcrwait",
#     "dpt_prdstop",
#     "dpt_scestop",
#     "dpt_scstop"
# )
# 
# pa_count_time_logit_cols <- c(
#     "p_cmp",
#     "dpc_fwait",
#     "dpc_mcfwait",
#     "dpc_mcrwait",
#     "dpc_rwait",
#     "dpc_scestop",
#     "dpc_scstop",
#     "dpc_tpickup",
#     "dpc_tpmiss",
#     "dpc_trmiss",
#     "dpt_brcg",
#     "dpt_mcfwait",
#     "dpt_mcrwait",
#     "dpt_prdstop",
#     "dpt_scestop",
#     "dpt_scstop"
# )
# 
# pa_time_count_km_cols <- c(
#     # "ufd_machine_order",
#     # "ufd_lane_no",
#     # "ufd_stage_no",
#     # "ufd_filename_id",
#     "p_cmp",
#     "dpc_bndrcgstop",
#     "dpc_bndstop",
#     "dpc_board",
#     "dpc_brcgstop",
#     "dpc_bwait",
#     "dpc_cderr",
#     "dpc_cmerr",
#     "dpc_cnvstop",
#     "dpc_cperr",
#     "dpc_crerr",
#     "dpc_cterr",
#     "dpc_cwait",
#     "dpc_fbstop",
#     "dpc_fwait",
#     "dpc_jointpasswait",
#     "dpc_judgestop",
#     "dpc_lotboard",
#     "dpc_lotmodule",
#     "dpc_mcfwait",
#     "dpc_mcrwait",
#     "dpc_mhrcgstop",
#     "dpc_module",
#     "dpc_otherlstop",
#     "dpc_othrstop",
#     "dpc_pwait",
#     "dpc_rwait",
#     "dpc_scestop",
#     "dpc_scstop",
#     "dpc_swait",
#     "dpc_tdispense",
#     "dpc_tdmiss",
#     "dpc_thmiss",
#     "dpc_tmmiss",
#     "dpc_tmount",
#     "dpc_tpickup",
#     "dpc_tpmiss",
#     "dpc_tpriming",
#     "dpc_trbl",
#     "dpc_trmiss",
#     "dpc_trserr",
#     "dpc_trsmiss",
#     "dpt_actual",
#     "dpt_bndrcgstop",
#     "dpt_bndstop",
#     "dpt_brcg",
#     "dpt_brcgstop",
#     "dpt_bwait",
#     "dpt_cderr",
#     "dpt_change",
#     "dpt_cmerr",
#     "dpt_cnvstop",
#     "dpt_cperr",
#     "dpt_crerr",
#     "dpt_cterr",
#     "dpt_cwait",
#     "dpt_dataedit",
#     "dpt_fbstop",
#     "dpt_fwait",
#     "dpt_idle",
#     "dpt_jointpasswait",
#     "dpt_judgestop",
#     "dpt_load",
#     "dpt_mcfwait",
#     "dpt_mcrwait",
#     "dpt_mente",
#     "dpt_mhrcgstop",
#     "dpt_mount",
#     "dpt_otherlstop",
#     "dpt_othrstop",
#     "dpt_poweron",
#     "dpt_prdstop",
#     "dpt_prod",
#     "dpt_prodview",
#     "dpt_pwait",
#     "dpt_rwait",
#     "dpt_scestop",
#     "dpt_scstop",
#     "dpt_swait",
#     "dpt_totalstop",
#     "dpt_trbl",
#     "dpt_trserr",
#     "dpt_unitadjust"
# )
# # install_and_load("psych")
# 
# # pa = get_pa_data_per_project("training_data2")
# 
# pa_clean = pa[pa$dpc_tpickup>=1,]
# 
# pa_clean_prods = split(pa_clean, pa_clean$upx_mjsid)
# 
# pa_clean_prod = pa_clean_prods[["NISSAN_DA_RS_RR_MASTER-part4"]]
# 
# #
# # choose lane 1 or lane 2
# #
# pa_clean_prod_lane = pa_clean_prod[pa_clean_prod$ufd_lane_no==1,]
# # pa_clean_prod_lane = pa_clean_prod[pa_clean_prod$ufd_lane_no==2,]
# 
# # pad = subset(pa_clean_prod_lane, select=pa_count_time_logit_cols)
# pad = subset(pa_clean_prod_lane, select=pa_time_count_km_cols)
# # pad = subset(pa_clean_prod_lane, select=pa_time_logit_cols)
# # pad = subset(pa_clean_prod_lane, select=pa_count_logit_cols)
# 
# pad$p_cmp = factor(pad$p_cmp, levels=c(-1,1), labels=c("pass", "fail"))
# table(paln$p_cmp)
# 
# xvars = names(pad[,!(names(pad) %in% c("p_cmp"))])
# 
# fit.full <- glm(as.formula(paste("p_cmp~", paste(xvars, collapse="+"))),
#                 data=pad,
#                 family=binomial())
# summary(fit.full)
# 
# 

# all_fields

# aoi_error_count
# aoi_status
# dpc_bndrcgstop
# dpc_bndstop
# dpc_board
# dpc_brcgstop
# dpc_bwait
# dpc_cderr
# dpc_cmerr
# dpc_cnvstop
# dpc_cperr
# dpc_crerr
# dpc_cterr
# dpc_cwait
# dpc_fbstop
# dpc_filename_id
# dpc_fwait
# dpc_jointpasswait
# dpc_judgestop
# dpc_lane_no
# dpc_lotboard
# dpc_lotmodule
# dpc_lotname
# dpc_machine_order
# dpc_mcfwait
# dpc_mcrwait
# dpc_mhrcgstop
# dpc_mjsid
# dpc_module
# dpc_otherlstop
# dpc_othrstop
# dpc_output_no
# dpc_pcb_id
# dpc_pcb_serial
# dpc_pwait
# dpc_rwait
# dpc_scestop
# dpc_scstop
# dpc_stage_no
# dpc_swait
# dpc_tdispense
# dpc_tdmiss
# dpc_thmiss
# dpc_timestamp
# dpc_tmmiss
# dpc_tmount
# dpc_tpickup
# dpc_tpmiss
# dpc_tpriming
# dpc_trbl
# dpc_trmiss
# dpc_trserr
# dpc_trsmiss
# dpt_actual
# dpt_bndrcgstop
# dpt_bndstop
# dpt_brcg
# dpt_brcgstop
# dpt_bwait
# dpt_cderr
# dpt_change
# dpt_cmerr
# dpt_cnvstop
# dpt_cperr
# dpt_crerr
# dpt_cterr
# dpt_cwait
# dpt_dataedit
# dpt_fbstop
# dpt_filename_id
# dpt_fwait
# dpt_idle
# dpt_jointpasswait
# dpt_judgestop
# dpt_lane_no
# dpt_load
# dpt_lotname
# dpt_machine_order
# dpt_mcfwait
# dpt_mcrwait
# dpt_mente
# dpt_mhrcgstop
# dpt_mjsid
# dpt_mount
# dpt_otherlstop
# dpt_othrstop
# dpt_output_no
# dpt_pcb_id
# dpt_pcb_serial
# dpt_poweron
# dpt_prdstop
# dpt_prod
# dpt_prodview
# dpt_pwait
# dpt_rwait
# dpt_scestop
# dpt_scstop
# dpt_stage_no
# dpt_swait
# dpt_timestamp
# dpt_totalstop
# dpt_trbl
# dpt_trserr
# dpt_unitadjust
# ftf_filename
# ftf_filename_id
# ftf_filename_route
# ftf_filename_timestamp
# ftf_filename_type
# i_c2d
# i_cid
# i_crc
# i_filename_id
# i_mid
# i_recipename
# i_timestamp
# p_cmp
# p_fc
# p_filename_id
# p_p
# p_pid
# p_sc
# ufd_date
# ufd_filename_id
# ufd_lane_no
# ufd_machine_order
# ufd_output_no
# ufd_pcb_id
# ufd_pcb_id_lot_no
# ufd_pcb_id_serial_no
# ufd_pcb_serial
# ufd_stage_no
# upi_bcrstatus
# upi_code
# upi_filename_id
# upi_lane
# upi_lotname
# upi_lotnumber
# upi_output
# upi_planid
# upi_productid
# upi_rev
# upi_serial
# upi_serialstatus
# upi_stage
# upx_author
# upx_authortype
# upx_comment
# upx_date
# upx_diff
# upx_filename_id
# upx_format
# upx_machine
# upx_mjsid
# upx_version

pa_all_logit_cols <- c(
    "aoi_error_count",
    "aoi_status",
    "dpc_bndrcgstop",
    "dpc_bndstop",
    "dpc_board",
    "dpc_brcgstop",
    "dpc_bwait",
    "dpc_cderr",
    "dpc_cmerr",
    "dpc_cnvstop",
    "dpc_cperr",
    "dpc_crerr",
    "dpc_cterr",
    "dpc_cwait",
    "dpc_fbstop",
    "dpc_fwait",
    "dpc_jointpasswait",
    "dpc_judgestop",
    "dpc_mcfwait",
    "dpc_mcrwait",
    "dpc_mhrcgstop",
    "dpc_otherlstop",
    "dpc_othrstop",
    "dpc_pwait",
    "dpc_rwait",
    "dpc_scestop",
    "dpc_scstop",
    "dpc_swait",
    "dpc_tdispense",
    "dpc_tdmiss",
    "dpc_thmiss",
    "dpc_tmmiss",
    "dpc_tmount",
    "dpc_tpickup",
    "dpc_tpmiss",
    "dpc_tpriming",
    "dpc_trbl",
    "dpc_trmiss",
    "dpc_trserr",
    "dpc_trsmiss",
    "dpt_actual",
    "dpt_bndrcgstop",
    "dpt_bndstop",
    "dpt_brcg",
    "dpt_brcgstop",
    "dpt_bwait",
    "dpt_cderr",
    "dpt_change",
    "dpt_cmerr",
    "dpt_cnvstop",
    "dpt_cperr",
    "dpt_crerr",
    "dpt_cterr",
    "dpt_cwait",
    "dpt_dataedit",
    "dpt_fbstop",
    "dpt_fwait",
    "dpt_idle",
    "dpt_jointpasswait",
    "dpt_judgestop",
    "dpt_load",
    "dpt_mcfwait",
    "dpt_mcrwait",
    "dpt_mente",
    "dpt_mhrcgstop",
    "dpt_mount",
    "dpt_otherlstop",
    "dpt_othrstop",
    "dpt_poweron",
    "dpt_prdstop",
    "dpt_prod",
    "dpt_prodview",
    "dpt_pwait",
    "dpt_rwait",
    "dpt_scestop",
    "dpt_scstop",
    "dpt_stage_no",
    "dpt_swait",
    "dpt_timestamp",
    "dpt_totalstop",
    "dpt_trbl",
    "dpt_trserr",
    "dpt_unitadjust",
    "p_cmp"
)

pa_independent_logit_cols <- c(
    "dpc_bndrcgstop",
    "dpc_bndstop",
    "dpc_board",
    "dpc_brcgstop",
    "dpc_bwait",
    "dpc_cderr",
    "dpc_cmerr",
    "dpc_cnvstop",
    "dpc_cperr",
    "dpc_crerr",
    "dpc_cterr",
    "dpc_cwait",
    "dpc_fbstop",
    "dpc_fwait",
    "dpc_jointpasswait",
    "dpc_judgestop",
    "dpc_mcfwait",
    "dpc_mcrwait",
    "dpc_mhrcgstop",
    "dpc_otherlstop",
    "dpc_othrstop",
    "dpc_pwait",
    "dpc_rwait",
    "dpc_scestop",
    "dpc_scstop",
    "dpc_swait",
    "dpc_tdispense",
    "dpc_tdmiss",
    "dpc_thmiss",
    "dpc_tmmiss",
    "dpc_tmount",
    "dpc_tpickup",
    "dpc_tpmiss",
    "dpc_tpriming",
    "dpc_trbl",
    "dpc_trmiss",
    "dpc_trserr",
    "dpc_trsmiss",
    "dpt_actual",
    "dpt_bndrcgstop",
    "dpt_bndstop",
    "dpt_brcg",
    "dpt_brcgstop",
    "dpt_bwait",
    "dpt_cderr",
    "dpt_change",
    "dpt_cmerr",
    "dpt_cnvstop",
    "dpt_cperr",
    "dpt_crerr",
    "dpt_cterr",
    "dpt_cwait",
    "dpt_dataedit",
    "dpt_fbstop",
    "dpt_fwait",
    "dpt_idle",
    "dpt_jointpasswait",
    "dpt_judgestop",
    "dpt_load",
    "dpt_mcfwait",
    "dpt_mcrwait",
    "dpt_mente",
    "dpt_mhrcgstop",
    "dpt_mount",
    "dpt_otherlstop",
    "dpt_othrstop",
    "dpt_poweron",
    "dpt_prdstop",
    "dpt_prod",
    "dpt_prodview",
    "dpt_pwait",
    "dpt_rwait",
    "dpt_scestop",
    "dpt_scstop",
    "dpt_stage_no",
    "dpt_swait",
    "dpt_totalstop",
    "dpt_trbl",
    "dpt_trserr",
    "dpt_unitadjust"
)

# dep_flds = c("dpt_actual", "dpt_brcg", "dpt_mount", "dpt_poweron")
# dep_flds = c("dpt_actual", "dpt_brcg", "dpt_mount")

# label = "LINEA10;4;2;1;RSD160-171-AF-BF-CF-NEW;RSD171AF-06"

#
# cycle thru all the data we have
#
total_usable_flds <<- c()
for (label in names(grp_pa_aoi))
{
    print(sprintf("Processing data for ... %s\n", label))
    #
    label_data = grp_pa_aoi[[label]]
    #
    # number of failed boards
    #
    failed_boards = sum(label_data[["aoi_error_count"]]>0)
    # min_non_zero_values = max(failed_boards/2, 2)
    min_non_zero_values = max(failed_boards, 2)
    #
    # determine the fields which have useable data
    #
    usable_flds = c()
    for (col in pa_independent_logit_cols)
    {
        rcol=range(label_data[[col]])
        if ( ! ((is.numeric(rcol[2])) && 
                (rcol[1] < rcol[2]) &&
                (rcol[2] > 0)))
        {
            # print(sprintf("Field %s is NOT USABLE ...", col))
            next
        }
        #
        non_zero_values=sum(label_data[[col]]>0)
        if (non_zero_values<min_non_zero_values)
        {
            # print(sprintf("Field %s is NOT USABLE (%f<%f) ...", col, non_zero_values, min_non_zero_values))
            next
        }
        # print(sprintf("Field %s is USABLE ...", col))
        usable_flds = c(usable_flds, col)
        
    }
    print(sprintf("Usable fields: %s\n", paste(usable_flds, collapse=",")))
    if (length(usable_flds) < 2)
    {
        print(sprintf("Not enough usable fields found ... %f<2",
                      length(usable_flds)))
        next
    }
    total_usable_flds <<- c(total_usable_flds, usable_flds)

    label_data$p_cmp = factor(label_data$p_cmp, 
                              levels=c(-1,1), 
                              labels=c("pass", "fail"))

    selected_data = subset(label_data, 
                           select=c(usable_flds, "p_cmp"))

    fit.full <- glm(as.formula(paste("p_cmp~", 
                                     paste(usable_flds, collapse="+"))),
                    data=selected_data,
                    family=binomial())
    print(summary(fit.full))
}

