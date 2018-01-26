library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interaction Example"),
  
  sidebarLayout(
  
  # Sidebar with a numeric input
    sidebarPanel(
      selectInput("var1", "Select variable 1", names(iris)),
      selectInput("var2", "Select variable 2", names(iris))
    ),
    
    
  #The plot created in server.R is displayed
    mainPanel(
      plotOutput("plot",brush = brushOpts(
        id = "plot_brush")),
      tableOutput("selectedpoints")
    )
  )
))
