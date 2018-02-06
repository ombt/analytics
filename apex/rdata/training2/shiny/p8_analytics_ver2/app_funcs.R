#
# get list of dbs and routes
#
get_db_routes <- function(db_name="cim")
{
    #
    # open connection to db
    #
    pg_db <- pg_open_db(db_name=db_name)

    #
    # get list of dbs
    #
    db_names <- pg_exec_query(pg_db, "select datname from pg_database")
    pg_close_db(pg_db)
    if (length(db_names$datname) == 0)
    {
        return (list());
    }

    #
    # get curent list routes per database if any
    #
    routes_found = FALSE
    db_schemas <- list()
    db_routes <- list()
    for (db_name in db_names$datname)
    {
        #
        # connect to database. remember postgresql only allows
        # access to one db at a time.
        #
        is_ok <- TRUE
        tryCatch(
            pg_db <- pg_open_db(db_name=db_name),
            error = function(e) { is_ok <<- FALSE; },
            finally = function(e) { }
        )
        if (is_ok != TRUE)
        {
            print(sprintf("Unable to connect to DB :%s", db_name))
            next
        }

        #
        # get list of schemas. check if u01 schema exists.
        #
        db_schemas[[db_name]] <- 
            pg_exec_query(pg_db, 
                         "select schema_name from information_schema.schemata where schema_name = 'u01' ")
        if (nrow(db_schemas[[db_name]]) <= 0)
        {
            print(sprintf("No u01 schema in DB: %s", db_name))
            pg_close_db(pg_db)
            next
        }

        #
        # get list of available route from u01.filename_to_ids table.
        #
        tmp_db_routes <- 
            pg_exec_query(pg_db, 
                         "select distinct _filename_route as \"route\" from u01.filename_to_fid ")
        if (nrow(tmp_db_routes) <= 0)
        {
            print(sprintf("No routes in DB: %s", db_name))
            pg_close_db(pg_db)
            next
        }
        routes_found <- TRUE
        db_routes[[db_name]] <- tmp_db_routes

        print(tmp_db_routes)

        pg_close_db(pg_db)
    }

    return(db_routes)
}

db_machines_cache <- list()

get_machines <- function(db_name, route)
{
    if (nchar(db_name) <= 1)
    {
        return(c())
    }
  
    cache_key <- paste(db_name, route, sep="_")

    if ( ! (cache_key %in% names(db_machines_cache)) )
    {
        pg_db <- pg_open_db(db_name=db_name)
        machines <- 
            pg_exec_query(pg_db, sprintf("select distinct ufd._machine_order as machine from u01.u0x_filename_data ufd inner join u01.filename_to_fid ftf on ftf._filename_route = '%s' and ufd._filename_id = ftf._filename_id order by ufd._machine_order asc", route))
        pg_close_db(pg_db)
        db_machines_cache[[cache_key]] <<- machines$machine
    }

    return(db_machines_cache[[cache_key]])
}

db_products_cache <- list()

get_products <- function(db_name, route)
{
    if (nchar(db_name) <= 1)
    {
        return(c())
    }
  
    cache_key <- paste(db_name, route, sep="_")

    if ( ! (cache_key %in% names(db_products_cache)) )
    {
        pg_db <- pg_open_db(db_name=db_name)
        products <- 
            pg_exec_query(pg_db, sprintf("select distinct ftf._filename_route, px._mjsid, pi._lotname, pi._lotnumber, pi._lane from u01.filename_to_fid ftf inner join u01.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id inner join u01.pivot_index px on px._filename_id = ftf._filename_id inner join u01.pivot_information pi on pi._filename_id = ftf._filename_id where ftf._filename_route = '%s' and ufd._output_no in ( 3, 4 ) order by ftf._filename_route, px._mjsid, pi._lotname, pi._lotnumber, pi._lane ", route))
        pg_close_db(pg_db)
        db_products_cache[[cache_key]] = 
            do.call(paste,products[,-1])
    }

    return(db_products_cache[[cache_key]])
}

db_product_times_cache <- list()

get_product_times <- function(db_name, 
                              route, 
                              mjsid, 
                              lotname, 
                              lotnumber, 
                              lane)
{
    if (nchar(db_name) <= 1)
    {
        return(c())
    }

    cache_key <- paste(db_name, 
                       route, 
                       mjsid, 
                       lotname, 
                       lotnumber, 
                       lane,
                       sep="_")

    if ( ! (cache_key %in% names(db_product_times_cache)) )
    {
        pg_db <- pg_open_db(db_name=db_name)
        sql_query <- sprintf("select distinct ftf._filename_route, px._mjsid, pi._lotname, pi._lotnumber, pi._lane, min(ufd._date) as min_date, max(ufd._date) as max_date from u01.filename_to_fid ftf inner join u01.u0x_filename_data ufd on ufd._filename_id = ftf._filename_id and ufd._output_no in ( 3, 4 ) inner join u01.pivot_index px on px._filename_id = ftf._filename_id and px._mjsid = '%s' inner join u01.pivot_information pi on pi._filename_id = ftf._filename_id and pi._lotname = '%s' and pi._lotnumber = %s and pi._lane = %s where ftf._filename_route = '%s' group by ftf._filename_route, px._mjsid, pi._lotname, pi._lotnumber, pi._lane", mjsid, lotname, lotnumber, lane, route)
        product_times <- pg_exec_query(pg_db, sql_query)
        pg_close_db(pg_db)
        db_product_times_cache[[cache_key]] = product_times[,c(6,7)]
print(product_times[,c(6,7)])
    }

    return(db_product_times_cache[[cache_key]])
}

not_equal_to <- function(lhs, rhs, msg)
{
    if (lhs != rhs)
    {
        return(NULL)
    }
    else
    {
        return(msg)
    }
}

