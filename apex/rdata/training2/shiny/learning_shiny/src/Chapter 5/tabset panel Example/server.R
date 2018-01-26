library(shiny)

data(iris)

#initialization of server.R
shinyServer(function(input, output) {

  sset <- reactive({subset(iris, Species == input$species)[,-5]})
  
  #Table generation where the summary is displayed
  output$table <- renderTable({
    summary(sset())
  })
  
  output$plot <- renderPlot({
    plot(sset())
  })
  
})