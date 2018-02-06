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
# types of analysis
#
analysis_types <- c("NONE", 
                    "PA-PLOT", 
                    "TRACE-PLOT", 
                    "PA-SPC", 
                    "TRACE-SPC", 
                    "POST-PRODUCTION")

#
# UI interface (paints the widgets)
#
ui <- fluidPage(
    navbarPage(
        title = h2("PanaCIM EA"),
        id = "main_page",
        tabPanel(
            title = "Data",
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
                inputId = "machines",
                label = h4("Select Placement Machines: "),
                choices = list()
            ),
            dateRangeInput(
                inputId = "date_range",
                label = h4("Analysis start/end date: "),
                start = Sys.Date() - 1,
                end = Sys.Date(),
                format = "yyyy-mm-dd"
            ),
            timeInput(
                inputId = "start_time",
                label = h4("Analysis start time: "),
                value = strptime("00:00", "%R"),
                seconds = FALSE
            ),
            timeInput(
                inputId = "end_time",
                label = h4("Analysis end time: "),
                value = strptime("23:59", "%R"),
                seconds = FALSE
            ),
            actionButton(
                inputId = "collect_data",
                label = h3("Collect Data")
            ),
            h3(textOutput("collect_data_status"))
        ),
        tabPanel(
            title = "Analysis to Perform",
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        inputId = "analysis_type",
                        label = h4("Select Operation: "),
                        choices = analysis_types,
                        selected = "none"
                    ),
                    actionButton(
                        inputId = "choose_analysis",
                        label = h4("Choose Analysis")
                    ),
                    h3(textOutput("choose_analysis_status"))
                ),
                mainPanel(
                    conditionalPanel(
                        condition = "input.analysis_type == 'NONE'",
                        h4("Nothing Chosen")
                    ),
                    conditionalPanel(
                        condition = "input.analysis_type == 'PA-PLOT'",
                        h4("PLOT PA DATA"),
                        selectInput(
                            inputId = "pa_plot_data_type",
                            label = h4("Select Data: "),
                            choices = c("none",
                                        "feeder",
                                        "nozzle",
                                        "time",
                                        "count"),
                            selected = "none"
                        ),
                        conditionalPanel(
                            condition = "input.pa_plot_data_type == 'feeder'",
                            h4("FEEDER PA DATA")
                        ),
                        conditionalPanel(
                            condition = "input.pa_plot_data_type == 'nozzle'",
                            h4("NOZZLE PA DATA")
                        ),
                        conditionalPanel(
                            condition = "input.pa_plot_data_type == 'time'",
                            h4("TIME PA DATA")
                        ),
                        conditionalPanel(
                            condition = "input.pa_plot_data_type == 'count'",
                            h4("COUNT PA DATA")
                        ),
                        actionButton(
                            inputId = "start_pa_plot",
                            label = h4("Continue")
                        ),
                        h3(textOutput("start_pa_plot_status"))
                    ),
                    conditionalPanel(
                        condition = "input.analysis_type == 'TRACE-PLOT'",
                        h4("PLOT TRACE DATA"),
                        actionButton(
                            inputId = "start_trace_plot",
                            label = h4("Continue")
                        ),
                        h3(textOutput("start_plot_trace_status"))
                    ),
                    conditionalPanel(
                        condition = "input.analysis_type == 'PA-SPC'",
                        h4("PRODUCTION ANALYSIS STATISTICAL PROCESS CONTROL - PA-SPC"),
                        actionButton(
                            inputId = "start_pa_spc",
                            label = h4("Continue")
                        ),
                        h3(textOutput("start_pa_spc_status"))
                    ),
                    conditionalPanel(
                        condition = "input.analysis_type == 'TRACE-SPC'",
                        h4("TRACE STATISTICAL PROCESS CONTROL - TRACE-SPC"),
                        actionButton(
                            inputId = "start_trace_spc",
                            label = h4("Continue")
                        ),
                        h3(textOutput("start_trace_spc_status"))
                    ),
                    conditionalPanel(
                        condition = "input.analysis_type == 'POST-PRODUCTION'",
                        h4("POST-PRODUCTION ANALYSIS"),
                        actionButton(
                            inputId = "start_post_prod",
                            label = h4("Continue")
                        ),
                        h3(textOutput("start_post_prod_status"))
                    )
                )
            )
        ),
        tabPanel(
            title = "Analysis Results",
            sidebarLayout(
                sidebarPanel(
                ),
                mainPanel(
                )
            )
        )
    )
)

