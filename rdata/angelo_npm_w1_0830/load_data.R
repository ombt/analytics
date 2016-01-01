#
sqlite_load_angelo_npm_w1_0830 <- function(nrows=0)
{
    db_path = Sys.getenv("OMBT_DB_BASE_PATH")
    if ((db_path == "") | is.na(db_path))
    {
        stop("OMBT_DB_BASE_PATH not set or zero-length")
    }
    db_name = "angelo_npm_w1_0830"
    #
    db = sqlite_open_db(db_path, db_name)
    #
    tbls = c("BRecg",
             "FILENAME_TO_IDS",
             "InspectionData",
             "MountPickupFeeder",
             "Count",
             "HeightCorrect",
             "MountExchangeReel",
             "MountPickupNozzle",
             "CycleTime",
             "Index",
             "MountLatestReel",
             "MountQualityTrace",
             "FID_DATA",
             "Information",
             "MountNormalTrace",
             "Time")
    #
    data = list()
    #
    for (tbl in tbls)
    {
        print(paste("reading table", tbl))
        data[[tbl]] = sqlite_load_table_from_db(db,
                                                tbl,
                                                nrows=nrows)
    }
    #
    sqlite_close_db(db)
    #
    return(data)
}

sqlite_load_nv_angelo_npm_w1_0830 <- function(nrows=0)
{
    print(paste("entry at", Sys.time()))
    #
    db_path = Sys.getenv("OMBT_DB_BASE_PATH")
    if ((db_path == "") | is.na(db_path))
    {
        stop("OMBT_DB_BASE_PATH not set or zero-length")
    }
    db_name = "angelo_npm_w1_0830"
    #
    print(paste("open db at", Sys.time()))
    db = sqlite_open_db(db_path, db_name)
    #
    tbls = c("BRecg",
             "FILENAME_TO_IDS",
             "MountPickupFeeder",
             "HeightCorrect",
             "MountExchangeReel",
             "MountPickupNozzle",
             "MountLatestReel",
             "MountQualityTrace",
             "FID_DATA",
             "MountNormalTrace")
    #
    nv_tbls = c("InspectionData",
                "Count",
                "CycleTime",
                "Index",
                "Information",
                "Time")
    #
    data = list()
    #
    print(paste("start reading tbls at", Sys.time()))
    for (tbl in tbls)
    {
        print(paste("reading NON-NV table", tbl, "at", Sys.time()))
        data[[tbl]] = sqlite_load_table_from_db(db,
                                                tbl,
                                                nrows=nrows)
    }
    for (tbl in nv_tbls)
    {
        print(paste("reading NV table", tbl, "at", Sys.time()))
        data[[tbl]] = sqlite_load_nv_table_from_db(db,
                                                   tbl,
                                                   nrows=nrows)
    }
    #
    print(paste("close db at", Sys.time()))
    sqlite_close_db(db)
    #
    print(paste("done at", Sys.time()))
    return(data)
}
