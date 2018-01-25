library(shiny)

ui <- fluidPage(
    # title page
    titlePanel("Example 1"),

    sidebarLayout
    (
        sidebarPanel
        (
            numericInput
            (
                "number",
                "Insert a number: ",
                value = 30,
                min = 1,
                max = 50
            )
        ),
        mainPanel
        (
            plotOutput("plot")
        )
    )
)

server <- function(input, output)
{
    output$plot <- 
        renderPlot(
        {
            plot(1/1:input$number)
        } )
}

shinyApp(ui=ui, server=server)

