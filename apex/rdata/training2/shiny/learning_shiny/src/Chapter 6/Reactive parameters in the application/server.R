library(shiny)

#initialization of server.R
shinyServer(function(input, output) {

  iris.sset <- reactive(subset(iris,Species %in% input$species))
  species.color <- reactive(unique(iris.sset()[,5:6]))
  
  #Table generation where the summary is displayed
  output$custom.plot <- renderPlot({
    title <- paste0(input$xvar,"/",input$yvar," dispersion graph")
    plot(iris.sset()[[input$xvar]],iris.sset()[[input$yvar]], col= iris.sset()$color, pch = 16,main= title,
         xlab =input$xvar, ylab=input$yvar,cex=0.8)
    
    #Horizontal Position for legend
    
    min.x <- min(iris.sset()[[input$xvar]])
    max.x <- max(iris.sset()[[input$xvar]])
    
    x.diff <- max.x - min.x
    x.pos <-  min.x + x.diff * 0.8
    
    #Vertical Position for legend
    
    min.y <- min(iris.sset()[[input$yvar]])
    max.y <- max(iris.sset()[[input$yvar]])
    
    y.diff <- max.y - min.y
    y.pos <-  min.y + y.diff * 0.2
    
    #Legend creation
    
    legend(x.pos,y.pos,legend=species.color()[,1], pch=16, col=species.color()[,2],cex=0.7)
    
  })
  
})