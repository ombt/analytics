library(shiny)

# Starting line
shinyUI(bootstrapPage(
  
  tags$head(tags$script(src = "change_color.js")),
  
  tags$head(tags$script(HTML(
'  var colorover;
   var colorout;
Shiny.addCustomMessageHandler("updatecolors",
  function(color) { colorover= String(color.over);
                    colorout= String(color.out)});'
  ))),
  
  # Application title
  titlePanel("Example 1"),
  
  # Sidebar with a numeric input
    # Sidebar
  sidebarLayout(  
  sidebarPanel(
      onmouseover = 'changeColor(this,colorover)',
      onmouseout = 'changeColor(this,colorout)',
      style = "background-color: green;",
      numericInput("number",
                  "Insert a number:",
                  value = 30,
                  min = 1,
                  max = 50)),
    
    
  #The plot created in server.R is displayed
    mainPanel(
      plotOutput("plot")
    )
  )
))
