library(shiny)

#initialization of server.R
shinyServer(function(input, output) {
  
  #Plot generation
  output$plot <- renderPlot({
    plot(1/1:input$number)
  })
  
  observe({
    if(!is.na(input$number)){
    sink("values log.txt", append=T)
    cat(input$number)
    cat("\n")
    sink()}
  })
  
})