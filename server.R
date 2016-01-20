library(shiny)
library(tm)
library(wordcloud)
library(twitteR)
library(R.utils)
library(RCurl)
library(RJSONIO)
library(httr)
library(stringr)

consumer_key    <- "Your consumer key"
consumer_secret <- "Your consumer secret"
access_token    <- "Your access token"
access_secret   <- "Your access secret"  

# Twitter Authentication using direct Authentication
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_secret) 
token <- get("oauth_token", twitteR:::oauth_cache)
token$cache()

shinyServer(function(input, output, session) {


    # function used to search tweets that meet the specified query
    TweetData<-function(searchTw)
    {
        
        twtList<-searchTwitter(searchTw,n=maxTw(), langInput())
        twtLista<- do.call("rbind",lapply(twtList,as.data.frame))
        
        # searchTwitter might return an empty List
        # to avoid an error message when this happens, then a list is created with one element
        if (length(twtLista)==0) {
            twtLista <- dataFrame(colClasses("clilcllclccillll"), nrow=1)
            names(twtLista)<- c("text","favorited","favoriteCount","replyToSN","created","truncated",
                                "replyToSID","id","replyToUID","statusSource","screenName",
                                "retweetCount","isRetweet","retweeted","longitude","latitude")
            twtLista$text<-"No tweets were found"
            twtLista$screenName <- " "
            twtLista$created<-""
            twtLista$reteetCount<-0
        }
        
        return(twtLista)
        
    }  
    maxTw <- reactive({input$nTweet})    # number of tweets to be returned
    langInput<- reactive({
        switch(input$language,"Any"="","English"="en","Spanish"="es","Italian"="it",
               "Portuguese"="pt","French"="fr")
    })
    
    wordT<- reactive({
        if (input$WordTwitter=="")
            return(" ")
        else
            return(input$WordTwitter)
    })
    
    
    Lista <- eventReactive(input$actionbutton, {
        input$WordTwitter
        TweetData(input$WordTwitter)

        })
 
    # Word Cloud Plotting
    output$wordPlot <- renderPlot({ wordcloud(paste((Lista())$text, collapse=" "), min.freq = 5, 
                       random.color=TRUE, max.words=50 ,colors=brewer.pal(8, "Dark2"))  
                                  })
    # Plot of tweets using a Table format
    output$table <- renderDataTable({data.frame(user=(Lista()$screenName),
                                                Tweets=(Lista()$text),
                                                Created=(Lista()$created),
                                                NumberRetweets=(Lista()$retweetCount),
                                                ReTweeted=(Lista()$isRetweet))})
         
})
