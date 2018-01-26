library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Example 2"),
  
  # Sidebar
  sidebarLayout(  
  sidebarPanel(
      #Species selection
      selectInput("species","Select a species:",
                  c("setosa"= "setosa", 
                    "versicolor"="versicolor", "virginica"="virginica")),
      downloadButton("download", "Download Data")),
    
  #The plot created in server.R is displayed
    mainPanel(
      textOutput("report")
    )
  
  )
))
