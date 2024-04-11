#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

    rv <- reactiveValues()

    observe(rv$selected.dataset <- subset(MetaData, Label == input$InputDataset))

    #generate dynamic menus

    observe({
      req(selected.column<-unique(rv$selected.dataset$Column))
      selected.optional.column<-c("NULL",selected.column)
      selected.categorical.column<-unique(subset(rv$selected.dataset, unique<7)$Column)
      runjs("$('.box.collapsed-box').addClass('custom-toggle-collapse')")
      runjs("$('.custom-toggle-collapse button.btn-box-tool').click()")
      for (ii in ggAllAES) {
        iichoices<- if (!ii %in% ggCoreAes) {selected.optional.column} else {selected.column}
        updateSelectizeInput(inputId=paste0(ii,"_var"),choices = iichoices)
      }
      output$Facet1VarMenu <- renderUI(selectizeInput("Facet1Var","Selected Variable Facet, 1 Column",c("NULL", selected.categorical.column)))
      output$Facet2VarMenu <- renderUI(selectizeInput("Facet2Var","Selected Variable Facet, 2 Column",c("NULL", selected.categorical.column)))
      runjs("
        var checkCustomToggleInterval = setInterval(function(){
          if($('.collapsed-box.custom-toggle-collapse').length == 0){
            clearInterval(checkCustomToggleInterval);
            $('.custom-toggle-collapse button.btn-box-tool').click();
            $('.custom-toggle-collapse').removeClass('custom-toggle-collapse');
          }
        },100);
        ");
    })

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

      AESargs <- isolate(reactiveValuesToList(input) [paste0(ggAllAES,"_var")]) %>%
        unlist() %>%
        {.[.!="NULL"]} %>%
        paste0(gsub("_var","",names(.)),"=",.,collapse=",")

      # AESargs  <- reactiveValuesToList(input) [paste0(ggAllAES,"_var")] %>%
      #   unlist()
      # AESargs <- AESargs[AESargs!="NULL"]
      # AESargs <- paste0(gsub("_var","",names(AESargs)),"=",AESargs,collapse=",")

      isolate(
        rv$plotcommand <-
        sprintf(
          'as.data.frame(%s::%s) %%>%% ggplot(aes(%s))+%s',
          rv$selected.dataset$Package[1],
          rv$selected.dataset$Item[1],
          AESargs,
          paste0(input$ggplotLayers, "()", collapse = "+")
          #combining basic plot command with facetcode from above
        ) %>% paste(facetcode))
    })

    output$plotoutput<-renderPlot({out<-try(rv$plotcommand %>% parse(text=.) %>% eval());if(!is(out,'try-error')) out})
    output$plotcommand<-renderText(rv$plotcommand)

    observe(if(input$debug > 0){browser()})
}

