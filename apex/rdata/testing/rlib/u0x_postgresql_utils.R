#
# return queries and order-by clauses separately
#
pg_load_count_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, dpc._filename_id, dpc._pcb_id, dpc._pcb_serial, dpc._machine_order, dpc._lane_no, dpc._stage_no, dpc._timestamp, dpc._mjsid, dpc._lotname, dpc._output_no, dpc._bndrcgstop, dpc._bndstop, dpc._board, dpc._brcgstop, dpc._bwait, dpc._cderr, dpc._cmerr, dpc._cnvstop, dpc._cperr, dpc._crerr, dpc._cterr, dpc._cwait, dpc._fbstop, dpc._fwait, dpc._jointpasswait, dpc._judgestop, dpc._lotboard, dpc._lotmodule, dpc._mcfwait, dpc._mcrwait, dpc._mhrcgstop, dpc._module, dpc._otherlstop, dpc._othrstop, dpc._pwait, dpc._rwait, dpc._scestop, dpc._scstop, dpc._swait, dpc._tdispense, dpc._tdmiss, dpc._thmiss, dpc._tmmiss, dpc._tmount, dpc._tpickup, dpc._tpmiss, dpc._tpriming, dpc._trbl, dpc._trmiss, dpc._trserr, dpc._trsmiss from u01.filename_to_fid ftf inner join u01.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u01.delta_pivot_count dpc on dpc._filename_id = ftf._filename_id and dpc._lane_no = ufd._lane_no and dpc._stage_no = ufd._stage_no", 
order_by="order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp"))
}

pg_load_feeder_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, df._fadd, df._fsadd, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, df._filename_id, df._pcb_id, df._pcb_serial, df._machine_order, df._lane_no, df._stage_no, df._timestamp, df._mjsid, df._lotname, df._reelid, df._partsname, df._output_no, df._blkserial, df._pickup, df._pmiss, df._rmiss, df._dmiss, df._mmiss, df._hmiss, df._trsmiss, df._mount from u01.filename_to_fid ftf inner join u01.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u01.delta_feeder df on df._filename_id = ftf._filename_id and df._lane_no = ufd._lane_no and df._stage_no = ufd._stage_no", 
order_by="order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, df._fadd, df._fsadd"))
}

pg_load_nozzle_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, dn._filename_id, dn._pcb_id, dn._pcb_serial, dn._machine_order, dn._lane_no, dn._stage_no, dn._timestamp, dn._nhadd, dn._ncadd, dn._mjsid, dn._lotname, dn._output_no, dn._pickup, dn._pmiss, dn._rmiss, dn._dmiss, dn._mmiss, dn._hmiss, dn._trsmiss, dn._mount from u01.filename_to_fid ftf inner join u01.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u01.delta_nozzle as dn on dn._filename_id = ftf._filename_id and dn._lane_no = ufd._lane_no and dn._stage_no = ufd._stage_no", 
order_by="order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, dn._nhadd, dn._ncadd"))
}

pg_load_time_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, dpt._filename_id, dpt._pcb_id, dpt._pcb_serial, dpt._machine_order, dpt._lane_no, dpt._stage_no, dpt._timestamp, dpt._mjsid, dpt._lotname, dpt._output_no, dpt._actual, dpt._bndrcgstop, dpt._bndstop, dpt._brcg, dpt._brcgstop, dpt._bwait, dpt._cderr, dpt._change, dpt._cmerr, dpt._cnvstop, dpt._cperr, dpt._crerr, dpt._cterr, dpt._cwait, dpt._dataedit, dpt._fbstop, dpt._fwait, dpt._idle, dpt._jointpasswait, dpt._judgestop, dpt._load, dpt._mcfwait, dpt._mcrwait, dpt._mente, dpt._mhrcgstop, dpt._mount, dpt._otherlstop, dpt._othrstop, dpt._poweron, dpt._prdstop, dpt._prod, dpt._prodview, dpt._pwait, dpt._rwait, dpt._scestop, dpt._scstop, dpt._swait, dpt._totalstop, dpt._trbl, dpt._trserr, dpt._unitadjust from u01.filename_to_fid ftf inner join u01.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u01.delta_pivot_time dpt on dpt._filename_id = ftf._filename_id and dpt._lane_no = ufd._lane_no and dpt._stage_no = ufd._stage_no", 
order_by="order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp"))
}

