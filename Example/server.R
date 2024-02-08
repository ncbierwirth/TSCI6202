#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(ggplot2)
library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        # x    <- faithful[, 2]
        # bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white',
        #      xlab = 'Waiting time to next eruption (in mins)',
        #      main = 'Histogram of waiting times')
        ggplot(faithful, aes(x=waiting)) + geom_histogram(bins = input$bins)

    });

    rv <- reactiveValues()

    observe(rv$selected.dataset <- subset(MetaData, Label == input$InputDataset))

    #generate dynamic menus
    output$XvarMenu <- renderUI(selectizeInput("InputXvar","Selected X Variable",unique(rv$selected.dataset$Column)))
    output$YvarMenu <- renderUI(selectizeInput("InputYvar","Selected Y Variable",unique(rv$selected.dataset$Column)))
    output$ColorVarMenu <- renderUI(selectizeInput("InputColorVar","Selected Variable Color ",c("NULL", unique(rv$selected.dataset$Column))))
    output$SizeVarMenu <- renderUI(selectizeInput("InputSizeVar","Selected Variable Size",c("NULL", unique(rv$selected.dataset$Column))))
    output$AlphaVarMenu <- renderUI(selectizeInput("InputAlphaVar","Selected Variable Alpha",c("NULL", unique(rv$selected.dataset$Column))))

    #create plot command
    observe({
      input$update;
      isolate(
        rv$plotcommand <- sprintf(
          'as.data.frame(%s::%s) %%>%% ggplot(aes(x=%s, y=%s, color=%s, size=%s, alpha=%s))+geom_point()',
          rv$selected.dataset$Package[1],
          rv$selected.dataset$Item[1],
          input$InputXvar,
          input$InputYvar,
          input$InputColorVar,
          input$InputSizeVar,
          input$InputAlphaVar))
    })

    output$plotoutput<-renderPlot(rv$plotcommand %>% parse(text=.) %>% eval())
    output$plotcommand<-renderText(rv$plotcommand)

    observe(if(input$debug > 0){browser()})
}

# subset(MetaData, Label==input$InputDataset)
# foo<-new.env()
# PackageVariable<-unique(testdata$Package)
# ItemVariable<-unique(testdata$Item)
# data(list = ItemVariable, package = PackageVariable, envir = foo)
# attach(foo)
# ggplot(data=cancer, aes(x=age, y=meal.cal)) + geom_point()


