#
# UI for (Demo) PanaCIM Enterprise Analytics 
#

#
# load local R libraries
#
rlib_files <- list.files("rlib", pattern=".*.R")
#
for (rlib_file in rlib_files)
{
    source(paste("rlib", rlib_file, sep="/"))
}

#
# load required CRAN libraries
#
install_and_load("DBI")
install_and_load("RPostgreSQL")
install_and_load("ggplot2")
install_and_load("sqldf")
install_and_load("plyr")
install_and_load("shiny")
install_and_load("shinyTime")

#
# load app-specific functions
#
if (file.exists("app_funcs.R"))
{
    source("app_funcs.R")
}

#
# get list of dbs and routes
#
db_routes <- get_db_routes()
if (length(db_routes) <= 0)
{
    stop("No databases and/or routes found.")
}
db_routes[["Unknown"]] = list(route=c("Unknown"))

#
# UI interface (paints the widgets)
#
ui <- fluidPage(
    titlePanel(
        title = h2("PanaCIM Enterprise Analytics"),
        windowTitle = h2("PanaCIM Enterprise Analytics")
    ),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "db_name",
                label = h4("Select Database: "),
                choices = names(db_routes),
                selected = "Unknown"
            ),
            selectInput(
                inputId = "route",
                label = h4("Select Route: "),
                choices = c("Unknown"),
                selected = "Unknown"
            ),
            selectInput(
                inputId = "product",
                label = h4("Select Product: "),
                choices = c("Unknown"),
                selected = "Unknown"
            ),
            checkboxGroupInput(
                inputId = "machinesgroup",
                label = h4("Select Placement Machines: "),
                choices = list()
            ),
            dateRangeInput(
                inputId = "date_range",
                label = "Analysis start/end date: ",
                start = Sys.Date() - 1,
                end = Sys.Date(),
                format = "yyyy-mm-dd"
            ),
            timeInput(
                inputId = "start_time",
                label = "Analysis start time: ",
                value = strptime("00:00", "%R"),
                seconds = FALSE
            ),
            timeInput(
                inputId = "end_time",
                label = "Analysis end time: ",
                value = strptime("23:59", "%R"),
                seconds = FALSE
            )
        ),
        mainPanel(
        )
    )
)

server <- function(input, output, session) {

    values <- reactiveValues(route = "")

    observe(
    {
        input$db_name
        updateSelectInput(
            session=session,
            inputId = "route",
            choices = db_routes[[input$db_name]]$route
        )
    } )

    observe(
    {
        input$route
        if (input$route != values$route)
        {
            values$route = input$route

            if (input$route != "Unknown")
            {
                updateSelectInput(
                    session = session,
                    inputId = "product",
                    choices = get_products(isolate(input$db_name),
                                           input$route)
                )
                updateCheckboxGroupInput(
                    session = session,
                    inputId = "machinesgroup",
                    inline  = TRUE,
                    choices = get_machines(isolate(input$db_name),
                                           input$route)
                )
            }
            else
            {
                updateSelectInput(
                    session = session,
                    inputId = "product",
                    choices = c("Unknown")
                )
                updateCheckboxGroupInput(
                    session = session,
                    inputId = "machinesgroup",
                    choices = list()
                )
            }
        }
    } )
}

shinyApp(ui=ui, server=server)

