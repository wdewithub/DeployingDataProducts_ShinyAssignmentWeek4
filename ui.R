#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#setwd("C:/Users/Wendy/DataScience/Developing Data Products/Assignment_Wk4")

library(shiny)
library(datasets)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Ozone level expectations"),
  
  # Sidebar with slider inputs for specifying the values of the Ozone predictors
  sidebarLayout(
    sidebarPanel(
       h2("What are the weather conditions:"),
       sliderInput("wind",
                   "Specify wind speed (mph):",
                   min = 1,
                   max = 100,
                   value = 15),
       sliderInput("temperature",
                   "Specify the temperature (Fahrenheit):",
                   min = 0,
                   max = 125,
                   value = 70),
        checkboxInput("show_solar", "Do you have an idea about the solar radiation ?", FALSE),
        
       conditionalPanel(condition = "input.show_solar",
                     sliderInput("solar", "Specify Solar radiation (lang): ",
                        min=5,
                        max=340,
                        value=200)),

       conditionalPanel(condition = "!input.show_solar",
                     sliderInput("maand", "Specify the month we're in:", 
                     min=5,
                     max=9,
                     value=6))

       
    ),
    
    

    # Show a barplot of the expected ozone level + give the 95% confidence interval
    mainPanel(
      tabsetPanel(type="tabs",
           tabPanel("Documentation", br(), htmlOutput("Documentation")),
           tabPanel("Ozone calculator", br(),
           h3("The expected Ozone concentration for the given weather conditions is:"),
           plotOutput("plot_ozone"))
              )
  )
)
)
)