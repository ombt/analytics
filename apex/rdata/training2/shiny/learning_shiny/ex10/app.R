library(shiny)

data(iris)

iris$color <- sapply(iris$Species, 
                     function(x)
                     {
                         switch(as.character(x),
                                setosa = "red",
                                versicolor = "green",
                                virginica = "blue")
                     } )

ui <- fluidPage(

    titlePanel("Reactive Parameters in the Application"),

    sidebarLayout
    (
        sidebarPanel
        (
            checkboxGroupInput
            (
                "species",
                "Select the species to plot: ",
                levels(iris$Species),
                selected=levels(iris$Species)
            ),
            selectInput("xvar",
                        "Select the variable for the horizontal axis",
                        names(iris)[1:4]),
            selectInput("yvar",
                        "Select the variable for the vertical axis",
                        names(iris)[1:4])
        ),
        mainPanel
        (
            plotOutput("custom.plot")
        )
    )
)

server <- function(input, output)
{
    iris.sset <- reactive(subset(iris, Species %in% input$species))

    species.color <- reactive(unique(iris.sset()[,5:6]))

    output$custom.plot <- 
        renderPlot(
        {
            title <- paste0(input$xvar,
                            "/",
                            input$yvar,
                            " dispersion graph")

            plot(iris.sset()[[input$xvar]],
                 iris.sset()[[input$yvar]], 
                 col=iris.sset()$color, 
                 pch = 16,
                 main= title,
                 xlab=input$xvar, 
                 ylab=input$yvar,
                 cex=0.8)

            min.x <- min(iris.sset()[[input$xvar]])
            max.x <- max(iris.sset()[[input$xvar]])
            x.diff <- max.x - min.x
            x.pos <- min.x + x.diff * 0.8

            min.y <- min(iris.sset()[[input$yvar]])
            max.y <- max(iris.sset()[[input$yvar]])
            y.diff <- max.y - min.y
            y.pos <- min.y + y.diff * 0.2

            legend(x.pos,
                   y.pos,
                   legend=species.color()[,1], 
                   pch=16,
                   col=species.color()[,2],
                   cex=0.7)
        } )
}

shinyApp(ui=ui, server=server)

