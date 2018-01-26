library(shiny)

#initialization of server.R
shinyServer(function(input, output) {

  #Plot generation
  output$plot <- renderPlot({
    selected.vars <- c(input$var1, input$var2)

    plot(iris[,c(selected.vars)])
  })
  
  output$selectedpoints <- renderTable({

    
    return(brushedPoints(iris,input$plot_brush, xvar = input$var1, yvar = input$var2))

    #This is the other alternative   
    #     iris.sset <- iris[,iris[[input$var1]] >= input$plot_brush$xmin & 
    #       iris[[input$var1]] <= input$plot_brush$xmax & 
    #       iris[[input$var2]] >= input$plot_brush$ymin & 
    #       iris[[input$var2]] <= input$plot_brush$ymax]
    #    return(iris.sset)
         
  })
  
})