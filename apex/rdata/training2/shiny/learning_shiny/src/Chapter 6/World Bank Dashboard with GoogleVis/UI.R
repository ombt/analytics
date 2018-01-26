library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("World Bank Dashboard with GoogleVis"),
  
  # Sidebar
  sidebarLayout(  
  sidebarPanel(
      #Country selection
      checkboxGroupInput("countries","Select the countries:",
                  countries.vector, 
                  selected=countries.vector),
      
      #Years selection
      sliderInput("years","Select the year range",min(frame$year),max(frame$year),
                  value = c(min(frame$year),max(frame$year))),
      #Map variable selection
      selectInput("map.var","Select the variable to plot in the map",indicators.vector)),
    
  #The plot created in server.R is displayed
    mainPanel(
      #htmlOutput("MotionChart")
      tabsetPanel(
        tabPanel("Map Chart",htmlOutput("Map")),
        tabPanel("Motion Chart",htmlOutput("MotionChart"))
    )
  )
  
  )
))
