library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Conditional Panel - Example 1"),
  
  # Sidebar with a numeric input
    # Sidebar
  sidebarLayout(  
  sidebarPanel(
      numericInput("number",
                  "Insert a number:",
                  value = 30,
                  min = 1,
                  max = 50)),
    
  #The plot created in server.R is displayed
    mainPanel(
      conditionalPanel(condition= "input.number > 0",
      plotOutput("plot"))
    )
  )
))
