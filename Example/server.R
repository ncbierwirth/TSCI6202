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
    output$Facet1VarMenu <- renderUI(selectizeInput("Facet1Var","Selected Variable Facet, 1 Column",c("NULL", subset(rv$selected.dataset, unique<7)$Column)))
    output$Facet2VarMenu <- renderUI(selectizeInput("Facet2Var","Selected Variable Facet, 2 Column",c("NULL", subset(rv$selected.dataset, unique<7)$Column)))


    #create plot command
    observe({
      input$update
      facet1 <- isolate(input$Facet1Var)
      facet2 <- isolate(input$Facet2Var)
      facetcode <- case_when(facet1=="NULL"&facet2=="NULL"~"",
                facet1==facet2~sprintf("+facet_wrap(vars(%s))",facet1),
                facet1=="NULL"~sprintf("+facet_wrap(rows=NA,cols=vars(%s))",facet2),
                facet2=="NULL"~sprintf("+facet_grid(rows=vars(%s), cols=NA)",facet1),
                facet1!="NULL"&facet2!="NULL"~sprintf("+facet_grid(rows=vars(%s), cols=vars(%s))",facet1,facet2),
                TRUE~"Oops!"
                )
      isolate(
        rv$plotcommand <- sprintf(
          'as.data.frame(%s::%s) %%>%% ggplot(aes(x=%s, y=%s, color=%s, size=%s, alpha=%s))+geom_point()',
          rv$selected.dataset$Package[1],
          rv$selected.dataset$Item[1],
          input$InputXvar,
          input$InputYvar,
          input$InputColorVar,
          input$InputSizeVar,
          input$InputAlphaVar
#combining basic plot command with facetcode from above
          ) %>% paste(facetcode))
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


