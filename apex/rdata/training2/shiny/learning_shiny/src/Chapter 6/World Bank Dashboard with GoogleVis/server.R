library(shiny)

#initialization of server.R
shinyServer(function(input, output) {

  frame.sset <- reactive({subset(frame,iso2c %in% input$countries &
                                   year >= input$years[1] & 
                                   year <= input$years[2])})
  
  #Table generation where the summary is displayed
  output$Map <- renderGvis({
    aggregated.frame <- aggregate(.~iso2c + country,frame.sset()[,-3], sum)
    map <- gvisGeoChart(aggregated.frame, locationvar="iso2c",sizevar=input$map.var,
                 hovervar="country", 
                 options = list(region="world",displayMode="regions"))    
    return(map)
    })
  
  output$MotionChart <- renderGvis({
    mchart <- gvisMotionChart(frame.sset(), "country","year")
    return(mchart)
  })
  
})