library(shiny)

shinyServer(
    function(input, output)
    {
        output$plot <- 
            renderPlot(
            {
                plot(1/1:input$number)
            } )
    }
)
