library(shiny)

ui <- fluidPage(

    titlePanel("Iris"),

    sidebarLayout(
        sidebarPanel(
            img(src="Rlogo.jpg"),
            br(),
            selectInput(
                "variable", 
                "Select the variable: ",
                setdiff(names(iris), "Species")
            ),
            br(),
            numericInput(
                "value",
                "",
                value=0,
                min=0
            )
        ),
        mainPanel(
            tableOutput("table")
        )
    )
)

server <- function(input, output, session)
{
    observe(
    {
        input.label <- paste0("Select the minimum value for : ",
                              input$variable,
                              ":" )
        updateNumericInput(session, "value", label = input.label)
    })
    output$table <- 
        renderTable( {
            # subset(iris, get("input$variable > input$value"))
            subset(iris, get(input$variable) > input$value)
        } )
}

shinyApp(ui=ui, server=server)

