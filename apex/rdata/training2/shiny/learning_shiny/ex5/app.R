library(shiny)

ui <- fluidPage(

    titlePanel("Conditional Panel - Example 1"),

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
            conditionalPanel
            (
                condition="input.number > 0",
                plotOutput("plot")
            )
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

