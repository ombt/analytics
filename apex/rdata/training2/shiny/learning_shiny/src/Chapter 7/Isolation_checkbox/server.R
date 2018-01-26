library(shiny)

#initialization of server.R
shinyServer(function(input, output) {
  
  #Plot generation
  output$plot <- renderPlot({
    #Isolation condition
    input$selector
    
    isolate({
        plot(1/1:input$number)})
    })
    
  })