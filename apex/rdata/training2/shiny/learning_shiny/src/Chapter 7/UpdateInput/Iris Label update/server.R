library(shiny)

#initialization of server.R
shinyServer(function(input, output,session) {

  observe({
    
    input.label <- paste0("Select the minimum value for ",input$variable,":")
    
    updateNumericInput(session,"value",label = input.label)
  })
  
  #Table generation where the summary is displayed
  output$table <- renderTable({
    subset(iris, get(input$variable) > input$value )})
  
})