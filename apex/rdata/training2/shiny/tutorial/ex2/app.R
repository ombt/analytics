library(shiny)

ui <- fluidPage(
    titlePanel(
        "my title page"
    ),
    sidebarLayout(
        position = "right",
        sidebarPanel(
            "sidebar panel"
        ),
        mainPanel(
            h6("Episode IV", align = "center"),
            h6("A NEW HOPE", align = "center"),
            h5("It is a period of civil war", align = "center"),
            h4("Rebel spaceships, striking", align = "center"),
            h3("from a hidden base, have won", align = "center"),
            h2("their first victory against the", align = "center"),
            h1("evil Galactic Empire")
        )
    )
)

server <- function(input, output) {
}

shinyApp(ui=ui, server=server)

