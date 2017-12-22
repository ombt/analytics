#
# function to read in data
#
get_pa_data_per_project <- function(db_name="", mjsid="", lotname="")
{
    pa_view <- attr(get_pa_data_per_project,"view");
    #
    query_mjsid_lotname_format <- 
        "select * from %s where upx_mjsid='%s' and upi_lotname='%s'"
    query_mjsid_format <- 
        "select * from %s where upx_mjsid='%s'"
    query_lotname_format <- 
        "select * from %s where upi_lotname='%s'"
    query_format <- 
        "select * from %s"
    #
    # db name is mandatory
    #
    if (nchar(db_name) == 0)
    {
        stop(sprintf("DB name was not given."))
    }
    #
    # if no product was given, then just read the
    # entire table. 
    #
    if ((nchar(mjsid) != 0) && (nchar(lotname) != 0))
    {
        format <- attr(get_pa_data_per_project,
                      "query_mjsid_lotname_format")
        query = sprintf(format, pa_view, mjsid, lotname);
    }
    else if (nchar(mjsid) != 0)
    {
        format <- attr(get_pa_data_per_project,"query_mjsid_format")
        query = sprintf(format, pa_view, mjsid);
    }
    else if (nchar(lotname) != 0)
    {
        format <- attr(get_pa_data_per_project,"query_lotname_format")
        query = sprintf(format, pa_view, lotname);
    }
    else
    {
        format <- attr(get_pa_data_per_project,"query_format")
        query = sprintf(format, pa_view);
    }
    #
    pa = data.frame();
    db = pg_open_db(db_name);
    #
    pa = pg_exec_query(db, query)
    #
    pg_close_db(db)
    #
    attr(pa, "mjsid") = mjsid;
    attr(pa, "lotname") = lotname;
    #
    return(pa);
}
#
attr(get_pa_data_per_project,"view") <- 
        "u01.pa_pcb_totals_aoi_per_machine_view"
attr(get_pa_data_per_project,"query_mjsid_lotname_format") <- 
        "select * from %s where upx_mjsid='%s' and upi_lotname='%s'"
attr(get_pa_data_per_project,"query_mjsid_format") <- 
        "select * from %s where upx_mjsid='%s'"
attr(get_pa_data_per_project,"query_lotname_format") <- 
        "select * from %s where upi_lotname='%s'"
attr(get_pa_data_per_project,"query_format") <- 
        "select * from %s"
#
pa_count_cols <- c(
    "ftf_filename_route",
    "ufd_machine_order",
    "ufd_lane_no",
    "ufd_stage_no",
    "ftf_filename_timestamp",
    "ftf_filename",
    "ftf_filename_type",
    "ftf_filename_id",
    "ufd_filename_id",
    "ufd_date",
    "ufd_pcb_serial",
    "ufd_pcb_id",
    "ufd_output_no",
    "ufd_pcb_id_lot_no",
    "ufd_pcb_id_serial_no",
    "upx_filename_id",
    "upx_author",
    "upx_authortype",
    "upx_comment",
    "upx_date",
    "upx_diff",
    "upx_format",
    "upx_machine",
    "upx_mjsid",
    "upx_version",
    "upi_filename_id",
    "upi_bcrstatus",
    "upi_code",
    "upi_lane",
    "upi_lotname",
    "upi_lotnumber",
    "upi_output",
    "upi_planid",
    "upi_productid",
    "upi_rev",
    "upi_serial",
    "upi_serialstatus",
    "upi_stage",
    "i_filename_id",
    "i_cid",
    "i_timestamp",
    "i_crc",
    "i_c2d",
    "i_recipename",
    "i_mid",
    "p_filename_id",
    "p_p",
    "p_cmp",
    "aoi_status",
    "p_sc",
    "p_pid",
    "p_fc",
    "dpc_filename_id",
    "dpc_pcb_id",
    "dpc_pcb_serial",
    "dpc_machine_order",
    "dpc_lane_no",
    "dpc_stage_no",
    "dpc_timestamp",
    "dpc_mjsid",
    "dpc_lotname",
    "dpc_output_no",
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
    "dpc_trsmiss"
)

pa_count_km_cols <- c(
    "ufd_machine_order",
    "ufd_lane_no",
    "ufd_stage_no",
    "ufd_filename_id",
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
    "dpc_trsmiss"
)

pa_time_cols <-c(
    "ftf_filename_route",
    "ufd_machine_order",
    "ufd_lane_no",
    "ufd_stage_no",
    "ftf_filename_timestamp",
    "ftf_filename",
    "ftf_filename_type",
    "ftf_filename_id",
    "ufd_filename_id",
    "ufd_date",
    "ufd_pcb_serial",
    "ufd_pcb_id",
    "ufd_output_no",
    "ufd_pcb_id_lot_no",
    "ufd_pcb_id_serial_no",
    "upx_filename_id",
    "upx_author",
    "upx_authortype",
    "upx_comment",
    "upx_date",
    "upx_diff",
    "upx_format",
    "upx_machine",
    "upx_mjsid",
    "upx_version",
    "upi_filename_id",
    "upi_bcrstatus",
    "upi_code",
    "upi_lane",
    "upi_lotname",
    "upi_lotnumber",
    "upi_output",
    "upi_planid",
    "upi_productid",
    "upi_rev",
    "upi_serial",
    "upi_serialstatus",
    "upi_stage",
    "i_filename_id",
    "i_cid",
    "i_timestamp",
    "i_crc",
    "i_c2d",
    "i_recipename",
    "i_mid",
    "p_filename_id",
    "p_p",
    "p_cmp",
    "aoi_status",
    "p_sc",
    "p_pid",
    "p_fc",
    "dpt_filename_id",
    "dpt_pcb_id",
    "dpt_pcb_serial",
    "dpt_machine_order",
    "dpt_lane_no",
    "dpt_stage_no",
    "dpt_timestamp",
    "dpt_mjsid",
    "dpt_lotname",
    "dpt_output_no",
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

pa_time_km_cols <- c(
    "ufd_machine_order",
    "ufd_lane_no",
    "ufd_stage_no",
    "ufd_filename_id",
    "p_cmp",
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

# sink("/tmp/xxx.out")

#
# get PA training data
#
pa = get_pa_data_per_project("training_data2")

#
# clean data. remove counts and times which are
# less than zero. removing pickup counts less
# than zero removes the negative times and counts.
#
pa_clean <- pa[pa$dpc_tpickup>=0,]

#
# split data by product
#
pa_clean_prod = split(pa_clean, pa_clean$upx_mjsid)
# 
#
# cycle over each mjsid and calculate k-means clustering.
#
for (mjsid in names(pa_clean_prod))
{
    print(sprintf("MJSID ... %s", mjsid))

    #
    # get the data for this product
    #
    pa_prod = pa_clean_prod[[mjsid]]
    print(sprintf("NROW of pa_prod (%s) = %d", mjsid, nrow(pa_prod)))

    #
    # separate counts and time data
    #
    pa_km_count <- subset(pa_prod,
                          select=pa_count_km_cols)
    pa_km_time <- subset(pa_prod,
                          select=pa_time_km_cols)

    #
    # run kmeans for two clusters: pass or fail for AOI
    #
    fit_count = kmeans(pa_km_count, 2)
    fit_time = kmeans(pa_km_time, 2)

    #
    # check the fit
    #
    print("AOI Results")
    print(count(pa_prod$p_cmp))
    print("COUNT")
    print(count(fit_count$cluster))
    print("TIME")
    print(count(fit_time$cluster))
}

# sink()

