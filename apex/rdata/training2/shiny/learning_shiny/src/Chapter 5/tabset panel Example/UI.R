library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tabset Example"),
  
  # Sidebar
  sidebarLayout(  
  sidebarPanel(
      #Species selection
      selectInput("species","Select a species:",
                  c("setosa", "versicolor", "virginica"))),
    
  #The plot created in server.R is displayed
    mainPanel(
      tabsetPanel(
        tabPanel("Summaries",tableOutput("table")),
        tabPanel("Graphics",plotOutput("plot"))
    ))
  
  )
))
