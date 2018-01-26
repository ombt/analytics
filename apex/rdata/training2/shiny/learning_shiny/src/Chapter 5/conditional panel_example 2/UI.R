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
      #Checkbox to select color
      
      checkboxInput("selectcolor",label = "Change color"),
      
      #Conditional Panel. When the checkbox is ticked, it displays 
      #the radio button options
      
      conditionalPanel("input.selectcolor == true",
        radioButtons("color", "Pick up the color:",
                     c("red" = "red", "blue" = "blue", "green" = "green")))),
    
    
  #The plot created in server.R is displayed
    mainPanel(
      conditionalPanel(condition= "input.number > 0",
      plotOutput("plot"))
    )
  )
))
