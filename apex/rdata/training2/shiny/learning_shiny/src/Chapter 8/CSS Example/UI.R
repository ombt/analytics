library(shiny)
# Starting line
shinyUI(bootstrapPage(
  
  #CSS to change "number's" background color
  tags$head(tags$style(HTML("#number {background-color: yellow;}"))),
  
  # Application title
  titlePanel("Example 1"),
  sidebarLayout(

    # Sidebar with a numeric input
    sidebarPanel(
      numericInput("number",
                   "Insert a number:",
                   value = 30,
                   min = 1,
                   max = 50)
    ),
    #The plot created in server.R is displayed
    mainPanel(
      plotOutput("plot")
    )
  )
))