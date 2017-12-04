#
# return queries and order-by clauses separately
#
pg_aoi_load_all_query <- function()
{
    return(list(
query="
select
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    rfd._filename_id,
    rfd._date_time,
    rfd._serial_number,
    rfd._inspection_result,
    rfd._board_removed,
    pi._filename_id,
    pi._pcbid,
    pli._filename_id,
    pli._comment1,
    pli._comment2,
    pli._comment3,
    pli._lot,
    pli._modelid,
    pli._productdata,
    pli._side
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_information pi
on
    pi._filename_id = ftf._filename_id
inner join
    aoi.pivot_lotinformation pli
on
    pli._filename_id = ftf._filename_id",
from="
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_information pi
on
    pi._filename_id = ftf._filename_id
inner join
    aoi.pivot_lotinformation pli
on
    pli._filename_id = ftf._filename_id",
order_by="
order by
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp"));
}
3
pg_aoi_load_information_query <- function()
{
    return(list(
query="
select
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    rfd._filename_id,
    rfd._date_time,
    rfd._serial_number,
    rfd._inspection_result,
    rfd._board_removed,
    pi._filename_id,
    pi._pcbid
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_information pi
on
    pi._filename_id = ftf._filename_id",
from="
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_information pi
on
    pi._filename_id = ftf._filename_id",
order_by="
order by
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp"));
}

pg_aoi_load_lotinformation_query <- function()
{
    return(list(
query="
select
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp,
    ftf._filename,
    ftf._filename_type,
    ftf._filename_id,
    rfd._filename_id,
    rfd._date_time,
    rfd._serial_number,
    rfd._inspection_result,
    rfd._board_removed,
    pli._filename_id,
    pli._comment1,
    pli._comment2,
    pli._comment3,
    pli._lot,
    pli._modelid,
    pli._productdata,
    pli._side
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_lotinformation pli
on
    pli._filename_id = ftf._filename_id",
from="
from
    aoi.filename_to_fid ftf
inner join
    aoi.rst_filename_data rfd
on
    rfd._filename_id = ftf._filename_id
inner join
    aoi.pivot_lotinformation pli
on
    pli._filename_id = ftf._filename_id",
order_by="
order by
    ftf._filename_route,
    rfd._machine,
    rfd._lane,
    ftf._filename_timestamp"));
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
pg_aoi_load_information <- function(db, nrows=0)
{
    query = paste(pg_aoi_load_information_query()$query,
                  pg_aoi_load_information_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}
#
pg_aoi_load_lotinformation <- function(db, nrows=0)
{
    query = paste(pg_aoi_load_lotinformation_query()$query,
                  pg_aoi_load_lotinformation_query()$order_by)
    return(pg_exec_query_return_matrix(db, query))
}
#
# load data with a where clause
#
pg_aoi_load_data <- function(db,
                      data_type,
                      routes = c(),
                      machines = c(),
                      lanes = c(),
                      times = c(),
                      barcodes = c(),
                      not_routes = c(),
                      not_machines = c(),
                      not_lanes = c(),
                      not_times = c(),
                      not_barcodes = c(),
                      range_routes = c(),
                      range_machines = c(),
                      range_lanes = c(),
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
                      sql_generate_in_clause("rfd._machine", 
                                         machines));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("rfd._lane", 
                                         lanes));
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
                      sql_generate_in_clause("rfd._machine", 
                                         not_machines, 
                                         equal_to=FALSE));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("rfd._lane", 
                                         not_lanes, 
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
                      sql_generate_range_clause("rfd._machine", 
                                             range_machines));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("rfd._lane", 
                                             range_lanes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("ftf._filename_timestamp", 
                                             range_times));
    #
    if (where_clause != "")
    {
        where_clause = paste("where", where_clause)
    }
    #
    if (data_type == "all")
    {
        select_query = pg_aoi_load_all_query()$query
        order_by_clause = pg_aoi_load_all_query()$order_by
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("pi._pcbid", 
                                                     range_barcodes))
    }
    else if (data_type == "information")
    {
        select_query = pg_aoi_load_information_query()$query
        order_by_clause = pg_aoi_load_information_query()$order_by
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("pi._pcbid", 
                                                     range_barcodes));
    }
    else if (data_type == "lotinformation")
    {
        select_query = pg_aoi_load_information_query()$query
        order_by_clause = pg_aoi_load_information_query()$order_by
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
                                machines = c(),
                                lanes = c(),
                                times = c(),
                                barcodes = c(),
                                not_routes = c(),
                                not_machines = c(),
                                not_lanes = c(),
                                not_times = c(),
                                not_barcodes = c(),
                                range_routes = c(),
                                range_machines = c(),
                                range_lanes = c(),
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
                      sql_generate_in_clause("rfd._machine", 
                                         machines));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("rfd._lane", 
                                         lanes));
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
                      sql_generate_in_clause("rfd._machine", 
                                         not_machines, 
                                         equal_to=FALSE));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_in_clause("rfd._lane", 
                                         not_lanes, 
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
                      sql_generate_range_clause("rfd._machine", 
                                             range_machines));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("rfd._lane", 
                                             range_lanes));
    where_clause = 
        sql_add_to_clause("AND",
                      where_clause,
                      sql_generate_range_clause("ftf._filename_timestamp", 
                                             range_times));
    #
    if (where_clause != "")
    {
        where_clause = paste("where", where_clause)
    }
    #
    if (data_type == "all")
    {
        from_clause = pg_aoi_load_all_query()$from
        #
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("pi._pcbid", 
                                                     range_barcodes));
    }
    else if (data_type == "information")
    {
        from_clause = pg_aoi_load_information_query()$from
        #
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 barcodes));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_in_clause("pi._pcbid", 
                                                 not_barcodes, 
                                                 equal_to=FALSE));
        where_clause = 
            sql_add_to_clause("AND",
                          where_clause,
                          sql_generate_range_clause("pi._pcbid", 
                                                     range_barcodes));
    }
    else if (data_type == "lotinformation")
    {
        from_clause = pg_aoi_load_information_query()$from
    }
    else
    {
        stop(sprintf("Unknown data type %s.", data_type))
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
