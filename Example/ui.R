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


fluidPage(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="dashboard.css")),
  useShinydashboard(), useShinyjs(),

    # Application title
    titlePanel("Dataset Visualization"),

    sidebarLayout(
        sidebarPanel(
          selectizeInput("InputDataset","Select Dataset",unique(MetaData$Label)),
          selectizeInput("ggplotLayers","Select Layer (a ggplot geom function)",names(AESsummary), selected = "geom_point", multiple=TRUE),
          uiOutput("XvarMenu"),
          uiOutput("YvarMenu"),
          uiOutput("ZvarMenu"),
          uiOutput("ColorVarMenu"),
          uiOutput("SizeVarMenu"),
          uiOutput("AlphaVarMenu"),
          uiOutput("Facet1VarMenu"),
          uiOutput("Facet2VarMenu"),
          uiOutput('x_menu'),
          box(title='additional X variables',width=NULL,collapsible=T,collapsed=T,
          uiOutput('xmax_menu'),
          uiOutput('xmin_menu'),
          uiOutput('xend_menu'),
          uiOutput('xintercept_menu'),
          uiOutput('xlower_menu'),
          uiOutput('xmiddle_menu'),
          uiOutput('xupper_menu')),
          uiOutput('y_menu'),
          box(title='additional X variables',width=NULL,collapsible=T,collapsed=T,
          uiOutput('ymax_menu'),
          uiOutput('ymin_menu'),
          uiOutput('yend_menu'),
          uiOutput('yintercept_menu')),
          uiOutput('angle_menu'),
          uiOutput('intercept_menu'),
          uiOutput('label_menu'),
          uiOutput('lower_menu'),
          uiOutput('middle_menu'),
          uiOutput('radius_menu'),
          uiOutput('slope_menu'),
          uiOutput('upper_menu'),
          uiOutput('colour_menu'),
          uiOutput('fill_menu'),
          uiOutput('linetype_menu'),
          uiOutput('linewidth_menu'),
          uiOutput('shape_menu'),
          uiOutput('size_menu'),
          uiOutput('alpha_menu')
        ),
        mainPanel(
          actionButton('update', 'Update'),
          actionButton('debug', 'Click Here for Debug'),
            plotOutput("plotoutput"),
            textOutput("plotcommand")
        )
    )
)
