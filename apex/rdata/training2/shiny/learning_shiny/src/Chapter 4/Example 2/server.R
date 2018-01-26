library(shiny)

#initialization of server.R
shinyServer(function(input, output) {

  words <- reactive(unlist(strsplit(input$text, split = " ")))
  
  #Plot generation
  
  output$text.words <- renderText(paste0("This phrase has ",length(words())," words in total"))
  
  output$text.longest <- renderText({
    word.chars <- nchar(words())
    max.len <- max(word.chars)
    longest.word <- words()[which.max(word.chars)]
    paste0(longest.word, " is the longest word and has ",max.len,"
           characters")
  })
  })