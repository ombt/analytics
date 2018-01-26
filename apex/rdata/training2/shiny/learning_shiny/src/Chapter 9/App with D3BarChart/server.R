library(shiny)

#initialization of server.R
shinyServer(function(input, output) {


  #Plots generation
  output$plot1 <- renderD3BarChart(

    D3BarChart(aggreg.iris, input$var1, "Species")
  )

})
