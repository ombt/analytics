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
    iris.sset <- reactive(subset(iris,Species %in% input$species))

    output$custom.plot <- 
        renderPlot({
            iris.ggplot <- ggplot(data=iris.sset())
            iris.ggplot <- iris.ggplot + 
                           geom_point(aes_string(input$xvar,
                                                 input$yvar,                                                                 colour="Species"))
            iris.ggplot <- iris.ggplot + 
                           ggtitle(paste0(input$xvar,
                                          "/",
                                          input$yvar,
                                          "dispersion graph"))
            plot(iris.ggplot)
        })
}

shinyApp(ui=ui, server=server)

