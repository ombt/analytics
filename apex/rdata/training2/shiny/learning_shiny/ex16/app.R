library(shiny)

ui <- fluidPage(

    titlePanel("Action Button Example"),

    sidebarLayout(
        sidebarPanel(
            numericInput(
                "number",
                "Insert a number: ",
                value = 30,
                min = 1,
                max = 50
            )
        ),
        mainPanel(
            conditionalPanel(
                condition="input.number > 0",
                plotOutput("plot")
            )
        )
    )
)

server <- function(input, output)
{
    reactiveval.list <- reactiveValues(counter = 0)

    observe(
    {
        input$number

        isolate(
        {
            if ( ! is.na(input$number))
            {
                reactiveval.list$counter <-
                    reactiveval.list$counter + 1
                print(sprintf("Value is: %f", reactiveval.list$counter))
            }
        } )
    } )
    output$plot <- 
        renderPlot(
        {
            plot(1/1:input$number)
        } )
}

shinyApp(ui=ui, server=server)

