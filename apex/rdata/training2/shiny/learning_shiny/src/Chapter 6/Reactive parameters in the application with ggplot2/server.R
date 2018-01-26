library(shiny)

#Call library
library(ggplot2)

#initialization of server.R
shinyServer(function(input, output) {

  iris.sset <- reactive(subset(iris,Species %in% input$species))
  
  #Plot generation
  output$custom.plot <- renderPlot({
    iris.ggplot <- ggplot(data=iris.sset())
    iris.ggplot <- iris.ggplot + geom_point(aes_string(input$xvar, input$yvar, colour="Species"))
    iris.ggplot <- iris.ggplot + ggtitle(paste0(input$xvar,"/",input$yvar," dispersion graph"))
    plot(iris.ggplot)
    
  })
  
})