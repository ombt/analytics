library(shiny)

ui <- fluidPage(
    titlePanel(
        "My Shiny App"
    ),
    sidebarLayout(
        sidebarPanel(),
        mainPanel(
            img(src="earth-photo.png", height=400, width=400)
        )
    )
)

server <- function(input, output) {
}

shinyApp(ui=ui, server=server)

