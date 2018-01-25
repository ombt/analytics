library(shiny)

ui <- fluidPage(

    titlePanel
    (
        "Example 2"
    ),
    textInput
    (
        "text",
        "Insert text: ",
        value = "The Cat in the Hat is brown"
    ),
    textOutput("text.words"),
    textOutput("text.longest")
)

server <- function(input, output)
{
    output$text.words <- 
        renderText( {
            words <- unlist(strsplit(input$text, split=" "))
            paste0("This phrase has ",length(words)," words in total")
        } )
    output$text.longest <- 
        renderText( {
            words <- unlist(strsplit(input$text, split = " "))
            word.chars <- nchar(words)
            max.len <- max(word.chars)
            longest.word <- words[which.max(word.chars)]
            paste0(longest.word, " is the longest word and has ",max.len," characters")
        } )
}

shinyApp(ui=ui, server=server)

