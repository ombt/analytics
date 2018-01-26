library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Reactive parameters in the application with ggplot2"),
  
  # Sidebar
  sidebarLayout(  
  sidebarPanel(
      #Species selection
      checkboxGroupInput("species","Select the species to plot:",
                  c("setosa"= "setosa", 
                    "versicolor"="versicolor", "virginica"="virginica"), 
                  selected=c("setosa","versicolor","virginica")),
      selectInput("xvar","Select the variable on the horizontal axis",names(iris)[1:4]),
      selectInput("yvar","Select the variable on the vertical axis",names(iris)[1:4])),
    
  #The plot created in server.R is displayed
    mainPanel(
      plotOutput("custom.plot")
    )
  
  )
))
