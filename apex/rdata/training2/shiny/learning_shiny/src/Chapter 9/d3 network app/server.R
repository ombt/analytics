library(shiny)

#initialization of server.R
shinyServer(function(input, output) {

  selections <- reactive({
    selected.continents <- sapply(world$children, "[[", "name") %in% input$continents
    list(name=world$name, children = world$children[selected.continents])
    })
  
  
  #Plot generation
  output$graph <- renderTreeNetwork({
    treeNetwork(selections(),fontSize = 20)})
  
})