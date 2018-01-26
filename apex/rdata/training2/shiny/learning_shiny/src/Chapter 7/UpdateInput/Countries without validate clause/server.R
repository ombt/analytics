library(shiny)
library(googleVis)

#initialization of server.R
shinyServer(function(input, output,session) {

  #Plot generation
  output$map <- renderGvis({
    
    plot.dataset <- data.frame(countries = input$country, value=5)
    
    continent.code <- switch(input$continent,
                      Africa = "002",
                      America = "019",
                      Asia = "142",
                      Europe = "150")
    
    gvisGeoChart(plot.dataset, locationvar="countries",sizevar="value",
                 options = list(region=continent.code,displayMode="regions"))
    
  })
    
  
  observe({
    
    continent.countries <- switch(input$continent,
                  Africa = c("Tunisia","Egypt","South Africa","Lybia"),
                  America = c("Argentina","Brazil","Mexico","USA"),
                  Asia = c("China","Japan","India","Indonesia"),
                  Europe = c("France","Germany","Italy","Spain"))
    
    updateCheckboxGroupInput(session,"country",choices = continent.countries)
  })
  
})