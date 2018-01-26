library(shiny)

data(iris)

#initialization of server.R
shinyServer(function(input, output) {

  sset <- reactive(subset(iris, Species == input$species))
  
  #Text to output
  output$report <- renderText(
    paste0("The filtered dataset contains ",nrow(sset()), " rows")
  )
  
  #Download Handler
  output$download <- downloadHandler(
    filename= function() {paste0("Data_",input$species,"_",Sys.Date(),".csv")},
    content= function(file){
      write.csv(sset(),file, row.names=F)}
    )
  
})