library(shiny)
library(googleVis)

ui <- fluidPage(

    titlePanel("Countries Update Example"),

    sidebarLayout(
        sidebarPanel(
            selectInput(
                "continent", 
                "Select the continent: ",
                c("Africa", 
                  "America", 
                  "Asia",
                  "Europe"),
                selected = "Africa"),
            checkboxGroupInput(
                "country",
                "Select the countries:",
                choices = c("")
            )
        ),
        mainPanel(
            htmlOutput("map")
        )
    )
)

server <- function(input, output, session)
{
    output$map <- 
        renderGvis(
        {
            validate(
                need(length(input$country) > 0, 
                     "Please select at least one country")
            )
            plot.dataset <- 
                data.frame(
                    countries = input$country, 
                    value=5
                )
            continent.code <- 
                switch(
                    input$continent,
                    Africa = "002",
                    America = "019",
                    Asia = "142",
                    Europe = "150"
                )
            gvisGeoChart(
                plot.dataset, 
                locationvar="countries",
                sizevar="value",
                options = list(region=continent.code,
                               displayMode="regions")
            )
        } )
    observe(
    {
        continent.countries <- 
            switch(
                input$continent,
                Africa = c("Tunisia","Egypt","South Africa","Lybia"),
                America = c("Argentina","Brazil","Mexico","USA"),
                Asia = c("China","Japan","India","Indonesia"),
                Europe = c("France","Germany","Italy","Spain")
            )
            updateCheckboxGroupInput(
                session,
                "country",
                choices = continent.countries)
    })
}

shinyApp(ui=ui, server=server)

