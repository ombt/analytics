library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Iris"),
  
  # Sidebar
  sidebarLayout(  
  sidebarPanel(
      #Species selection
      selectInput("variable","Select a variable:",
                  setdiff(names(iris),"Species")),
    
      # Value input   
      numericInput("value","",value=0,min = 0)
      ),
  
  #The plot created in server.R is displayed
    mainPanel(
      tableOutput("table")
    )
  
  )
))