pg_load_mount_exchange_reel_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, mxr._fadd, mxr._fsadd, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, mxr._filename_id, mxr._blkcode, mxr._blkserial, mxr._ftype, mxr._use, mxr._pestatus, mxr._pcstatus, mxr._remain, mxr._init, mxr._partsname, mxr._custom1, mxr._custom2, mxr._custom3, mxr._custom4, mxr._reelid, mxr._partsemp, mxr._active from u03.filename_to_fid ftf inner join u03.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u03.mountexchangereel mxr on mxr._filename_id = ftf._filename_id", 
order_by="order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, mxr._fadd, mxr._fsadd"))
}

pg_load_mount_latest_reel_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, mlr._fadd, mlr._fsadd, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, mlr._filename_id, mlr._blkcode, mlr._blkserial, mlr._ftype, mlr._use, mlr._pestatus, mlr._pcstatus, mlr._remain, mlr._init, mlr._partsname, mlr._custom1, mlr._custom2, mlr._custom3, mlr._custom4, mlr._reelid, mlr._partsemp, mlr._active, mlr._tgserial from u03.filename_to_fid ftf inner join u03.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u03.mountlatestreel mlr on mlr._filename_id = ftf._filename_id", 
order_by="order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, mlr._fadd, mlr._fsadd"))
}

pg_load_mount_normal_trace_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, mnt._fadd, mnt._fsadd, mnt._nhadd, mnt._ncadd, ftf._filename_timestamp, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, mnt._filename_id, mnt._b, mnt._idnum, mnt._reelid from u03.filename_to_fid ftf inner join u03.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u03.mountnormaltrace mnt on mnt._filename_id = ftf._filename_id", 
order_by = "order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, mnt._fadd, mnt._fsadd, mnt._nhadd, mnt._ncadd"))
}

