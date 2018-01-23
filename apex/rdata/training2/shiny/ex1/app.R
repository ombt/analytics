library(shiny)

ui <- fluidPage(
    titlePanel("Hello Shiny!"),

    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "bins",
                        label = "Number of bins",
                        min = 5,
                        max = 50,
                        value = 30)
        ),
        mainPanel(
                plotOutput(outputId = "distPlot")
        )
    )
)

server <- function(input, output) {
    output$distPlot = 
        renderPlot(
            {
                x <- faithful$waiting
                bins <- seq(min(x), max(x), length.out=input$bins+1)
                hist(x, 
                     breaks=bins, 
                     col="#78AAD8", 
                     border= "orange",
                     xlab = "waiting time to next erruption (minutes)",
                     ylab = "histogram of waiting times")
            }
        )
}

shinyApp(ui=ui, server=server)

