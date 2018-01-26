library(shiny)

    # Starting line
  shinyUI(fluidPage(
    
    # Application title
    titlePanel("Example 3"),
    
    sidebarLayout(
    
    # Sidebar
    sidebarPanel(
      #Species selection
      selectInput("species","Select a species:",
                  c("setosa","versicolor", "virginica"))),
    
    
    mainPanel(
      #The summary table created in server.R is displayed
      tableOutput("table")

    )
  )
  ))
