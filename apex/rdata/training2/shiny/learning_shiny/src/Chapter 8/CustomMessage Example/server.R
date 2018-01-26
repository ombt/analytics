library(shiny)

#initialization of server.R
shinyServer(function(input, output,session) {

  observe({
    input$number
    colorover <- ifelse(input$number <= 25,"blue","red")
    colorout <- ifelse(input$number <= 25,"gray","green")
    session$sendCustomMessage(type='updatecolors', list(over=colorover,out =colorout))
    
  })
  
  #Plot generation
  output$plot <- renderPlot({
    plot(1/1:input$number)
  })
  
})