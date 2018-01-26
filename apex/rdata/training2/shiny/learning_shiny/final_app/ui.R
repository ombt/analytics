library(shiny)

# Starting line
shinyUI(fluidPage(
  
  #CSS styling
  # includeCSS("C:\\Users\\Hernan\\Desktop\\Book for packt\\Chapter 11\\Application\\www\\style.css"),
  includeCSS("www\\style.css"),
  # Application title
  titlePanel("Adult Dataset"),
  
  sidebarLayout( 
    
    # Sidebar 
    
    sidebarPanel(
      h1("Gender"),
      checkboxGroupInput("gender", "Choose the genders",
                         choices = levels(data.adult$sex),
                         selected = levels(data.adult$sex)),
      h1("Age"),
      sliderInput("minage", "Select lower limit", min(data.adult$age), max(data.adult$age), value = min(data.adult$age), step = 1),
      sliderInput("maxage", "Select upper limit", min(data.adult$age), max(data.adult$age), value = max(data.adult$age), step = 1),
      
      h1("Ethnic group"),
      selectInput("ethnic", "Select ethnic groups", choices = levels(data.adult$race), 
                  selected = levels(data.adult$race), multiple = T),
      h1("Marital Status"),
      selectInput("marital.stat", "Select marital status", choices = levels(data.adult$marital.status),
                  selected = levels(data.adult$marital.status), multiple = T),
      
      actionButton("submitter","Submit")
    ),
    
    
  #Main Panel
    mainPanel(
      tabsetPanel(
        tabPanel("Demographics", 
                 column(6,div("Gender Distribution (in %)", class = "title"),
                        br(),
                        plotOutput("genderbars", height = "300px", width = "80%"),
                        div("Age Distribution (in %) by Gender", class = "title"),
                        br(),
                        plotOutput("agechart", height = "300px", width = "80%")),
                 column(6,div("Ethnicity distribution by gender (in %)", class = "title"),
                        br(),
                        htmlOutput("ethnicbars"),
                        div("Marital Status distribution (in %)", class = "title"),
                        br(),br(),
                        tableOutput("marital.statustable"))
                 ),
        tabPanel("Education",
                 div("Educational Curve", class = "title"),
                 selectInput("edvar","Choose the variable to compare",choices = c("sex","race", "marital.status"), selected = "sex"),
                 htmlOutput("educationcurve")),
        tabPanel("Occupation and Earnings",
                 div("Earning Chi test", class = "title"),
                 selectInput("earnvar","Choose the variable to run the test with",
                             choices = factor.vars, selected = factor.vars[1]),
                 htmlOutput("earningsplot"),
                 br(),br(),
                 div("Activity summary", class = "title"),
                 dataTableOutput("activity.summary")
                 )
        )
    )
  )
))
