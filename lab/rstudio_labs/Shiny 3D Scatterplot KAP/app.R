######################################################################################
### 3D Plot Using scatterplot3d and KAP Data
###
### Shiny App by Karen M. Schmidt   
###

#install.packages("shiny")
#install.packages("shinyWidgets")
library(shiny)
library(shinyWidgets)

#Installing packages#
#install.packages("lattice")
library(lattice)
#install.packages("scatterplot3d")
library(scatterplot3d) 
#install.packages("colourpicker")
library(colourpicker)

summary(KAP$age)
summary(KAP$percv_risk)
summary(KAP$percv_sev)

current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

KAP<-read.csv("KAPdataReduced.csv", header = TRUE)


ui<-fluidPage(
  
  setBackgroundColor("LightGrey"),
  
  
  titlePanel("Perceived Threat & COVID Knowledge vs. Predicted Behaviors"),
    sidebarLayout(
     sidebarPanel(
      sliderInput("zOrient", "Z Axis Orientation", 
                min = 0, max = 400, value = 200, step = 1
  ),
      sliderInput("xOrient", "X Axis Orientation",
                min = 0, max = 400, value = 284, step = 1
  ),
  
       sliderInput("yOrient", "Y Axis Orientation",
                  min = 0, max = 400, value = 0, step = 1
  ),
  
       sliderInput("plotCh", "Plot Character Type",
                  min = 1, max = 25, value = 1, step = 1
  ),
  
       sliderInput("cexsize", "Plot Character Size",
            min = 0, max = 3, value = 1.5, step = .25
  ),

       colourInput("col", "Select Plot Character Color", value = "red", 
                allowTransparent = TRUE
  )  
  ),
  mainPanel(
    plotOutput("scatterPlot"))
)
)

server<-function(input, output) {
  output$scatterPlot <-renderPlot({
    cloud(KAP$behavSum ~ KAP$threatSum + KAP$knowSum, data=data,
          main="Predicted Protective Behavior",
          col=input$col,
          pch=input$plotCh,
          cex=input$cexsize,
          xlim=c(0, 9),
          ylim=c(0, 13),
          zlim=c(0, 12),
          xlab="Perceived Threat",                                                                              
          ylab="COVID Knowledge",
          zlab="Protective\nBehavior",
          screen=list(z=input$zOrient,x=input$xOrient,y=input$yOrient),
          las=0)
  
    
  })
  
}


shinyApp(ui=ui, server=server)




