library(shiny)

# Starting line
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Countries Example"),
  
  # Sidebar with a numeric input
    # Sidebar
  sidebarLayout(  
  sidebarPanel(
      selectInput("continent", "Select the continent: ",
                    c("Africa","America","Asia","Europe"),
                    selected = "Africa"),
      checkboxGroupInput("country",
                   "Select the countries:",choices = c(""))
  ),
    
  #The plot created in server.R is displayed
    mainPanel(
      htmlOutput("map"))
    )
))
