library(shiny)

data(iris)

ui <- fluidPage(

    titlePanel
    (
        "Tabset Example"
    ),
    sidebarLayout
    (
        sidebarPanel
        (
            selectInput
            (
                "Species",
                "Select a species: ",
                levels(iris$Species)
            )
        ),
        mainPanel
        (
            tabsetPanel
            (
                tabPanel("Summaries", dataTableOutput("table")),
                tabPanel("Graphics", plotOutput("plot"))
            )
        )
    )
)

server <- function(input, output)
{
    sset <- reactive(subset(iris, Species==input$Species)[,1:4])

    output$table <- 
        renderDataTable( {
            summary(sset())
        } )

    output$plot <- 
        renderPlot( {
            plot(sset())
        } )
}

shinyApp(ui=ui, server=server)

