library(shiny)

    # Starting line
  shinyUI(fluidPage(

    # Application title
    titlePanel("Example with D3BarChart"),

    sidebarLayout(

    sidebarPanel(

        #Species selection
      selectInput("var1","Select variable:",
                  choices = setdiff(names(aggreg.iris),"Species"), selected = NULL)),

    mainPanel(
      #The plot is displayed via the special function

      D3BarChartOutput("plot1")
    )
  )
  ))
