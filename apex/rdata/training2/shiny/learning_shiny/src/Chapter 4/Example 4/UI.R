library(shiny)

    # Starting line
  shinyUI(fluidPage(
    
    # Application title
    titlePanel("Example 4"),
    
    sidebarLayout(
    
    # Sidebar
    sidebarPanel(
      #Species selection
      selectInput("species","Select a species:",
                  levels(iris$Species))),
    
    
    mainPanel(
      #The summary table created in server.R is displayed
      tableOutput("table")

    )
  )
  ))
