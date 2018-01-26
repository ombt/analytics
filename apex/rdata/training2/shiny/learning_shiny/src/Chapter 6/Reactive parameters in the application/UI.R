library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Example 3. Reactive parameters in the application"),
  
  # Sidebar
  sidebarLayout(  
  sidebarPanel(
      #Species selection
      checkboxGroupInput("species","Select the species to plot:",
                  levels(iris$Species), 
                  levels(iris$Species)),
      selectInput("xvar","Select the variable on the horizontal axis",names(iris)[1:4]),
      selectInput("yvar","Select the variable on the vertical axis",names(iris)[1:4])),
    
  #The plot created in server.R is displayed
    mainPanel(
      plotOutput("custom.plot")
    )
  
  )
))
