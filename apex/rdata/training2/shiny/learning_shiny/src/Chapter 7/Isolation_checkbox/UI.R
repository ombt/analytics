library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Example 1"),
  
  # Sidebar with a numeric input
    # Sidebar
  sidebarLayout(  
  sidebarPanel(
      numericInput("number",
                  "Insert a number:",
                  value = 30,
                  min = 1,
                  max = 50),
      
      #Checkbox
      checkboxInput("selector",label = "Checkbox")
              ),
    
  #The plot created in server.R is displayed
    mainPanel(
      plotOutput("plot"))
    )
))
