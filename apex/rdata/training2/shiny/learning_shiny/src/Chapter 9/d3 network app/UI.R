library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Graph Example"),
  
  sidebarLayout( 
  
  # Sidebar with a numeric input
    
    sidebarPanel(
      checkboxGroupInput("continents", "Choose the continents",
                         choices = c("Africa","America","Asia","Europe"),
                        selected = c("Africa","America","Asia","Europe"))
    ),
    
    
  #The plot created in server.R is displayed
    mainPanel(
      treeNetworkOutput("graph")
    )
  )
))
