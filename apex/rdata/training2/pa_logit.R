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

pad = subset(pa_clean_prod_lane, select=pa_count_time_logit_cols)
# pad = subset(pa_clean_prod_lane, select=pa_time_logit_cols)
# pad = subset(pa_clean_prod_lane, select=pa_count_logit_cols)

pad$p_cmp = factor(pad$p_cmp, levels=c(-1,1), labels=c("pass", "fail"))
table(paln$p_cmp)

xvars = names(pad[,!(names(pad) %in% c("p_cmp"))])

fit.full <- glm(as.formula(paste("p_cmp~", paste(xvars, collapse="+"))),
                data=pad,
                family=binomial())
summary(fit.full)


