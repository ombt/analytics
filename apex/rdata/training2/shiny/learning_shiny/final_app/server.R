library(shiny)

#initialization of server.R
shinyServer(function(input, output) {

  #Reactive subset
  
  data.sset <- reactive({
  input$submitter
      isolate({
      subset(data.adult, sex %in% input$gender & age >= input$minage & 
               age <= input$maxage & marital.status %in% input$marital.stat &
               race %in% input$ethnic)
      
    })
    
    })
  
 
  
  #### Demograhpics chart ####
  
  genders.amount <- reactive({
    input$submitter
    isolate({length(input$gender)})
  })
  
  output$genderbars <- renderPlot({
    
    barplot(prop.table(table(data.sset()$sex)) * 100, 
            col = c("red","blue")[1:genders.amount()],
            ylab = "Proportion (in %)")
    
  })
  
  
  output$agechart <- renderPlot({

    agg.set <- with(data.sset(), melt(prop.table(table(sex,age),1)))
    agg.set$value <- agg.set$value *  100
    age_sex.plot <- ggplot(agg.set, aes(x=age,y=value,group=sex, colour = sex))
    age_sex.plot <- age_sex.plot + geom_line()
    age_sex.plot <- age_sex.plot + theme(legend.title=element_blank())
    age_sex.plot <- age_sex.plot + labs(y = "Proportion (in %)")
    age_sex.plot <- age_sex.plot + labs(x = "Age")
    return(age_sex.plot)
  })
  
  
  output$ethnicbars <- renderGvis({
    
    agg.set <- with(data.sset(), melt(prop.table(table(race,sex),1)))
    agg.set$value <- agg.set$value *  100
    agg.set <- dcast(agg.set,formula = race ~ sex, value.var = "value")
    ret <- gvisColumnChart(agg.set, xvar = "race", yvar = c("Female","Male"),
                           options=list( height="300px"))
    
  })
  
  output$marital.statustable <- renderTable({
    
    marital.status.table <- as.data.frame.table(prop.table(table(data.sset()$marital.status)))
    marital.status.table[,2] <- round(marital.status.table[,2] * 100)
    names(marital.status.table) <- c("Marital.Status","Percentage")
    
    return(marital.status.table)
    
  })
  
  #### Education curve ####
  
  output$educationcurve <- renderGvis({
    
    freq.table <- with(data.sset(), prop.table(table(mget(c(input$edvar, "education")))))
    cum.perc <- apply(freq.table,1,function(x) cumsum(rev(x))/sum(x))
    cum.perc <- cum.perc[nrow(cum.perc):1,]
    cum.perc <- as.data.frame(cum.perc)
    cum.perc <- cbind(education = row.names(cum.perc),cum.perc) 
    ret <- gvisLineChart(cum.perc, xvar = "education",yvar = names(cum.perc)[-1],
                         options = list(hAxis = "{textStyle: {fontSize : '6px'}}",
                                        vAxis = "{format : 'percent'}",
                                        height = "400px"))
    return(ret)
  })
  
  
  #### Occupation and earnings ####
  
  output$earningsplot <- renderUI({
    
    freq.table <- with(data.sset(), table(mget(c(input$earnvar,"earnings"))))
    chi.test <- chisq.test(freq.table)
    
    html.text <- paste0("p value: ",round(chi.test$p.value,5),"<br><br> chi squared statistic: ",round(chi.test$statistic))
    
    return(HTML(html.text))
    
  })
  
  output$activity.summary <- renderDataTable({
   
    aggregate(hours.per.week ~ occupation + workclass , data = data.sset(),FUN = "median")
    
  }, options = list(pageLength = 10, columnDefs = "{width : '20%'}"))
  
  
})