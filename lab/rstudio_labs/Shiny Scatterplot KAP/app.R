# Choosing Good xlim and ylim values when creating scatterplots; this one is KAP#
# Karen M. Schmidt

#install.packages("shiny")
#install.packages("shinyWidgets")
library(shiny)
library(shinyWidgets)

current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

KAP<-read.csv("KAPdataReduced.csv")

#getwd()
ui<-fluidPage(
  
  setBackgroundColor("LightGrey"),
  
  
  titlePanel("COVID Knowledge and Anxiety"),
  
 column(4, wellPanel(
    sliderInput("xlim", "X Axis Min and Max",
                min = -2, max = 15, value = c(0,13), step = 1)
 )),
 
 column(4, wellPanel(
     sliderInput("ylim", "Y Axis Min and Max",
                   min = -2, max = 15, value = c(0,10), step = 1)
 )),
     

mainPanel(
  plotOutput("scatterPlot"))
)

server<-function(input, output) {
    output$scatterPlot <-renderPlot({ 
      plot(jitter(KAP$knowSum, 3), jitter(KAP$anxSum, 3),  xlim=c(input$xlim[1], input$xlim[2]), 
           ylim=c(input$ylim[1], input$ylim[2]), xlab="Knowledge about COVID", ylab="Anxiety", 
           pch=19, col=rgb(0.75,0,0.75,1), main="Knowledge about COVID & Anxiety")                                             
          })
}
  


shinyApp(ui=ui, server=server)

