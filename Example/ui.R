#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(hexbin)


fluidPage(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="dashboard.css")),
  useShinydashboard(), useShinyjs(),

  # Application title
  titlePanel("Dataset Visualization"),

  sidebarLayout(
    sidebarPanel(
      selectizeInput("InputDataset","Select Dataset",unique(MetaData$Label), selected = grep('diamonds.*ggplot2',MetaData$Label,val=T) %>% head(1)),
      selectizeInput("ggplotLayers","Select Layer (a ggplot geom function)",names(AESsummary), selected = "geom_point", multiple=TRUE),
      uiOutput("Facet1VarMenu"),
      uiOutput("Facet2VarMenu"),
      selectizeInput("x_var","Select x variable",c()),
      box(title='additional X variables',width=NULL,collapsible=T,collapsed=T,
          lapply(ggXAes, function(ii) {
            selectizeInput(paste0(ii,"_var"),paste0("select ", ii," variable"),c())
            })),
      selectizeInput("y_var","Select y variable",c()),
      box(title='additional Y variables',width=NULL,collapsible=T,collapsed=T,
          lapply(ggYAes, function(ii) {
            selectizeInput(paste0(ii,"_var"),paste0("select ", ii," variable"),c())
          })),
      lapply(ggOtherAes, function(ii) {
        selectizeInput(paste0(ii,"_var"),paste0("select ", ii," variable"),c())
      }),
      box(title='uncommon variables',width=NULL,collapsible=T,collapsed=T,
          lapply(ggUncommonAes, function(ii) {
            selectizeInput(paste0(ii,"_var"),paste0("select ", ii," variable"),c())
          }))
    ),
    mainPanel(
      actionButton('update', 'Update'),
      actionButton('debug', 'Click Here for Debug'),
      plotOutput("plotoutput"),
      textOutput("plotcommand")
    )
  )
)
