pa_count_logit_cols <- c(
    "p_cmp",
    "dpc_fwait",
    "dpc_mcfwait",
    "dpc_mcrwait",
    "dpc_rwait",
    "dpc_scestop",
    "dpc_scstop",
    "dpc_tpickup",
    "dpc_tpmiss",
    "dpc_trmiss"
)

pa_time_logit_cols <- c(
    "p_cmp",
    "dpt_brcg",
    "dpt_mcfwait",
    "dpt_mcrwait",
    "dpt_prdstop",
    "dpt_scestop",
    "dpt_scstop"
)

pa_count_time_logit_cols <- c(
    "p_cmp",
    "dpc_fwait",
    "dpc_mcfwait",
    "dpc_mcrwait",
    "dpc_rwait",
    "dpc_scestop",
    "dpc_scstop",
    "dpc_tpickup",
    "dpc_tpmiss",
    "dpc_trmiss",
    "dpt_brcg",
    "dpt_mcfwait",
    "dpt_mcrwait",
    "dpt_prdstop",
    "dpt_scestop",
    "dpt_scstop"
)

pa_time_count_km_cols <- c(
    # "ufd_machine_order",
    # "ufd_lane_no",
    # "ufd_stage_no",
    # "ufd_filename_id",
    "p_cmp",
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
    "dpc_lotboard",
    "dpc_lotmodule",
    "dpc_mcfwait",
    "dpc_mcrwait",
    "dpc_mhrcgstop",
    "dpc_module",
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
    "dpt_swait",
    "dpt_totalstop",
    "dpt_trbl",
    "dpt_trserr",
    "dpt_unitadjust"
)
# install_and_load("psych")

# pa = get_pa_data_per_project("training_data2")

pa_clean = pa[pa$dpc_tpickup>=1,]

pa_clean_prods = split(pac, pac$upx_mjsid)

pa_clean_prod = pa_clean_prods[["NISSAN_DA_RS_RR_MASTER-part4"]]

#
# choose lane 1 or lane 2
#
pa_clean_prod_lane = pa_clean_prod[pa_clean_prod$ufd_lane_no==1,]
# pa_clean_prod_lane = pa_clean_prod[pa_clean_prod$ufd_lane_no==2,]

# pad = subset(pa_clean_prod_lane, select=pa_count_time_logit_cols)
pad = subset(pa_clean_prod_lane, select=pa_time_count_km_cols)
# pad = subset(pa_clean_prod_lane, select=pa_time_logit_cols)
# pad = subset(pa_clean_prod_lane, select=pa_count_logit_cols)

pad$p_cmp = factor(pad$p_cmp, levels=c(-1,1), labels=c("pass", "fail"))
table(paln$p_cmp)

xvars = names(pad[,!(names(pad) %in% c("p_cmp"))])

fit.full <- glm(as.formula(paste("p_cmp~", paste(xvars, collapse="+"))),
                data=pad,
                family=binomial())
summary(fit.full)


