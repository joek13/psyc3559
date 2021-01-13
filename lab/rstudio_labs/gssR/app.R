# William Meyer
# Working with GSS data from my intro to data science class with Prof. Kropko
# GSS codebook and documentation avalible here: https://gss.norc.org/documents/codebook/gss_codebook.pdf

# packages and libraries 
library(shiny)
library(shinyWidgets)
library(lattice)
library(scatterplot3d) 
library(colourpicker)

# First setwd
# Read in CSV from web
gss <- read.csv("https://github.com/jkropko/DS-6001/raw/master/localdata/gss2018.csv")
summary(gss)

# We are going to make a 3D shiny app with three continuous  
# I would assume they highly correlated as well. 
# These variables are:
# coninc - annual income 
gss$coninc
# mapres10 -the respondent's mother's occupational prestige score, as measured by the GSS
gss$mapres10
# papres10 - the respondent's father's occupational prestige score, as measured by the GSS
gss$papres10

# Often the variables have missing information
# For simplicity, I am removing them blindly 
gss_droped <- subset(gss, coninc!="IAP") 
gss_droped <- subset(gss_droped, mapres10!="IAP,DK,NA,uncodeable")
gss_droped<-subset(gss_droped, papres10!="IAP,DK,NA,uncodeable")
gss_droped$coninc <- as.numeric(gss_droped$coninc)
gss_droped$mapres10 <- as.numeric(gss_droped$mapres10)
gss_droped$papres10 <- as.numeric(gss_droped$papres10)



# the code for this shiny app was written by Prof. Schmidt at UVA. I'm just changing the data
# Thanks Prof. Schmidt! 
ui<-fluidPage(
  
  setBackgroundColor("LightGrey"),
  
  
  titlePanel("Visualizing annual income with occupational prestige of parents"),
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
    cloud(coninc ~ mapres10 + papres10, data=gss_droped,
          main="Income and parent prestige",
          col=input$col,
          pch=input$plotCh,
          cex=input$cexsize,
          xlim=c(0,80),
          ylim=c(0,80),
          zlim=c(0,200000),
          xlab="Mother's occupational prestige",                                                                              
          ylab="Father's occupational prestige",
          zlab="Annual icome",
          screen=list(z=input$zOrient,x=input$xOrient,y=input$yOrient),
          las=0)
    
    
  })
  
}


shinyApp(ui=ui, server=server)




