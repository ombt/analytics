library(shiny)

data(iris)

ui <- fluidPage(

    titlePanel
    (
        "Example 4"
    ),
    sidebarPanel
    (
        selectInput
        (
            "Species",
            "Select a species: ",
            levels(iris$Species),
            iris$Species[1]
        )
    ),
    mainPanel
    (
        plotOutput("plot"),
        tableOutput("table")
    )
)

server <- function(input, output)
{
    iris.sset <- reactive(subset(iris, Species==input$Species)[,1:4])

    output$table <- 
        renderTable( {
            summary(iris.sset())
        } )

    output$plot <- 
        renderPlot( {
            plot(iris.sset())
        } )
}

shinyApp(ui=ui, server=server)

