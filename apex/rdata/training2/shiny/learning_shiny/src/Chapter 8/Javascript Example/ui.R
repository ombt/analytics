library(shiny)
# Starting line
shinyUI(fluidPage(
  #JavaScript piece of code
  tags$head(tags$script(HTML("function changeColor(x,y){
                             x.style.backgroundColor = y;}"))),
  # Application title
  titlePanel("Example 1"),
  sidebarLayout(
    # Sidebar with a numeric input
    sidebarPanel(
      onmouseover = 'changeColor(this,"blue")',
      onmouseout ='changeColor(this,"gray")',
      style = 'background-color: gray',
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