#
# connect to db
#
pg_db <- pg_open_db(db_name="cim")

#
# get curent list of databases
#
db_names <- pg_exec_query(pg_db, "select datname from pg_database")

#
# close connection to db
#
pg_close_db(pg_db)

#
# get curent list routes per database if any
#
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
    db_routes[[db_name]] <- tmp_db_routes;

    pg_close_db(pg_db)
}

#
# close connection to db
#
pg_close_db(pg_db)

