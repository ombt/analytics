library(shiny)
# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Example 2"),
  # Sidebar with a numeric input
  textInput("text",
            "Insert a text:",
            value = "The cat is brown"),
  
  #The plot created in server.R is displayed
  
  textOutput("text.words"),
  textOutput("text.longest")
          
  )
)