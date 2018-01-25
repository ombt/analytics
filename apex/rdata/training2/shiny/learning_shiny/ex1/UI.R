library(shiny)

shinyUI(fluidPage(
    # title page
    titlePanel("Example 1"),

    sidebarLayout
    (
        sidebarPanel
        (
            numericInput
            (
                "number",
                "Insert a number: ",
                value = 30,
                min = 1,
                max = 50
            )
        ),
        mainPanel
        (
            plotOutput("plot")
        )
    )
) )
