library(shiny)

#initialization of server.R
shinyServer(function(input, output) {
  
  reactiveval.list <- reactiveValues(counter = 0)
  
  observe({
  
    input$number
      isolate({
     if(!is.na(input$number)){
       reactiveval.list$counter <- reactiveval.list$counter + 1
      cat(reactiveval.list$counter, sep ="\n")}
  })
  })

  
  #Plot generation
  output$plot <- renderPlot({
    plot(1/1:input$number)
  })
  
  
  
})