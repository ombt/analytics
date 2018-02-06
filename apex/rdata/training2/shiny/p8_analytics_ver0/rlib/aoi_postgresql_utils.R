#
# return queries and order-by clauses separately
#
pg_aoi_load_all_query <- function()
{
    return(list(
view_format="select %s from aoi.all_view",
query="
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    c._type,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
left join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
left join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp",
from="
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
left join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
left join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp",
order_by="
order by
    ftf._filename_timestamp asc"));
}
#
pg_aoi_load_no_good_query <- function()
{
    return(list(
view_format="select %s from aoi.no_good_view",
query="
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc,
    -- c._filename_id,
    -- c._p,
    c._cmp,
    c._cc,
    c._ref,
    -- d._filename_id,
    -- d._cmp,
    d._defect,
    d._insp_type,
    d._lead_id
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp > 0
inner join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
inner join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp",
from="
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp > 0
inner join
    aoi.cmp c
on
    c._filename_id = ftf._filename_id
and
    c._p = p._p
inner join
    aoi.defect d
on
    d._filename_id = ftf._filename_id
and
    d._cmp = c._cmp",
order_by="
order by
    ftf._filename_timestamp asc"));
}
#
pg_aoi_load_good_query <- function()
{
    return(list(
view_format="select %s from aoi.good_view",
query="
select
    ftf._filename,
    ftf._filename_type,
    ftf._filename_timestamp,
    ftf._filename_route,
    ftf._filename_id,
    -- afd._filename_id,
    afd._aoi_pcbid,
    afd._date_time,
    -- i._filename_id,
    i._cid,
    i._timestamp,
    i._crc,
    i._c2d,
    i._recipename,
    i._mid,
    -- p._filename_id,
    p._p,
    p._cmp as cmp_idx,
    p._sc,
    p._pid,
    p._fc
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp < 0",
from="
from
    aoi.filename_to_fid ftf
inner join
    aoi.aoi_filename_data afd
on
    afd._filename_id = ftf._filename_id
inner join
    aoi.insp i
on
    i._filename_id = ftf._filename_id
inner join
    aoi.p p
on
    p._filename_id = ftf._filename_id
and
    p._cmp < 0",
order_by="
order by
    ftf._filename_timestamp asc"));
}
#
# load all data functions
#
pg_aoi_load_all <- function(db, nrows=0)
{
    query = paste(pg_aoi_load_all_query()$query,
                  pg_aoi_load_all_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}
#
pg_aoi_load_no_good <- function(db, nrows=0)
{
    query = paste(pg_aoi_load_no_good_query()$query,
                  pg_aoi_load_no_good_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}
#
pg_aoi_load_good <- function(db, nrows=0)
{
    query = paste(pg_aoi_load_good_query()$query,
                  pg_aoi_load_good_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}
#
# load data with a where clause
#
pg_aoi_load_data <- function(db,
                      data_type,
                      routes = c(),
                      times = c(),
                      barcodes = c(),
                      not_routes = c(),
                      not_times = c(),
                      not_barcodes = c(),
                      range_routes = c(),
                      range_times = c(),
                      range_barcodes = c(),
                      matrix_return = FALSE,
                      debug = FALSE)
{
    select_query = "";
    order_by_clause = "";
    where_clause = "";
    #
    # generate where-clauses for equals on in-group
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_route", 
                                         routes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_timestamp", 
                                         times));
    #
    # generate where-clauses for not-equals on not-in-group
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_route", 
                                         not_routes, 
                                         equal_to=FALSE));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_timestamp", 
                                         not_times, 
                                         equal_to=FALSE));
    #
    # generate where-clauses for in-range
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("ftf._filename_route", 
                                             range_routes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("ftf._filename_timestamp", 
                                             range_times));
    #
    if (data_type == "all")
    {
        select_query = pg_aoi_load_all_query()$query
        order_by_clause = pg_aoi_load_all_query()$order_by
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("i._c2d", 
                                                     range_barcodes))
    }
    else if (data_type == "no_good")
    {
        select_query = pg_aoi_load_no_good_query()$query
        order_by_clause = pg_aoi_load_no_good_query()$order_by
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("i._c2d", 
                                                     range_barcodes))
    }
    else if (data_type == "good")
    {
        select_query = pg_aoi_load_good_query()$query
        order_by_clause = pg_aoi_load_good_query()$order_by
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("i._c2d", 
                                                     range_barcodes))
    }
    else
    {
        stop(sprintf("Unknown data type %s.", data_type))
    }
    #
    if (where_clause != "")
    {
        where_clause = paste("where", where_clause)
    }
    #
    query = paste(select_query, where_clause, order_by_clause)
    #
    if (debug == TRUE)
    {
        print(sprintf("query: %s", query))
    }
    #
    if (matrix_return == TRUE)
    {
        return(pg_exec_query_return_matrix(db, query))
    }
    else
    {
        return(pg_exec_query(db, query))
    }
}
#
pg_aoi_get_operation_value <- function(db,
                                data_type,
                                operation,
                                routes = c(),
                                times = c(),
                                barcodes = c(),
                                not_routes = c(),
                                not_times = c(),
                                not_barcodes = c(),
                                range_routes = c(),
                                range_times = c(),
                                range_barcodes = c(),
                                matrix_return = FALSE,
                                debug = FALSE)
{
    from_clause = "";
    where_clause = "";
    #
    # generate where-clauses for equals on in-group
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_route", 
                                         routes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_timestamp", 
                                         times));
    #
    # generate where-clauses for not-equals on not-in-group
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_route", 
                                         not_routes, 
                                         equal_to=FALSE));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("ftf._filename_timestamp", 
                                         not_times, 
                                         equal_to=FALSE));
    #
    # generate where-clauses for in-range
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("ftf._filename_route", 
                                             range_routes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("ftf._filename_timestamp", 
                                             range_times));
    #
    if (data_type == "all")
    {
        from_clause = pg_aoi_load_all_query()$from
        #
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("i._c2d", 
                                                     range_barcodes));
    }
    else if (data_type == "no_good")
    {
        from_clause = pg_aoi_load_no_good_query()$from
        #
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("i._c2d", 
                                                     range_barcodes));
    }
    else if (data_type == "good")
    {
        from_clause = pg_aoi_load_good_query()$from
        #
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("i._c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("i._c2d", 
                                                     range_barcodes));
    }
    else
    {
        stop(sprintf("Unknown data type %s.", data_type))
    }
    #
    if (where_clause != "")
    {
        where_clause = paste("where", where_clause)
    }
    #
    query = sprintf("select %s %s %s", 
                    operation, 
                    from_clause, 
                    where_clause);
    #
    if (debug == TRUE)
    {
        print(sprintf("query: %s", query))
    }
    #
    if (matrix_return == TRUE)
    {
        return(pg_exec_query_return_matrix(db, query))
    }
    else
    {
        return(pg_exec_query(db, query))
    }
}
#
pg_aoi_load_data_view <- function(db,
                                  data_type,
                                  routes = c(),
                                  times = c(),
                                  barcodes = c(),
                                  not_routes = c(),
                                  not_times = c(),
                                  not_barcodes = c(),
                                  range_routes = c(),
                                  range_times = c(),
                                  range_barcodes = c(),
                                  matrix_return = FALSE,
                                  debug = FALSE)
{
    select_query = "";
    where_clause = "";
    #
    # generate where-clauses for equals on in-group
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("_filename_route", 
                                         routes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("_filename_timestamp", 
                                         times));
    #
    # generate where-clauses for not-equals on not-in-group
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("_filename_route", 
                                         not_routes, 
                                         equal_to=FALSE));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("_filename_timestamp", 
                                         not_times, 
                                         equal_to=FALSE));
    #
    # generate where-clauses for in-range
    #
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("_filename_route", 
                                             range_routes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("_filename_timestamp", 
                                             range_times));
    #
    if (data_type == "all")
    {
        view_format = pg_aoi_load_all_query()$view_format
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("_c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("_c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("_c2d", 
                                                     range_barcodes))
    }
    else if (data_type == "no_good")
    {
        view_format = pg_aoi_load_no_good_query()$view_format
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("_c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("_c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("_c2d", 
                                                     range_barcodes));
    }
    else if (data_type == "good")
    {
        view_format = pg_aoi_load_good_query()$view_format
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("_c2d", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("_c2d", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("_c2d", 
                                                     range_barcodes));
    }
    else
    {
        stop(sprintf("Unknown data type %s.", data_type))
    }
    #
    if (where_clause != "")
    {
        where_clause = paste("where", where_clause)
    }
    #
    query = paste(sprintf(view_format, "*"),  where_clause)
    #
    if (debug == TRUE)
    {
        print(sprintf("query: %s", query))
    }
    #
    if (matrix_return == TRUE)
    {
        return(pg_exec_query_return_matrix(db, query))
    }
    else
    {
        return(pg_exec_query(db, query))
    }
}
