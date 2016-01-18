library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Tweets"),

    sidebarLayout(
        sidebarPanel(
            textInput('WordTwitter', label = 'Enter word(s) to be searched ',value="word"),
            
            selectInput("language","Choose a language:", 
                        choices=c("Any","English","Spanish","Italian","Portuguese",
                                  "French")),
            
            numericInput('nTweet',"Maximum number of tweets to return", value=100,max=500,step=50),

            actionButton(inputId='actionbutton',icon =icon("twitter"), label="click on!"),            

            br(),
            br(),
    
            helpText('INSTRUCTIONS: Search Twitter '),
            helpText('This application allows you to find out tweets that include the words specified in the query. You can select the language to be used and the maximum number of tweets to be returned'),
            helpText('Do not forget to press the CLICK ON Button'),
            helpText('The application shows a word cloud of the tweets extracted by the query and a table with those tweets'),
            helpText('Prepared by Angela Di Serio as part of the course project in "Developing Data Products" in the "Data Science Specialization" of the Johns Hopkins University')

        ),
        
        # Show a tabset that includes a plot, summary, and table view
        # of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Word Cloud", plotOutput("wordPlot")) ,
                        tabPanel("Table", dataTableOutput("table"))
            )
        )
    )
))



