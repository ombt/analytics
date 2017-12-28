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
    # "ufd_machine_order",
    # "ufd_lane_no",
    # "ufd_stage_no",
    # "ufd_filename_id",
    # "p_cmp",
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

pa_time_km_cols <-c(
    # "ufd_machine_order",
    # "ufd_lane_no",
    # "ufd_stage_no",
    # "ufd_filename_id",
    # "p_cmp",
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

pa_time_count_km_cols <- c(
    # "ufd_machine_order",
    # "ufd_lane_no",
    # "ufd_stage_no",
    # "ufd_filename_id",
    # "p_cmp",
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

pa_count_hclust_cols <- c(
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

pa_time_hclust_cols <- c(
    "dpt_brcg",
    "dpt_mcfwait",
    "dpt_mcrwait",
    "dpt_prdstop",
    "dpt_scestop",
    "dpt_scstop"
)

pa_count_time_hclust_cols <- c(
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

pa_count_logit_cols <- c(
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
    "dpt_brcg",
    "dpt_mcfwait",
    "dpt_mcrwait",
    "dpt_prdstop",
    "dpt_scestop",
    "dpt_scstop"
)

pa_count_time_logit_cols <- c(
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

get_bad_pcb_per_machine <- function(db_name="", 
                                    mjsids=c(),
                                    lotnames=c(),
                                    machines=c(),
                                    lanes=c(),
                                    stages=c())
{
    #
    # db name is mandatory
    #
    if (nchar(db_name) == 0)
    {
        stop(sprintf("DB name was not given."))
    }
    #
    # build where-clause, if any
    #
    where_clause <- "";
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("upx_mjsid", 
                                                 mjsids))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("upi_lotname", 
                                                 lotnames))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("ufd_machine_order", 
                                                 machines))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("ufd_lane_no", 
                                                 lanes))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("ufd_stage_no", 
                                                 stages))
    #
    # build entire query.
    #
    pa_view <- "u03.mqt_pcb_aoi_bad_per_machine_view"
    query <- sprintf("select * from %s", pa_view);
    if (nchar(where_clause) > 0)
    {
        query <- paste(query, "where", where_clause)
    }
    #
    # get data
    #
    pa = data.frame();
    db = pg_open_db(db_name);
    #
    pa = pg_exec_query(db, query)
    #
    pg_close_db(db)
    #
    attr(pa, "mjsid") = mjsids;
    attr(pa, "lotname") = lotnames;
    #
    return(pa);
}

get_pa_data_per_project <- function(db_name="", 
                                    mjsids=c(),
                                    lotnames=c(),
                                    machines=c(),
                                    lanes=c(),
                                    stages=c())
{
    #
    # db name is mandatory
    #
    if (nchar(db_name) == 0)
    {
        stop(sprintf("DB name was not given."))
    }
    #
    # build where-clause, if any
    #
    where_clause <- "";
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("upx_mjsid", 
                                                 mjsids))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("upi_lotname", 
                                                 lotnames))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("ufd_machine_order", 
                                                 machines))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("ufd_lane_no", 
                                                 lanes))
    where_clause <-
        sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("ufd_stage_no", 
                                                 stages))
    #
    # build entire query.
    #
    pa_view <- "u01.pa_pcb_totals_aoi_per_machine_view"
    query <- sprintf("select * from %s", pa_view);
    if (nchar(where_clause) > 0)
    {
        query <- paste(query, "where", where_clause)
    }
    #
    pa = data.frame();
    db = pg_open_db(db_name);
    #
    pa = pg_exec_query(db, query)
    #
    pg_close_db(db)
    #
    attr(pa, "mjsid") = mjsids;
    attr(pa, "lotname") = lotnames;
    #
    return(pa);
}

