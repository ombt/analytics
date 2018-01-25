#
# read in local R-functions
# 
if (file.exists("source_all.R"))
{
    source("source_all.R")
}

#
# install/load required R packages
#
install_and_load("DBI")
install_and_load("RSQLite")
install_and_load("RPostgreSQL")
install_and_load("ggplot2")
install_and_load("sqldf")
install_and_load("plyr")
install_and_load("shiny")

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

if (routes_found == FALSE)
{
    stop(sprintf("NO ROUTES FOUND. STOPPING."))
}

#
# exit handler - closes the db connection
#
onStop(function() { print("closing DB"); pg_close_db(pg_db); } )

#
# UI page definition for Shiny
#
ui <- fluidPage(

    titlePanel
    (
        title       = h3("PanaCIM Enterprise Analytics"),
        windowTitle = h3("PanaCIM Enterprise Analytics")
    ),
  
    sidebarLayout
    (
        sidebarPanel
        (
            selectInput
            (
                "db_name",
                label="Choose Database.",
                choices = c("Unknown",names(db_routes)),
                selected = "Unknown"
            ),
            uiOutput("routeChoices")
        ),
        mainPanel
        (
            h4(em("Output Panel")),
            h4(textOutput(output$selected_route))
        )
    )
)

server <- function(input, output) {
    output$routeChoices <- renderUI(
    {
        selectInput (
            input_id = "selected_route",
            label    = "Choose Route",
            choices = c("Unknown", db_routes[[input$db_name]]),
            selected = "Unknown"
        )
    })

    output$selected_route <- renderText(input$selected_route)
}

shinyApp(ui=ui, server=server)