server <- function(input, output, session) {

    values <- reactiveValues(route = "",
                             product = "",
                             data = list())

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
                    inputId = "machines",
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
                    inputId = "machines",
                    choices = list()
                )
            }
        }
    } )

    observe(
    {
        input$product

        if (input$product != values$product)
        {
            values$product = input$product

            if (input$product != "Unknown")
            {
                parts <- unlist(strsplit(input$product, 
                                         " ",
                                         fixed = TRUE))
                prod_times = get_product_times(
                                 db_name = isolate(input$db_name), 
                                 route = isolate(input$route), 
                                 mjsid = parts[1], 
                                 lotname = parts[2], 
                                 lotnumber = parts[3], 
                                 lane = parts[4])

                prod_start_date <- 
                    as.Date(substr(prod_times$min_date,1,8), 
                            format="%Y%m%d")
                prod_end_date <- 
                    as.Date(substr(prod_times$max_date,1,8), 
                            format="%Y%m%d")
    
                updateDateRangeInput(
                    session = session,
                    inputId = "date_range",
                    start = prod_start_date,
                    end = prod_end_date
                )
                updateTimeInput(
                    session = session,
                    inputId = "start_time",
                    value = strptime("00:00", "%R")
                )
                updateTimeInput(
                    session = session,
                    inputId = "end_time",
                    value = strptime("23:59", "%R")
                )
            }
            else
            {
                updateDateRangeInput(
                    session = session,
                    inputId = "date_range",
                    start = Sys.Date() - 1,
                    end = Sys.Date()
                )
                updateTimeInput(
                    session = session,
                    inputId = "start_time",
                    value = strptime("00:00", "%R")
                )
                updateTimeInput(
                    session = session,
                    inputId = "end_time",
                    value = strptime("23:59", "%R")
                )
            }
        }
    } )

    observeEvent(
        input$collect_data,
        isolate(
        {
            values$data[["status"]]     <- FALSE
            values$data[["db_name"]]    <- ""
            values$data[["route"]]      <- ""
            values$data[["product"]]    <- ""
            values$data[["machines"]]   <- NULL
            values$data[["date_range"]] <- NULL
            values$data[["start_time"]] <- NULL
            values$data[["end_time"]]   <- NULL

            if (input$db_name == "Unknown")
            {
                output$collect_data_status <-
                    renderText( { "STATUS: Database is UNKNOWN" } )
                return();
            }
            else if (input$route == "Unknown")
            {
                output$collect_data_status <-
                    renderText( { "STATUS: Route is UNKNOWN" } )
                return();
            }
            else if (input$product == "Unknown")
            {
                output$collect_data_status <-
                    renderText( { "STATUS: Product is UNKNOWN" } )
                return();
            }
            else if (is.null(input$machines))
            {
                output$collect_data_status <-
                    renderText( { "STATUS: Machines are UNKNOWN" } )
                return();
            }

            values$data[["status"]]     <- TRUE
            values$data[["db_name"]]    <- input$db_name
            values$data[["route"]]      <- input$route
            values$data[["product"]]    <- input$product
            values$data[["machines"]]   <- input$machines
            values$data[["date_range"]] <- input$date_range
            values$data[["start_time"]] <- input$start_time
            values$data[["end_time"]]   <- input$end_time

            output$collect_data_status <-
                renderText( { "STATUS: Data collection is OK" } )
        } ),
        ignoreInit = TRUE
    )

    observeEvent(
        input$choose_analysis,
        isolate(
        {
            if (input$analysis_type != "NONE")
            {
                output$choose_analysis_status <-
                    renderText( { "STATUS: Operation is OK" } )
            }
            else
            {
                output$choose_analysis_status <-
                    renderText( { "STATUS: Operation is NOT OK" } )
            }
        } ),
        ignoreInit = TRUE
    )

    observeEvent(
        input$analysis_type,
        isolate(
        {
            output$choose_analysis_status <- renderText( { "" } )
        } ),
        ignoreInit = TRUE
    )

    observeEvent(
        input$start_pa_plot,
        isolate(
        {
            output$start_pa_plot_status <-
                renderText( { "STATUS: Operation is OK" } )
        } ),
        ignoreInit = TRUE
    )

    observeEvent(
        input$start_trace_plot,
        isolate(
        {
            output$start_trace_plot_status <-
                renderText( { "STATUS: Operation is OK" } )
        } ),
        ignoreInit = TRUE
    )

    observeEvent(
        input$start_pa_spc,
        isolate(
        {
            output$start_pa_spc_status <-
                renderText( { "STATUS: Operation is OK" } )
        } ),
        ignoreInit = TRUE
    )

    observeEvent(
        input$start_trace_spc,
        isolate(
        {
            output$start_trace_spc_status <-
                renderText( { "STATUS: Operation is OK" } )
        } ),
        ignoreInit = TRUE
    )

    observeEvent(
        input$start_post_prod,
        isolate(
        {
            output$start_post_prod_status <-
                renderText( { "STATUS: Operation is OK" } )
        } ),
        ignoreInit = TRUE
    )
}

shinyApp(ui=ui, server=server)

