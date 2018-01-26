library(shiny)

#initialization of server.R
shinyServer(function(input, output) {

  
  #Table generation where the summary is displayed
  output$table <- renderTable(
    summary(subset(iris, Species == input$species)[-5])
  )
  
})
