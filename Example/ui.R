#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Dataset Visualization"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          selectizeInput("InputDataset","Select Dataset",unique(MetaData$Label)),
          uiOutput("XvarMenu"),
          uiOutput("YvarMenu"),
          uiOutput("ColorVarMenu"),
          uiOutput("SizeVarMenu"),
          uiOutput("AlphaVarMenu"),
          uiOutput("Facet1VarMenu"),
          uiOutput("Facet2VarMenu"),
          actionButton('update', 'Update'),
          actionButton('debug', 'Click Here for Debug'),
          # sliderInput("bins",
          #               "Number of bins:",
          #               min = 1,
          #               max = 50,
          #               value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plotoutput"),
            textOutput("plotcommand")
        )
    )
)
