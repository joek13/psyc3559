# Choosing Good xlim and ylim values when creating scatterplots with Iris Data#
# Karen M. Schmidt

#install.packages("shiny")
#install.packages("shinyWidgets")
library(shiny)
library(shinyWidgets)
data("iris")

#setwd("C:/Users/kmm4f/Desktop/JTerm 2021 Proposed Courses/Shiny Scatterplot Iris")
ui<-fluidPage(
  
  setBackgroundColor("LightYellow"),
  
  
  titlePanel("Choosing Good xlim and ylim Values for the Iris Data"),
  
 column(4, wellPanel(
    sliderInput("xlim", "X Axis Min and Max",
                min = 1, max = 10, value = c(1,10), step = 1)
 )),
 
 column(4, wellPanel(
     sliderInput("ylim", "Y Axis Min and Max",
                   min = 0, max = 4, value = c(0,4), step = 1)
 )),
     

mainPanel(
  plotOutput("scatterPlot"))
)

server<-function(input, output) {
    output$scatterPlot <-renderPlot({ 
      plot(iris$Petal.Length, iris$Petal.Width, xlim=c(input$xlim[1], input$xlim[2]), 
           ylim=c(input$ylim[1], input$ylim[2]), xlab="Iris Petal Length (cm)", ylab="Iris Petal Width (cm)", 
           pch=19, col="purple", main="Iris Dataset")                                              
          })
}
  
shinyApp(ui=ui, server=server)