pg_load_mount_quality_trace_query <- function()
{
    return(list(
query="select ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, mqt._fadd, mqt._fsadd, mqt._nhadd, mqt._ncadd, ftf._filename, ftf._filename_type, ftf._filename_id, ufd._filename_id, ufd._date, ufd._pcb_serial, ufd._pcb_id, ufd._output_no, ufd._pcb_id_lot_no, ufd._pcb_id_serial_no, mqt._filename_id, mqt._b, mqt._idnum, mqt._turn, mqt._ms, mqt._ts, mqt._fblkcode, mqt._fblkserial, mqt._nblkcode, mqt._nblkserial, mqt._reelid, mqt._f, mqt._rcgx, mqt._rcgy, mqt._rcga, mqt._tcx, mqt._tcy, mqt._mposirecx, mqt._mposirecy, mqt._mposireca, mqt._mposirecz, mqt._thmax, mqt._thave, mqt._mntcx, mqt._mntcy, mqt._mntca, mqt._tlx, mqt._tly, mqt._inspectarea, mqt._didnum, mqt._ds, mqt._dispenseid, mqt._parts, mqt._warpz, mqt._prepickuplot, mqt._prepickupsts from u03.filename_to_fid ftf inner join u03.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u03.mountqualitytrace mqt on mqt._filename_id = ftf._filename_id", 
order_by = "order by ftf._filename_route, ufd._machine_order, ufd._lane_no, ufd._stage_no, ftf._filename_timestamp, mqt._fadd, mqt._fsadd, mqt._nhadd, mqt._ncadd"))
}
#
# load all data functions
#
pg_load_count_q <- function(db, nrows=0)
{
    query = paste(pg_load_count_query()$query,
                  pg_load_count_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}

pg_load_feeder_q <- function(db, nrows=0)
{
    query = paste(pg_load_feeder_query()$query,
                  pg_load_feeder_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}

pg_load_nozzle_q <- function(db, nrows=0)
{
    query = paste(pg_load_nozzle_query()$query,
                  pg_load_nozzle_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}

pg_load_time_q <- function(db, nrows=0)
{
    query = paste(pg_load_time_query()$query,
                  pg_load_time_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}

pg_load_mount_exchange_reel_q <- function(db, nrows=0)
{
    query = paste(pg_load_mount_exchange_reel_query()$query,
                  pg_load_mount_exchange_reel_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}

pg_load_mount_latest_reel_q <- function(db, nrows=0)
{
    query = paste(pg_load_mount_latest_reel_query()$query,
                  pg_load_mount_latest_reel_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}

pg_load_mount_normal_trace_q <- function(db, nrows=0)
{
    query = paste(pg_load_mount_normal_trace_query()$query,
                  pg_load_mount_normal_trace_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}

pg_load_mount_quality_trace_q <- function(db, nrows=0)
{
    query = paste(pg_load_mount_quality_trace_query()$query,
                  pg_load_mount_quality_trace_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}
#
generate_in_clause <- function(db_column, values, equal_to=TRUE)
{
    #
    # coerce to a vector
    #
    vvals <- as.vector(values)
    #
    # check if we succeeded
    #
    if ((!is.vector(vvals)) || (length(vvals) == 0))
    {
        # nothing was given
        return("")
    }
    #
    # generate equal/in clause depending on the number of
    # values in the vector and whether it is a character string.
    #
    clause = ""
    oper = ""
    #
    if (length(vvals) == 1)
    {
        if (typeof(vvals) == "character")
        {
            if (equal_to == TRUE)
            {
                oper = " = '"
            }
            else
            {
                oper = " != '"
            }
            clause = paste(db_column, oper, vvals[1], "'", sep="")
        }
        else
        {
            if (equal_to == TRUE)
            {
                oper = "="
            }
            else
            {
                oper = "!="
            }
            clause = paste(db_column, oper, vvals[1])
        }
    }
    else
    {
        if (typeof(vvals) == "character")
        {
            if (equal_to == TRUE)
            {
                oper = " in ( '"
            }
            else
            {
                oper = " not in ( '"
            }
            clause = paste(db_column, oper, paste(vvals,collapse="', '"), "' )", sep="")
        }
        else
        {
            if (equal_to == TRUE)
            {
                oper = "in ("
            }
            else
            {
                oper = "not in ("
            }
            clause = paste(db_column, oper, paste(vvals,collapse=","), ")")
        }
    }

    return(clause);
}
#
generate_range_clause <- function(db_column, values, in_range=TRUE)
{
    #
    # coerce to a vector
    #
    vvals <- as.vector(values)
    #
    # check if we succeeded
    #
    if ((!is.vector(vvals)) || (length(vvals) == 0))
    {
        # nothing was given
        return("")
    }
    else if (length(vvals) != 2)
    {
        stop(sprintf("Range Clause MUST ONLY have two values, MIN and MAX."))
    }
    #
    # get MIN and MAX values
    #
    min = vvals[1];
    max = vvals[2];
    #
    if (min > max)
    {
        tmp = min
        min = max
        max = tmp
    }
    #
    clause = ""
    #
    if (typeof(vvals) == "character")
    {
        if (in_range == TRUE)
        {
            clause = sprintf("('%s' <= '%s') AND ('%s' <= '%s')", 
                             min, db_column, db_column, max)
        }
        else
        {
            clause = sprintf("NOT (('%s' <= '%s') AND ('%s' <= '%s'))", 
                             min, db_column, db_column, max)
        }
    }
    else
    {
        if (in_range == TRUE)
        {
            clause = sprintf("(%s <= %s) AND (%s <= %s)", 
                             min, db_column, db_column, max)
        }
        else
        {
            clause = sprintf("NOT ((%s <= %s) AND (%s <= %s))", 
                             min, db_column, db_column, max)
        }
    }

    return(clause);
}
#
# load data with a where clause
#
add_to_clause <- function(oper, clause, new_clause)
{
    if (new_clause == "")
    {
        return(clause);
    }
    else if (clause == "")
    {
        return(paste("(", new_clause, ")"))
    }
    else
    {
        return(paste(clause, oper, "(", new_clause, ")"))
    }
}
#
load_data <- function(db,
                      data_type,
                      routes = c(),
                      machines = c(),
                      lanes = c(),
                      stages = c(),
                      times = c(),
                      barcodes = c(),
                      not_routes = c(),
                      not_machines = c(),
                      not_lanes = c(),
                      not_stages = c(),
                      not_times = c(),
                      not_barcodes = c(),
                      range_routes = c(),
                      range_machines = c(),
                      range_lanes = c(),
                      range_stages = c(),
                      range_times = c(),
                      range_barcodes = c(),
                      debug = FALSE)
{
    select_query = "";
    order_by_clause = "";
    where_clause = "";
    #
    # generate where-clauses for equals on in-group
    #
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ftf._filename_route", 
                                         routes));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._machine_order", 
                                         machines));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._lane_no", 
                                         lanes));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._stage_no", 
                                         stages));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ftf._filename_timestamp", 
                                         times));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._pcb_id", 
                                         barcodes));
    #
    # generate where-clauses for not-equals on not-in-group
    #
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ftf._filename_route", 
                                         not_routes, 
                                         equal_to=FALSE));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._machine_order", 
                                         not_machines, 
                                         equal_to=FALSE));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._lane_no", 
                                         not_lanes, 
                                         equal_to=FALSE));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._stage_no", 
                                         not_stages, 
                                         equal_to=FALSE));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ftf._filename_timestamp", 
                                         not_times, 
                                         equal_to=FALSE));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_in_clause("ufd._pcb_id", 
                                         not_barcodes, 
                                         equal_to=FALSE));
    #
    # generate where-clauses for in-range
    #
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_range_clause("ftf._filename_route", 
                                             range_routes));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_range_clause("ufd._machine_order", 
                                             range_machines));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_range_clause("ufd._lane_no", 
                                             range_lanes));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_range_clause("ufd._stage_no", 
                                             range_stages));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_range_clause("ftf._filename_timestamp", 
                                             range_times));
    where_clause = 
        add_to_clause("AND",
                      where_clause,
                      generate_range_clause("ufd._pcb_id", 
                                             range_barcodes));
    #
    if (where_clause != "")
    {
        where_clause = paste("where", where_clause)
    }
    #
    if (data_type == "count")
    {
        select_query = pg_load_count_query()$query
        order_by_clause = pg_load_count_query()$order_by
    }
    else if (data_type == "feeder")
    {
        select_query = pg_load_feeder_query()$query
        order_by_clause = pg_load_feeder_query()$order_by
    }
    else if (data_type == "mount_quality_trace")
    {
        select_query = pg_load_mount_quality_trace_query()$query
        order_by_clause = pg_load_mount_quality_trace_query()$order_by
    }
    else if (data_type == "nozzle")
    {
        select_query = pg_load_nozzle_query()$query
        order_by_clause = pg_load_nozzle_query()$order_by
    }
    else if (data_type == "time")
    {
        select_query = pg_load_time_query()$query
        order_by_clause = pg_load_time_query()$order_by
    }
    else if (data_type == "mount_exchange_reel")
    {
        select_query = pg_load_mount_exchange_reel_query()$query
        order_by_clause = pg_load_mount_exchange_reel_query()$order_by
    }
    else if (data_type == "mount_latest_reel")
    {
        select_query = pg_load_mount_latest_reel_query()$query
        order_by_clause = pg_load_mount_latest_reel_query()$order_by
    }
    else if (data_type == "mount_normal_trace")
    {
        select_query = pg_load_mount_normal_trace_query()$query
        order_by_clause = pg_load_mount_normal_trace_query()$order_by
    }
    else
    {
        stop(sprintf("Unknown data type %s.", data_type))
    }
    #
    query = paste(select_query, where_clause, order_by_clause)
    #
    if (debug == TRUE)
    {
        print(sprintf("query: %s", query))
    }
    #
    return(pg_exec_query_return_matrix(db, query))
}
