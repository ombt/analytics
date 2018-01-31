#
# open connection to postgresql database
#
pg_open_db <- function(db_name, 
                       db_host="localhost", 
                       db_port=5432,
                       db_user=NA,
                       db_password=NA)
{
    #
    # check if a package is installed. if not, then install
    # and download.
    #
    lapply_install_and_load <- function (package1, ...)
    {
        verbose = FALSE
        #
        # convert arguments to vector
        #
        packages <- c(package1, ...)
        #
        # check if loaded and installed
        #
        loaded        <- packages %in% (.packages())
        names(loaded) <- packages
        #
        installed        <- packages %in% rownames(installed.packages())
        names(installed) <- packages
        #
        # start loop to determine if each package is installed
        #
        load_it <- function (package, loaded, installed)
        {
            if (loaded[package])
            {
                if (verbose) print(paste(package, "is loaded"))
            }
            else
            {
                if (verbose) print(paste(package, "is not loaded"))
                if (installed[package])
                {
                    if (verbose) print(paste(package, "is installed"))
                    if (verbose) print(paste("loading", package))
                    do.call("library", list(package))
                }
                else
                {
                    if (verbose) print(paste(package, "is not installed"))
                    if (verbose) print(paste("installing", package))
                    install.packages(package)
                    if (verbose) print(paste("loading", package))
                    do.call("library", list(package))
                }
            }
        }
        #
        lapply(packages, load_it, loaded, installed)
    }
    #
    status = lapply_install_and_load("DBI")
    status = lapply_install_and_load("RPostgreSQL")
    #
    db_driver = dbDriver("PostgreSQL")
    #
    db_conn=list()
    #
    if (( ! is.na(db_user)) && ( ! is.na(db_password)))
    {
        db_conn=dbConnect(db_driver,
                          dbname=db_name,
                          host=db_host,
                          port=db_port,
                          user=db_user,
                          password=db_password)
    }
    else if (is.na(db_user) && ( ! is.na(db_password)))
    {
        db_conn=dbConnect(db_driver,
                          dbname=db_name,
                          host=db_host,
                          port=db_port,
                          user=db_user)
    }
    else if (is.na(db_user) && is.na(db_password))
    {
        db_conn=dbConnect(db_driver,
                          dbname=db_name,
                          host=db_host,
                          port=db_port)
    }
    #
    query <- "select table_schema, table_name from information_schema.tables where table_schema not in ( 'pg_catalog', 'information_schema' ) and table_type = 'VIEW'"
    results <- dbGetQuery(db_conn, query)
    #
    return(list("db"=db_conn, 
                "tbls"=dbListTables(db_conn),
                "vws"=paste(results$table_schema,
                            results$table_name,
                            sep=".")))
}
#
# close connection
#
pg_close_db <- function(db)
{
    status = dbDisconnect(db$db)
}
#
# read in a table
#
pg_load_table <- function(db,schema_table_name,nrows=0)
{
    #
    # split table name from schema if given
    #
    tokens = unlist(strsplit(schema_table_name, "\\."))
    table_name = tokens[length(tokens)]
    #
    if ((table_name %in% db$tbls) ||
        (schema_table_name %in% db$vws))
    {
        if (nrows > 0)
        {
            # quote the table name since Index is a key-word in SQL
            query=paste("select * from ", schema_table_name, " limit ", nrows, sep="")
        }
        else
        {
            # quote the table name since Index is a key-word in SQL
            query=paste("select * from ", schema_table_name, sep="")
        }
        results = dbGetQuery(db$db, query)
        return(results)
    }
    else
    {
        print(sprintf("Table not found: %s", table_name))
        return(data.frame())
    }
}
#
# execute a query
#
pg_exec_query <- function(db, query)
{
    return(dbGetQuery(db$db, query))
}
#
# read in a table and return as a matrix
#
pg_load_table_return_matrix <- function(db,schema_table_name,nrows=0)
{
    #
    # split table name from schema if given
    #
    tokens = unlist(strsplit(schema_table_name, "\\."))
    table_name = tokens[length(tokens)]
    #
    if ((table_name %in% db$tbls) ||
        (schema_table_name %in% db$vws))
    {
        if (nrows > 0)
        {
            # quote the table name since Index is a key-word in SQL
            query=paste("select * from ", schema_table_name, " limit ", nrows, sep="")
        }
        else
        {
            # quote the table name since Index is a key-word in SQL
            query=paste("select * from ", schema_table_name, sep="")
        }
        results = dbGetQuery(db$db, query)
        return(as.matrix(results))
    }
    else
    {
        return(matrix())
    }
}
#
# execute a query
#
pg_exec_query_return_matrix <- function(db, query)
{
    return(as.matrix(dbGetQuery(db$db, query)))
}