# get_pa_data_per_project <- function(db_name="", mjsid="", lotname="")
# {
#     pa_view <- attr(get_pa_data_per_project,"view");
#     #
#     query_mjsid_lotname_format <- 
#         "select * from %s where upx_mjsid='%s' and upi_lotname='%s'"
#     query_mjsid_format <- 
#         "select * from %s where upx_mjsid='%s'"
#     query_lotname_format <- 
#         "select * from %s where upi_lotname='%s'"
#     query_format <- 
#         "select * from %s"
#     #
#     # db name is mandatory
#     #
#     if (nchar(db_name) == 0)
#     {
#         stop(sprintf("DB name was not given."))
#     }
#     #
#     # if no product was given, then just read the
#     # entire table. 
#     #
#     if ((nchar(mjsid) != 0) && (nchar(lotname) != 0))
#     {
#         format <- attr(get_pa_data_per_project,
#                       "query_mjsid_lotname_format")
#         query = sprintf(format, pa_view, mjsid, lotname);
#     }
#     else if (nchar(mjsid) != 0)
#     {
#         format <- attr(get_pa_data_per_project,"query_mjsid_format")
#         query = sprintf(format, pa_view, mjsid);
#     }
#     else if (nchar(lotname) != 0)
#     {
#         format <- attr(get_pa_data_per_project,"query_lotname_format")
#         query = sprintf(format, pa_view, lotname);
#     }
#     else
#     {
#         format <- attr(get_pa_data_per_project,"query_format")
#         query = sprintf(format, pa_view);
#     }
#     #
#     pa = data.frame();
#     db = pg_open_db(db_name);
#     #
#     pa = pg_exec_query(db, query)
#     #
#     pg_close_db(db)
#     #
#     attr(pa, "mjsid") = mjsid;
#     attr(pa, "lotname") = lotname;
#     #
#     return(pa);
# }
# 
# attr(get_pa_data_per_project,"view") <- 
#         "u01.pa_pcb_totals_aoi_per_machine_view"
# attr(get_pa_data_per_project,"query_mjsid_lotname_format") <- 
#         "select * from %s where upx_mjsid='%s' and upi_lotname='%s'"
# attr(get_pa_data_per_project,"query_mjsid_format") <- 
#         "select * from %s where upx_mjsid='%s'"
# attr(get_pa_data_per_project,"query_lotname_format") <- 
#         "select * from %s where upi_lotname='%s'"
# attr(get_pa_data_per_project,"query_format") <- 
#         "select * from %s"
# 
pa_kmeans <- function(pa,
                      arg_mjsids=c(),
                      arg_lotnames=c(),
                      arg_machines=c(),
                      arg_lanes=c(),
                      arg_stages=c(),
                      sink.file="",
                      min.dpc_tpickup=1)
{
    #
    # get PA training data
    #
    # pa = get_pa_data_per_project("training_data2")

    #
    # sanity check
    #
    open_sink(sink.file);
    if ((nrow(pa) == 0) || (ncol(pa) == 0))
    {
        close_sink(sink.file)
        stop(sprintf("Data frames has no data."))
    }

    #
    # clean data. remove counts and times which are
    # less than zero. removing pickup counts less
    # than zero removes the negative times and counts.
    #
    pa_clean <- pa[pa$dpc_tpickup>=min.dpc_tpickup,]

    #
    # split data by product
    #
    pa_clean_prods <- split(pa_clean, pa_clean$upx_mjsid)

    #
    # get list of products
    #
    mjsids <- arg_mjsids
    if (length(mjsids) == 0)
    {
        print("setting MJSIDS to default")
        mjsids <- names(pa_clean_prods)
    }
    if (length(mjsids) == 0)
    {
        close_sink(sink.file)
        stop("MJSIDS is still a null-list")
    }

    #
    # cycle over each mjsid, etc. and calculate k-means clustering.
    #
    for (mjsid in mjsids)
    {
        #
        # get data for a product
        #
        pa_prod = pa_clean_prods[[mjsid]]

        #
        # list of lot names
        #
        lotnames <- arg_lotnames
        if (length(lotnames) == 0)
        {
            print("setting LOTNAMES to default")
            lotnames <- sort(unique(pa_prod$upi_lotname))
        }
        if (length(lotnames) == 0)
        {
            print(sprintf("LOTNAMES is still a null-list. Skipping %s.",
                          mjsid))
            next
        }
        pa_prod_lotnames <- split(pa_prod, pa_prod$upi_lotname)

        #
        # cycle over list of lotnames
        #
        for (lotname in lotnames)
        {
            #
            # get data for this mjsid and lotname
            #
            pa_prod_lotname = pa_prod_lotnames[[lotname]]

            #
            # get machine, lane and stage values lists.
            #
            machines <- arg_machines
            if (length(machines) == 0)
            {
                print("setting MACHINES to default")
                machines <- sort(unique(pa_prod_lotname$ufd_machine_order))
            }
            if (length(machines) == 0)
            {
                print(sprintf("MACHINES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            lanes <- arg_lanes
            if (length(lanes) == 0)
            {
                print("setting LANES to default")
                lanes <- sort(unique(pa_prod_lotname$ufd_lane_no))
            }
            if (length(lanes) == 0)
            {
                print(sprintf("LANES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            stages <- arg_stages
            if (length(stages) == 0)
            {
                print("setting STAGES to default")
                stages <- sort(unique(pa_prod_lotname$ufd_stage_no))
            }
            if (length(stages) == 0)
            {
                print(sprintf("STAGES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            #
            # cycle and calculate k-means clustering.
            #
            for (machine in machines)
            {
                for (lane in lanes)
                {
                    for (stage in stages)
                    {
                        #
                        # get the data for this product
                        #
                        pa_km_data = 
                            pa_prod_lotname[((pa_prod_lotname$ufd_machine_order == machine) &
                                             (pa_prod_lotname$ufd_lane_no == lane) &
                                             (pa_prod_lotname$ufd_stage_no == stage)),]
            
                        #
                        # check if we have any data
                        #
                        pa_km_data_rows = nrow(pa_km_data)
                        if (pa_km_data_rows == 0)
                        {
                            print(sprintf("Skipping since NO DATA."))
                            next
                        }
                        print(sprintf("(mjsid,lotname,machine,lane,stage,nrow) ... (%s,%s,%d,%d,%d,%d)", 
                                      mjsid, 
                                      lotname, 
                                      machine, 
                                      lane, 
                                      stage, 
                                      pa_km_data_rows))
        
                        #
                        # separate counts and time data
                        #
                        pa_km_count <- subset(pa_km_data,
                                              select=pa_count_km_cols)
                        pa_km_time <- subset(pa_km_data,
                                             select=pa_time_km_cols)
    
                        # print(count(pa_km_count$dpc_tpickup))
                        # print(count(pa_km_time$dpt_actual))
                        # print(unique(pa_km_count$ufd_machine_order))
                        # print(unique(pa_km_count$ufd_lane_no))
                        # print(unique(pa_km_count$ufd_stage_no))
    
                        #
                        # run kmeans for two clusters: pass or fail for AOI
                        #
                        fit_count = kmeans(pa_km_count, 2, iter.max=50)
                        fit_time = kmeans(pa_km_time, 2, iter.max=50)
   
                        #
                        # check the fit
                        #
                        print("====>>>> AOI Results <<<<====")
                        print(count(pa_km_data$p_cmp))
                        aoi_pass = 
                            length(pa_km_data$p_cmp[pa_km_data$p_cmp==-1])
                        aoi_fail = 
                            length(pa_km_data$p_cmp[pa_km_data$p_cmp==1])

                        print("====>>>> COUNT <<<<====")
                        print(count(fit_count$cluster))

                        cluster1 = pa_km_data[fit_count$cluster==1,"p_cmp"]
                        print(count(cluster1))

                        count_cluster1_aoi_pass = 
                            length(cluster1[cluster1==-1])
                        count_cluster1_aoi_fail = 
                            length(cluster1[cluster1==1])
                        print(sprintf("cluster 1 pass/aoi pass = %f %%",
                                      100*count_cluster1_aoi_pass/aoi_pass))
                        print(sprintf("cluster 1 fail/aoi fail = %f %%",
                                      100*count_cluster1_aoi_fail/aoi_fail))

                        cluster2 = pa_km_data[fit_count$cluster==2,"p_cmp"]
                        print(count(cluster2))

                        count_cluster2_aoi_pass = 
                            length(cluster2[cluster2==-1])
                        count_cluster2_aoi_fail = 
                            length(cluster2[cluster2==1])
                        print(sprintf("cluster 2 pass/aoi pass = %f %%",
                                      100*count_cluster2_aoi_pass/aoi_pass))
                        print(sprintf("cluster 2 fail/aoi fail = %f %%",
                                      100*count_cluster2_aoi_fail/aoi_fail))

                        print("====>>>> TIME <<<<====")
                        print(count(fit_time$cluster))

                        cluster1 = pa_km_data[fit_time$cluster==1,"p_cmp"]
                        print(count(cluster1))

                        time_cluster1_aoi_pass = 
                            length(cluster1[cluster1==-1])
                        time_cluster1_aoi_fail = 
                            length(cluster1[cluster1==1])
                        print(sprintf("cluster 1 pass/aoi pass = %f %%",
                                      100*time_cluster1_aoi_pass/aoi_pass))
                        print(sprintf("cluster 1 fail/aoi fail = %f %%",
                                      100*time_cluster1_aoi_fail/aoi_fail))

                        cluster2 = pa_km_data[fit_time$cluster==2,"p_cmp"]
                        print(count(cluster2))
                        time_cluster2_aoi_pass = 
                            length(cluster2[cluster2==-1])
                        time_cluster2_aoi_fail = 
                            length(cluster2[cluster2==1])
                        print(sprintf("cluster 2 pass/aoi pass = %f %%",
                                      100*time_cluster2_aoi_pass/aoi_pass))
                        print(sprintf("cluster 2 fail/aoi fail = %f %%",
                                      100*time_cluster2_aoi_fail/aoi_fail))
                    }
                }
            }
        }
    }
    #
    close_sink(sink.file)
}

pa_kmeans_for_cols <- function(db_name,
                               pa,
                               pa_km_cols,
                               arg_mjsids=c(),
                               arg_lotnames=c(),
                               arg_machines=c(),
                               arg_lanes=c(),
                               arg_stages=c(),
                               sink.file="",
                               min.dpc_tpickup=1,
                               num.clusters=2,
                               num.starts=20,
                               max.iters=50)
{
    #
    # get PA training data
    #
    # pa = get_pa_data_per_project("training_data2")

    #
    # do we have a log file?
    #
    open_sink(sink.file)

    #
    # sanity checks
    #
    if ((nrow(pa) == 0) || (ncol(pa) == 0))
    {
        close_sink(sink.file);
        stop(sprintf("Data frames has no data."))
    }
    if (length(pa_km_cols) == 0)
    {
        close_sink(sink.file);
        stop(sprintf("List of PA columns is empty."))
    }
    if (num.clusters < 1)
    {
        close_sink(sink.file);
        stop(sprintf("Number of clusters is less than 1."))
    }
    if (max.iters < 1)
    {
        close_sink(sink.file);
        stop(sprintf("Maximum iterations is less than 1."))
    }

    #
    # clean data. remove counts and times which are
    # less than zero. removing pickup counts less
    # than zero removes the negative times and counts.
    #
    pa_clean <- pa[pa$dpc_tpickup>=min.dpc_tpickup,]

    #
    # split data by product
    #
    pa_clean_prods <- split(pa_clean, pa_clean$upx_mjsid)

    #
    # get list of products
    #
    mjsids <- arg_mjsids
    if (length(mjsids) == 0)
    {
        print("setting MJSIDS to default")
        mjsids <- names(pa_clean_prods)
    }
    if (length(mjsids) == 0)
    {
        close_sink(sink.file);
        stop("MJSIDS is still a null-list")
    }

    #
    # cycle over each mjsid, etc. and calculate k-means clustering.
    #
    for (mjsid in mjsids)
    {
        #
        # get data for a product
        #
        pa_prod = pa_clean_prods[[mjsid]]
        if (is.null(pa_prod))
        {
            print(sprintf("NO DATA for this MSJID: %s", mjsid))
            next
        }

        #
        # list of lot names
        #
        lotnames <- arg_lotnames
        if (length(lotnames) == 0)
        {
            print("setting LOTNAMES to default")
            lotnames <- sort(unique(pa_prod$upi_lotname))
        }
        if (length(lotnames) == 0)
        {
            print(sprintf("LOTNAMES is still a null-list. Skipping %s.",
                          mjsid))
            next
        }
        pa_prod_lotnames <- split(pa_prod, pa_prod$upi_lotname)

        #
        # cycle over list of lotnames
        #
        for (lotname in lotnames)
        {
            #
            # get data for this mjsid and lotname
            #
            pa_prod_lotname = pa_prod_lotnames[[lotname]]
            if (is.null(pa_prod_lotname))
            {
                print(sprintf("NO DATA for this MSJID,LOTNAME: %s,%s",
                              mjsid, lotname))
                next
            }

            #
            # get machine, lane and stage values lists.
            #
            machines <- arg_machines
            if (length(machines) == 0)
            {
                print("setting MACHINES to default")
                machines <- sort(unique(pa_prod_lotname$ufd_machine_order))
            }
            if (length(machines) == 0)
            {
                print(sprintf("MACHINES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            lanes <- arg_lanes
            if (length(lanes) == 0)
            {
                print("setting LANES to default")
                lanes <- sort(unique(pa_prod_lotname$ufd_lane_no))
            }
            if (length(lanes) == 0)
            {
                print(sprintf("LANES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            stages <- arg_stages
            if (length(stages) == 0)
            {
                print("setting STAGES to default")
                stages <- sort(unique(pa_prod_lotname$ufd_stage_no))
            }
            if (length(stages) == 0)
            {
                print(sprintf("STAGES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            #
            # determine which machine contained the failed
            # part detected by the AOI machine, if possible.
            #
#             bad_pcbs <- get_bad_pcb_per_machine(db_name,
#                                                 mjsids=c(mjsid),
#                                                 lotnames=c(lotname),
#                                                 machines=machines,
#                                                 lanes=lanes,
#                                                 stages=stages)
#             print(sprintf("Number of BAD PCBS per MACHINE: %d",
#                           nrow(bad_pcbs)))

            #
            # cycle and calculate k-means clustering.
            #
            for (machine in machines)
            {
                for (lane in lanes)
                {
                    for (stage in stages)
                    {
                        #
                        # get the data for this product
                        #
                        pa_km_data = 
                            pa_prod_lotname[((pa_prod_lotname$ufd_machine_order == machine) &
                                             (pa_prod_lotname$ufd_lane_no == lane) &
                                             (pa_prod_lotname$ufd_stage_no == stage)),]
            
                        #
                        # check if we have any data
                        #
                        pa_km_data_rows = nrow(pa_km_data)
                        if (pa_km_data_rows == 0)
                        {
                            print(sprintf("Skipping since NO DATA."))
                            next
                        }
                        print(sprintf("(mjsid,lotname,machine,lane,stage,nrow) ... (%s,%s,%d,%d,%d,%d)", 
                                      mjsid, 
                                      lotname, 
                                      machine, 
                                      lane, 
                                      stage, 
                                      pa_km_data_rows))
        
                        #
                        # get counts for kmeans
                        #
                        selected <- subset(pa_km_data, select=pa_km_cols)
    
                        # print(count(selected$dpc_tpickup))
                        # print(count(selected$dpt_actual))
                        # print(unique(selected$ufd_machine_order))
                        # print(unique(selected$ufd_lane_no))
                        # print(unique(selected$ufd_stage_no))
    
                        #
                        # normalize the data
                        #
                        selected_max = lapply(lapply(selected, abs), max)
                        selected_max[selected_max == 0] = 1
                        selected_normalized = selected/selected_max

                        #
                        # run kmeans for two clusters: pass or fail for AOI
                        #
                        fit <<- kmeans(selected_normalized, 
                                     num.clusters, 
                                     nstart=num.starts,
                                     iter.max=max.iters)
   
                        #
                        # check the fit
                        #
                        print("====>>>> Table AOI Results <<<<====")
                        table_results <- 
                            100.0*table(fit$cluster, 
                                        pa_km_data$p_cmp)/pa_km_data_rows
                        # print(100.0*table(fit$cluster, pa_km_data$p_cmp)/pa_km_data_rows)
                        colnames(table_results) <- c("Pass", "Fail")
                        print(table_results)

                        print("====>>>> AOI Results <<<<====")
                        print(count(pa_km_data$p_cmp))
                        aoi_pass = 
                            length(pa_km_data$p_cmp[pa_km_data$p_cmp==-1])
                        aoi_fail = 
                            length(pa_km_data$p_cmp[pa_km_data$p_cmp==1])

                        print("====>>>> SELECTED <<<<====")
                        print(count(fit$cluster))

                        cluster1 = pa_km_data[fit$cluster==1,"p_cmp"]
                        print(count(cluster1))

                        count_cluster1_aoi_pass = 
                            length(cluster1[cluster1==-1])
                        count_cluster1_aoi_fail = 
                            length(cluster1[cluster1==1])
                        print(sprintf("cluster 1 pass/aoi pass = %f %%",
                                      100*count_cluster1_aoi_pass/aoi_pass))
                        print(sprintf("cluster 1 fail/aoi fail = %f %%",
                                      100*count_cluster1_aoi_fail/aoi_fail))

                        cluster2 = pa_km_data[fit$cluster==2,"p_cmp"]
                        print(count(cluster2))

                        count_cluster2_aoi_pass = 
                            length(cluster2[cluster2==-1])
                        count_cluster2_aoi_fail = 
                            length(cluster2[cluster2==1])
                        print(sprintf("cluster 2 pass/aoi pass = %f %%",
                                      100*count_cluster2_aoi_pass/aoi_pass))
                        print(sprintf("cluster 2 fail/aoi fail = %f %%",
                                      100*count_cluster2_aoi_fail/aoi_fail))
                    }
                }
            }
        }
    }
    #
    close_sink(sink.file);
}

old_pa_hclust_for_cols <- function(db_name,
                               pa,
                               pa_km_cols,
                               arg_mjsids=c(),
                               arg_lotnames=c(),
                               arg_machines=c(),
                               arg_lanes=c(),
                               arg_stages=c(),
                               sink.file="",
                               min.dpc_tpickup=1,
                               max.clusters=2,
                               method="average")
{
    #
    # get PA training data
    #
    # pa = get_pa_data_per_project("training_data2")

    #
    # do we have a log file?
    #
    open_sink(sink.file)

    #
    # sanity checks
    #
    if ((nrow(pa) == 0) || (ncol(pa) == 0))
    {
        close_sink(sink.file);
        stop(sprintf("Data frames has no data."))
    }
    if (length(pa_km_cols) == 0)
    {
        close_sink(sink.file);
        stop(sprintf("List of PA columns is empty."))
    }
    if (max.clusters < 2)
    {
        close_sink(sink.file);
        stop(sprintf("Number of clusters is less than 2."))
    }

    #
    # clean data. remove counts and times which are
    # less than zero. removing pickup counts less
    # than zero removes the negative times and counts.
    #
    pa_clean <- pa[pa$dpc_tpickup>=min.dpc_tpickup,]

    #
    # split data by product
    #
    pa_clean_prods <- split(pa_clean, pa_clean$upx_mjsid)

    #
    # get list of products
    #
    mjsids <- arg_mjsids
    if (length(mjsids) == 0)
    {
        print("setting MJSIDS to default")
        mjsids <- names(pa_clean_prods)
    }
    if (length(mjsids) == 0)
    {
        close_sink(sink.file);
        stop("MJSIDS is still a null-list")
    }

    #
    # cycle over each mjsid, etc. and calculate k-means clustering.
    #
    for (mjsid in mjsids)
    {
        #
        # get data for a product
        #
        pa_prod = pa_clean_prods[[mjsid]]
        if (is.null(pa_prod))
        {
            print(sprintf("NO DATA for this MSJID: %s", mjsid))
            next
        }

        #
        # list of lot names
        #
        lotnames <- arg_lotnames
        if (length(lotnames) == 0)
        {
            print("setting LOTNAMES to default")
            lotnames <- sort(unique(pa_prod$upi_lotname))
        }
        if (length(lotnames) == 0)
        {
            print(sprintf("LOTNAMES is still a null-list. Skipping %s.",
                          mjsid))
            next
        }
        pa_prod_lotnames <- split(pa_prod, pa_prod$upi_lotname)

        #
        # cycle over list of lotnames
        #
        for (lotname in lotnames)
        {
            #
            # get data for this mjsid and lotname
            #
            pa_prod_lotname = pa_prod_lotnames[[lotname]]
            if (is.null(pa_prod_lotname))
            {
                print(sprintf("NO DATA for this MSJID,LOTNAME: %s,%s",
                              mjsid, lotname))
                next
            }

            #
            # get machine, lane and stage values lists.
            #
            machines <- arg_machines
            if (length(machines) == 0)
            {
                print("setting MACHINES to default")
                machines <- sort(unique(pa_prod_lotname$ufd_machine_order))
            }
            if (length(machines) == 0)
            {
                print(sprintf("MACHINES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            lanes <- arg_lanes
            if (length(lanes) == 0)
            {
                print("setting LANES to default")
                lanes <- sort(unique(pa_prod_lotname$ufd_lane_no))
            }
            if (length(lanes) == 0)
            {
                print(sprintf("LANES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            stages <- arg_stages
            if (length(stages) == 0)
            {
                print("setting STAGES to default")
                stages <- sort(unique(pa_prod_lotname$ufd_stage_no))
            }
            if (length(stages) == 0)
            {
                print(sprintf("STAGES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            #
            # determine which machine contained the failed
            # part detected by the AOI machine, if possible.
            #
#             bad_pcbs <- get_bad_pcb_per_machine(db_name,
#                                                 mjsids=c(mjsid),
#                                                 lotnames=c(lotname),
#                                                 machines=machines,
#                                                 lanes=lanes,
#                                                 stages=stages)
#             print(sprintf("Number of BAD PCBS per MACHINE: %d",
#                           nrow(bad_pcbs)))

            #
            # cycle and calculate k-means clustering.
            #
            for (machine in machines)
            {
                for (lane in lanes)
                {
                    for (stage in stages)
                    {
                        #
                        # get the data for this product
                        #
                        pa_km_data = 
                            pa_prod_lotname[((pa_prod_lotname$ufd_machine_order == machine) &
                                             (pa_prod_lotname$ufd_lane_no == lane) &
                                             (pa_prod_lotname$ufd_stage_no == stage)),]
            
                        #
                        # check if we have any data
                        #
                        pa_km_data_rows = nrow(pa_km_data)
                        if (pa_km_data_rows == 0)
                        {
                            print(sprintf("Skipping since NO DATA."))
                            next
                        }
                        print(sprintf("(mjsid,lotname,machine,lane,stage,nrow) ... (%s,%s,%d,%d,%d,%d)", 
                                      mjsid, 
                                      lotname, 
                                      machine, 
                                      lane, 
                                      stage, 
                                      pa_km_data_rows))
        
                        #
                        # get counts for kmeans
                        #
                        selected <- subset(pa_km_data, select=pa_km_cols)
    
                        # print(count(selected$dpc_tpickup))
                        # print(count(selected$dpt_actual))
                        # print(unique(selected$ufd_machine_order))
                        # print(unique(selected$ufd_lane_no))
                        # print(unique(selected$ufd_stage_no))
    
                        #
                        # normalize the data
                        #
                        selected_max = lapply(lapply(selected, abs), max)
                        selected_max[selected_max == 0] = 1
                        selected_normalized = selected/selected_max

                        #
                        # run hclusts
                        #
                        dist_sn <<- dist(selected_normalized)
                        clusters <<- hclust(dist_sn, method="ward.D")
   
                        #
                        # plot clusters
                        #
                        # plot(clusters, hang=-1, cex=0.8, main="Average Linkage Clustering")

                        #
                        # use table to show clusters
                        #
                        for (iclusts in 2:max.clusters)
                        {
                            print(sprintf("Cluster size: %d", iclusts))

                            num=length(pa_km_data$p_cmp)
                            print(100.0*count(pa_km_data$p_cmp)/num)

                            clusterCut <- cutree(clusters, iclusts)
                            table_results <- 
                                table(clusterCut, pa_km_data$p_cmp)
                            colnames(table_results) <- c("Pass", "Fail")
                            print(table_results)

                        }
                    }
                }
            }
        }
    }
    #
    close_sink(sink.file);
}

pa_hclust_for_cols <- function(db_name="training_data2",
                               pa_km_cols=pa_time_count_km_cols,
                               arg_mjsids=c(),
                               arg_lotnames=c(),
                               arg_machines=c(),
                               arg_lanes=c(),
                               arg_stages=c(),
                               sink.file="",
                               min.dpc_tpickup=1,
                               max.clusters=5,
                               method="average")
{
    #
    # get PA training data
    #
    pa = get_pa_data_per_project(db_name)

    #
    # do we have a log file?
    #
    open_sink(sink.file)

    #
    # sanity checks
    #
    if ((nrow(pa) == 0) || (ncol(pa) == 0))
    {
        close_sink(sink.file);
        stop(sprintf("Data frames has no data."))
    }
    if (length(pa_km_cols) == 0)
    {
        close_sink(sink.file);
        stop(sprintf("List of PA columns is empty."))
    }
    if (max.clusters < 2)
    {
        close_sink(sink.file);
        stop(sprintf("Number of clusters is less than 2."))
    }

    #
    # clean data. remove counts and times which are
    # less than zero. removing pickup counts less
    # than zero removes the negative times and counts.
    #
    pa_clean <- pa[pa$dpc_tpickup>=min.dpc_tpickup,]

    #
    # split data by product
    #
    pa_clean_prods <- split(pa_clean, pa_clean$upx_mjsid)

    #
    # get list of products
    #
    mjsids <- arg_mjsids
    if (length(mjsids) == 0)
    {
        print("setting MJSIDS to default")
        mjsids <- names(pa_clean_prods)
    }
    if (length(mjsids) == 0)
    {
        close_sink(sink.file);
        stop("MJSIDS is still a null-list")
    }

    #
    # cycle over each mjsid, etc. and calculate k-means clustering.
    #
    for (mjsid in mjsids)
    {
        #
        # get data for a product
        #
        pa_prod = pa_clean_prods[[mjsid]]
        if (is.null(pa_prod))
        {
            print(sprintf("NO DATA for this MSJID: %s", mjsid))
            next
        }

        #
        # list of lot names
        #
        lotnames <- arg_lotnames
        if (length(lotnames) == 0)
        {
            print("setting LOTNAMES to default")
            lotnames <- sort(unique(pa_prod$upi_lotname))
        }
        if (length(lotnames) == 0)
        {
            print(sprintf("LOTNAMES is still a null-list. Skipping %s.",
                          mjsid))
            next
        }
        pa_prod_lotnames <- split(pa_prod, pa_prod$upi_lotname)

        #
        # cycle over list of lotnames
        #
        for (lotname in lotnames)
        {
            #
            # get data for this mjsid and lotname
            #
            pa_prod_lotname = pa_prod_lotnames[[lotname]]
            if (is.null(pa_prod_lotname))
            {
                print(sprintf("NO DATA for this MSJID,LOTNAME: %s,%s",
                              mjsid, lotname))
                next
            }

            #
            # get machine, lane and stage values lists.
            #
            machines <- arg_machines
            if (length(machines) == 0)
            {
                print("setting MACHINES to default")
                machines <- sort(unique(pa_prod_lotname$ufd_machine_order))
            }
            if (length(machines) == 0)
            {
                print(sprintf("MACHINES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            lanes <- arg_lanes
            if (length(lanes) == 0)
            {
                print("setting LANES to default")
                lanes <- sort(unique(pa_prod_lotname$ufd_lane_no))
            }
            if (length(lanes) == 0)
            {
                print(sprintf("LANES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            stages <- arg_stages
            if (length(stages) == 0)
            {
                print("setting STAGES to default")
                stages <- sort(unique(pa_prod_lotname$ufd_stage_no))
            }
            if (length(stages) == 0)
            {
                print(sprintf("STAGES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            #
            # cycle and h-clusters
            #
            for (machine in machines)
            {
                for (lane in lanes)
                {
                    for (stage in stages)
                    {
                        #
                        # get the data for this product
                        #
                        pa_km_data = 
                            pa_prod_lotname[((pa_prod_lotname$ufd_machine_order == machine) &
                                             (pa_prod_lotname$ufd_lane_no == lane) &
                                             (pa_prod_lotname$ufd_stage_no == stage)),]
            
                        #
                        # check if we have any data
                        #
                        pa_km_data_rows = nrow(pa_km_data)
                        if (pa_km_data_rows == 0)
                        {
                            print(sprintf("Skipping since NO DATA."))
                            next
                        }
                        print(sprintf("(mjsid,lotname,machine,lane,stage,nrow) ... (%s,%s,%d,%d,%d,%d)", 
                                      mjsid, 
                                      lotname, 
                                      machine, 
                                      lane, 
                                      stage, 
                                      pa_km_data_rows))
        
                        #
                        # get counts for kmeans
                        #
                        selected <- subset(pa_km_data, select=pa_km_cols)
    
                        # print(count(selected$dpc_tpickup))
                        # print(count(selected$dpt_actual))
                        # print(unique(selected$ufd_machine_order))
                        # print(unique(selected$ufd_lane_no))
                        # print(unique(selected$ufd_stage_no))
    
                        #
                        # normalize the data
                        #
                        selected_max = lapply(lapply(selected, abs), max)
                        selected_max[selected_max == 0] = 1
                        selected_normalized = selected/selected_max

                        #
                        # run hclusts
                        #
                        dist_sn <<- dist(selected_normalized)
                        clusters <<- hclust(dist_sn, method=method)
   
                        #
                        # plot clusters
                        #
                        # plot(clusters, hang=-1, cex=0.8, main="Average Linkage Clustering")

                        #
                        # use table to show clusters
                        #
                        for (iclusts in 2:max.clusters)
                        {
                            print(sprintf("Cluster size: %d", iclusts))

                            print(count(pa_km_data$p_cmp))

                            clusterCut <- cutree(clusters, iclusts)
                            table_results <- 
                                table(clusterCut, pa_km_data$p_cmp)
                            colnames(table_results) <- c("Pass", "Fail")
                            print(table_results)

                            for (xxx in names(selected_normalized))
                            {
                                print(sprintf("Field: %s", xxx))
                                print(table(clusterCut, selected_normalized[[xxx]]))
                            }
                        }
                    }
                }
            }
        }
    }
    #
    close_sink(sink.file);
}

pa_pca_for_cols <- function(db_name="training_data2",
                            pa_km_cols=pa_time_count_km_cols,
                            arg_mjsids=c(),
                            arg_lotnames=c(),
                            arg_machines=c(),
                            arg_lanes=c(),
                            arg_stages=c(),
                            sink.file="",
                            min.dpc_tpickup=1,
                            max.iter=100,
                            method="average")
{
    #
    # get PA training data
    #
    pa = get_pa_data_per_project(db_name)

    #
    # do we have a log file?
    #
    open_sink(sink.file)

    #
    # sanity checks
    #
    if ((nrow(pa) == 0) || (ncol(pa) == 0))
    {
        close_sink(sink.file);
        stop(sprintf("Data frames has no data."))
    }
    if (length(pa_km_cols) == 0)
    {
        close_sink(sink.file);
        stop(sprintf("List of PA columns is empty."))
    }
    if (max.clusters < 2)
    {
        close_sink(sink.file);
        stop(sprintf("Number of clusters is less than 2."))
    }

    #
    # clean data. remove counts and times which are
    # less than zero. removing pickup counts less
    # than zero removes the negative times and counts.
    #
    pa_clean <- pa[pa$dpc_tpickup>=min.dpc_tpickup,]

    #
    # split data by product
    #
    pa_clean_prods <- split(pa_clean, pa_clean$upx_mjsid)

    #
    # get list of products
    #
    mjsids <- arg_mjsids
    if (length(mjsids) == 0)
    {
        print("setting MJSIDS to default")
        mjsids <- names(pa_clean_prods)
    }
    if (length(mjsids) == 0)
    {
        close_sink(sink.file);
        stop("MJSIDS is still a null-list")
    }

    #
    # cycle over each mjsid, etc. and calculate k-means clustering.
    #
    for (mjsid in mjsids)
    {
        #
        # get data for a product
        #
        pa_prod = pa_clean_prods[[mjsid]]
        if (is.null(pa_prod))
        {
            print(sprintf("NO DATA for this MSJID: %s", mjsid))
            next
        }

        #
        # list of lot names
        #
        lotnames <- arg_lotnames
        if (length(lotnames) == 0)
        {
            print("setting LOTNAMES to default")
            lotnames <- sort(unique(pa_prod$upi_lotname))
        }
        if (length(lotnames) == 0)
        {
            print(sprintf("LOTNAMES is still a null-list. Skipping %s.",
                          mjsid))
            next
        }
        pa_prod_lotnames <- split(pa_prod, pa_prod$upi_lotname)

        #
        # cycle over list of lotnames
        #
        for (lotname in lotnames)
        {
            #
            # get data for this mjsid and lotname
            #
            pa_prod_lotname = pa_prod_lotnames[[lotname]]
            if (is.null(pa_prod_lotname))
            {
                print(sprintf("NO DATA for this MSJID,LOTNAME: %s,%s",
                              mjsid, lotname))
                next
            }

            #
            # get machine, lane and stage values lists.
            #
            machines <- arg_machines
            if (length(machines) == 0)
            {
                print("setting MACHINES to default")
                machines <- sort(unique(pa_prod_lotname$ufd_machine_order))
            }
            if (length(machines) == 0)
            {
                print(sprintf("MACHINES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            lanes <- arg_lanes
            if (length(lanes) == 0)
            {
                print("setting LANES to default")
                lanes <- sort(unique(pa_prod_lotname$ufd_lane_no))
            }
            if (length(lanes) == 0)
            {
                print(sprintf("LANES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            stages <- arg_stages
            if (length(stages) == 0)
            {
                print("setting STAGES to default")
                stages <- sort(unique(pa_prod_lotname$ufd_stage_no))
            }
            if (length(stages) == 0)
            {
                print(sprintf("STAGES is still a null-list. Skipping %s.",
                              mjsid))
                next
            }

            #
            # cycle and h-clusters
            #
            for (machine in machines)
            {
                for (lane in lanes)
                {
                    for (stage in stages)
                    {
                        #
                        # get the data for this product
                        #
                        pa_km_data = 
                            pa_prod_lotname[((pa_prod_lotname$ufd_machine_order == machine) &
                                             (pa_prod_lotname$ufd_lane_no == lane) &
                                             (pa_prod_lotname$ufd_stage_no == stage)),]
            
                        #
                        # check if we have any data
                        #
                        pa_km_data_rows = nrow(pa_km_data)
                        if (pa_km_data_rows == 0)
                        {
                            print(sprintf("Skipping since NO DATA."))
                            next
                        }
                        print(sprintf("(mjsid,lotname,machine,lane,stage,nrow) ... (%s,%s,%d,%d,%d,%d)", 
                                      mjsid, 
                                      lotname, 
                                      machine, 
                                      lane, 
                                      stage, 
                                      pa_km_data_rows))
        
                        #
                        # get counts for kmeans
                        #
                        selected <- subset(pa_km_data, select=pa_km_cols)
    
                        # print(count(selected$dpc_tpickup))
                        # print(count(selected$dpt_actual))
                        # print(unique(selected$ufd_machine_order))
                        # print(unique(selected$ufd_lane_no))
                        # print(unique(selected$ufd_stage_no))
    
                        #
                        # normalize the data
                        #
                        selected_max = lapply(lapply(selected, abs), max)
                        selected_max[selected_max == 0] = 1
                        selected_normalized = selected/selected_max

                        #
                        # run hclusts
                        #
                        dist_sn <<- dist(selected_normalized)
                        clusters <<- hclust(dist_sn, method=method)
   
                        #
                        # plot clusters
                        #
                        # plot(clusters, hang=-1, cex=0.8, main="Average Linkage Clustering")

                        #
                        # use table to show clusters
                        #
                        for (iclusts in 2:max.clusters)
                        {
                            print(sprintf("Cluster size: %d", iclusts))

                            print(count(pa_km_data$p_cmp))

                            clusterCut <- cutree(clusters, iclusts)
                            table_results <- 
                                table(clusterCut, pa_km_data$p_cmp)
                            colnames(table_results) <- c("Pass", "Fail")
                            print(table_results)

                            for (xxx in names(selected_normalized))
                            {
                                print(sprintf("Field: %s", xxx))
                                print(table(clusterCut, selected_normalized[[xxx]]))
                            }
                        }
                    }
                }
            }
        }
    }
    #
    close_sink(sink.file);
}

