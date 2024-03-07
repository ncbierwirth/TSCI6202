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
    output$Facet1VarMenu <- renderUI(selectizeInput("Facet1Var","Selected Variable Facet, 1 Column",c("NULL", subset(rv$selected.dataset, unique<7)$Column)))
    output$Facet2VarMenu <- renderUI(selectizeInput("Facet2Var","Selected Variable Facet, 2 Column",c("NULL", subset(rv$selected.dataset, unique<7)$Column)))
    output$x_menu <- renderUI(selectizeInput('x_var', 'Select x variable',   unique(rv$selected.dataset$Column  )))
    output$xmax_menu <- renderUI(selectizeInput('xmax_var', 'Select xmax variable',   unique(rv$selected.dataset$Column  )))
    output$xmin_menu <- renderUI(selectizeInput('xmin_var', 'Select xmin variable',   unique(rv$selected.dataset$Column  )))
    output$y_menu <- renderUI(selectizeInput('y_var', 'Select y variable',   unique(rv$selected.dataset$Column  )))
    output$ymax_menu <- renderUI(selectizeInput('ymax_var', 'Select ymax variable',   unique(rv$selected.dataset$Column  )))
    output$ymin_menu <- renderUI(selectizeInput('ymin_var', 'Select ymin variable',   unique(rv$selected.dataset$Column  )))
    output$angle_menu <- renderUI(selectizeInput('angle_var', 'Select angle variable',   unique(rv$selected.dataset$Column  )))
    output$intercept_menu <- renderUI(selectizeInput('intercept_var', 'Select intercept variable',   unique(rv$selected.dataset$Column  )))
    output$label_menu <- renderUI(selectizeInput('label_var', 'Select label variable',   unique(rv$selected.dataset$Column  )))
    output$lower_menu <- renderUI(selectizeInput('lower_var', 'Select lower variable',   unique(rv$selected.dataset$Column  )))
    output$middle_menu <- renderUI(selectizeInput('middle_var', 'Select middle variable',   unique(rv$selected.dataset$Column  )))
    output$radius_menu <- renderUI(selectizeInput('radius_var', 'Select radius variable',   unique(rv$selected.dataset$Column  )))
    output$slope_menu <- renderUI(selectizeInput('slope_var', 'Select slope variable',   unique(rv$selected.dataset$Column  )))
    output$upper_menu <- renderUI(selectizeInput('upper_var', 'Select upper variable',   unique(rv$selected.dataset$Column  )))
    output$xend_menu <- renderUI(selectizeInput('xend_var', 'Select xend variable',   unique(rv$selected.dataset$Column  )))
    output$xintercept_menu <- renderUI(selectizeInput('xintercept_var', 'Select xintercept variable',   unique(rv$selected.dataset$Column  )))
    output$xlower_menu <- renderUI(selectizeInput('xlower_var', 'Select xlower variable',   unique(rv$selected.dataset$Column  )))
    output$xmiddle_menu <- renderUI(selectizeInput('xmiddle_var', 'Select xmiddle variable',   unique(rv$selected.dataset$Column  )))
    output$xupper_menu <- renderUI(selectizeInput('xupper_var', 'Select xupper variable',   unique(rv$selected.dataset$Column  )))
    output$yend_menu <- renderUI(selectizeInput('yend_var', 'Select yend variable',   unique(rv$selected.dataset$Column  )))
    output$yintercept_menu <- renderUI(selectizeInput('yintercept_var', 'Select yintercept variable',   unique(rv$selected.dataset$Column  )))
    output$colour_menu <- renderUI(selectizeInput('colour_var', 'Select colour variable',   unique(rv$selected.dataset$Column  )))
    output$fill_menu <- renderUI(selectizeInput('fill_var', 'Select fill variable',   unique(rv$selected.dataset$Column  )))
    output$linetype_menu <- renderUI(selectizeInput('linetype_var', 'Select linetype variable',  c("NULL", unique(rv$selected.dataset$Column  ))))
    output$linewidth_menu <- renderUI(selectizeInput('linewidth_var', 'Select linewidth variable',  unique(rv$selected.dataset$Column  )))
    output$shape_menu <- renderUI(selectizeInput('shape_var', 'Select shape variable',   c("NULL", unique(rv$selected.dataset$Column  ))))
    output$size_menu <- renderUI(selectizeInput('size_var', 'Select size variable',   unique(rv$selected.dataset$Column  )))
    output$alpha_menu <- renderUI(selectizeInput('alpha_var', 'Select alpha variable', unique(rv$selected.dataset$Column  )))

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

      AESargs <- reactiveValuesToList(input) [paste0(ggAllAES,"_var")] %>%
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

    output$plotoutput<-renderPlot(rv$plotcommand %>% parse(text=.) %>% eval())
    output$plotcommand<-renderText(rv$plotcommand)

    observe(if(input$debug > 0){browser()})
}

