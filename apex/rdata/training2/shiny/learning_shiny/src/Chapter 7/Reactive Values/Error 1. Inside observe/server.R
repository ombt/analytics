library(shiny)

#initialization of server.R
shinyServer(function(input, output) {
  
  
  observe({
    counter <- 0
     if(!is.na(input$number)){
       counter <- counter + 1
      cat(counter, sep ="\n")}
  })

  
  #Plot generation
  output$plot <- renderPlot({
    plot(1/1:input$number)
  })
  
  
  
})