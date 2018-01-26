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
            ),
            checkboxInput(
                "selectcolor",
                label="Change color"
            ),
            conditionalPanel(
                "input.selectcolor==true",
                radioButtons(
                    "color",
                    "Pick a color: ",
                    c("red","blue","green")
                )
            ),
            checkboxInput(
                "selector",
                label="Checkbox"
            )
        ),
        mainPanel(
            # conditionalPanel(
                # condition="input.number > 0",
                plotOutput("plot")
            # )
        )
    )
)

server <- function(input, output)
{
    output$plot <- 
        renderPlot(
        {
            input$selector

            isolate(
            {
                if (input$selectcolor)
                {
                    plot(1/1:input$number, col=input$color)
                }
                else
                {
                    plot(1/1:input$number)
                }
            } )
        } )
}

shinyApp(ui=ui, server=server)

