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
shinyServer(function(input, output) {
   
  library(mice)
  
  airquality_imp <- mice(airquality,m=5,maxit=50,meth='pmm',seed=500)
  completed_airqual <- complete(airquality_imp,4)
  solarfit <- with(completed_airqual,lm(Solar.R~Temp+Month))
  ozonefit <- with(completed_airqual,lm(log(Ozone)~ Temp+Solar.R+Wind))

      
  model_solar <- reactive({     #werkt dit zo of moet je hier nog conditie zetten dat dit enkel is als input$show_solar FALSE is
    MonthInput <- input$maand
    TempInput <- input$temperature
    predict(solarfit, newdata = data.frame(Temp=TempInput, Month=MonthInput))
  })
  
  model_ozone <- reactive({
    TempInput <- input$temperature
    WindInput <- input$wind
    SolarGiven <- input$show_solar
    SolarInput <- ifelse(SolarGiven, input$solar, model_solar())
    predict(ozonefit, newdata = data.frame(Temp=TempInput, Wind=WindInput, Solar.R=SolarInput),interval="predict")
  })

  output$plot_ozone <- renderPlot({
    
    if (exp(model_ozone()[1]) < 100) {barcol <- "green" 
                                 barlab <- "safe ozone level"}
    else if (exp(model_ozone()[1]) < 500) {barcol <- "yellow"
                                      barlab <- "ozone level with minor health risks"}
    else if (exp(model_ozone()[1]) < 1000) {barcol <- "orange"
                                        barlab <- "ozone level with strong health risks"}
    else {barcol <- "red"
          barlab <- "ozone level with severe health risks"}
    
    barp <- barplot(exp(model_ozone()[1]), width=0.1, ylim=c(0,1), xlim=c(0,exp(model_ozone()[1])+1), horiz=TRUE, xlab="Ozone in ppb", col=barcol, main=barlab)
    text(exp(model_ozone()[1]), barp, labels=round(exp(model_ozone()[1]),2), pos=2)   
  })
  
  output$level <- renderText({
    round(exp(model_ozone()[1]),2)
  })
  
  output$Documentation <- renderUI({
    str1 <- "Hi, welcome to our ozone calculator."
    str2 <- "The Ozone concentration varies depending on wind speed, temperature and solar radiation.
    Aside you can specify those weather element expectations and in the 'Ozone calculator' tab you wil see the ozone concentration
    you might expect under these circumstances."
    str3 <- "Since the solar radiation is not always easily available in public weather forecasts, you can simply specify the month. 
    Our calculator will then first estimate the expected solar radiation given the month and the specified temperature expectation
    and use this solar radiation estimate to calculate the expected ozone concentration."
    str4<- "If you do however know the solar radiation expectations, simply check the checkbox and you will be able to specify the expected
    radiation. The ozone calculator wil then immediately estimate the ozone level with your exact specifications."
    HTML(paste(str1, str2, str3, str4, sep='<br/><br/>'))
  })

  
}
)

