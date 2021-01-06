
# Load libraries
library(car)
library(plotrix)
library(Publish)
library(scales)

# Set working directory and read in data
setwd("~/eclipse-Rstuff/Spring2021-TextFiles")

KAPData <- read.csv("KAPJTerm.csv",check.names=FALSE,na.strings = "",stringsAsFactors = TRUE)

str(KAPData, list.len = ncol(KAPData))

# -------------------------------------------------------------

# Example 1

# Fix order of factor levels for optimism
KAPData$optimism <- factor(KAPData$optimism, levels = c("Strongly Disagree", "Disagree",
                                                        "Agree", "Strongly Agree"))

# combine N/A (Nebraska, with non-partisan congress) with Divided category
KAPData$State.Territory.Control[KAPData$State.Territory.Control=="N/A"] <- "Divided"
KAPData$State.Territory.Control <- droplevels(KAPData$State.Territory.Control)

# -----------------------

# Initial plot of perceived severity of infection vs. perceived risk of getting Coronavirus

plot(KAPData$percv_risk, KAPData$percv_sev)

# Try again, with jitter!
plot(jitter(KAPData$percv_risk,2), jitter(KAPData$percv_sev,2))

# Alternatively, with transparency and solid points:
plot(KAPData$percv_risk, KAPData$percv_sev, col=alpha("black",0.01),pch=16)

# Adding labels:
plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
     ylab = "Perceived Severity of Infection",
     main = "Perceived Risk and Severity Across Political Leanings",
     col=alpha("black",0.01),pch=16)

# -----------------------

# Splitting KAPData dataset by Political views
# Let's stick with just Democrats and Republicans, just to keep things simple
splitKAPData <- list(
  "Democrats"=KAPData[KAPData$polit=="Democrat",],
  "Republicans"=KAPData[KAPData$polit=="Republican",]
)

# We can also use the lapply function to do this:
# Democrats are the first level or category, and Republicans are the fourth
levels(KAPData$polit)
splitKAPData <- lapply(levels(KAPData$polit)[c(1,4)], function(x){
  KAPData[KAPData$polit==x,]
})
names(splitKAPData) <- levels(KAPData$polit)[c(1,4)]
str(splitKAPData, max.level = 1)

# Splitting the scores up by the two political parties

plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
     ylab = "Perceived Severity of Infection",
     main = "Perceived Risk and Severity Across Political Leanings", type = "n")

# Adding points
points(jitter(splitKAPData[[1]]$percv_risk,2.5),
       jitter(splitKAPData[[1]]$percv_sev,2.5),col=alpha("blue",0.30),
       pch = 16)

points(jitter(splitKAPData[[2]]$percv_risk,2.5),
       jitter(splitKAPData[[2]]$percv_sev,2.5),col=alpha("red",0.30),
       pch = 17)

# As a for loop:
plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
     ylab = "Perceived Severity of Infection",
     main = "Perceived Risk and Severity Across Political Leanings", type = "n")
colorsUsed <- c("blue","red")
for(i in 1:2){
  points(jitter(splitKAPData[[i]]$percv_risk,2.5), jitter(splitKAPData[[i]]$percv_sev,2.5), 
         col = alpha(colorsUsed[i],0.30), pch = i+15)
}

# Or, with names:
plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
     ylab = "Perceived Severity of Infection",
     main = "Perceived Risk and Severity Across Political Leanings", type = "n")
points(jitter(splitKAPData$Democrats$percv_risk,2.5), 
       jitter(splitKAPData$Democrats$percv_sev,2.5), 
       col = alpha("blue",0.30), pch = 16)
points(jitter(splitKAPData$Republicans$percv_risk,2.5),
       jitter(splitKAPData$Republicans$percv_sev,2.5), 
       col = alpha("red",0.30), pch = 17)

# Directly using KAPData:
plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
     ylab = "Perceived Severity of Infection",
     main = "Perceived Risk and Severity Across Political Leanings", type = "n")
points(jitter(KAPData$percv_risk[KAPData$polit=="Democrat"],2.5),
       jitter(KAPData$percv_sev[KAPData$polit=="Democrat"],2.5),col=alpha("blue",0.30),
       pch = 16)
points(jitter(KAPData$percv_risk[KAPData$polit=="Republican"],2.5),
       jitter(KAPData$percv_sev[KAPData$polit=="Republican"],2.5),col=alpha("red",0.30),
       pch = 17)

# Adding legend in the top left
legend("topleft", legend = c("Democrats","Republicans"),
       pch =16:17,
       col = c("blue","red"))

# -----------------------

# Plotting each set of points separately

# Colorblind friendly colors (from http://colorbrewer2.org):
colPlots <- c("#ca0020","#f4a582", "#bababa", "#404040")

op <- par(mfrow = c(1,2))
# Democrats
plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
     ylab = "Perceived Severity of Infection",
     main = paste("Perceived Risk and Severity For \n","Democrats"), 
     type = "n",
     xlim = c(0,10), ylim = c(0,10),
     xaxt = "n",
     yaxt = "n")
points(jitter(splitKAPData$Democrats$percv_risk,2.5), 
       jitter(splitKAPData$Democrats$percv_sev,2.5), 
       col = alpha("blue",0.30), pch = 16)
axis(side = 1, at = 0:10, c("Not at all likely",rep(NA,9),"Extremely likely"),cex.axis=0.75)
axis(side = 2, at = c(0,10), c("Not at all likely","Extremely likely"),cex.axis=0.75)

# Republicans
plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
     ylab = "Perceived Severity of Infection",
     main = paste("Perceived Risk and Severity For \n","Republicans"), 
     type = "n",
     xlim = c(0,10), ylim = c(0,10),
     xaxt = "n",
     yaxt = "n")
points(jitter(splitKAPData$Republicans$percv_risk,2.5),
       jitter(splitKAPData$Republicans$percv_sev,2.5), 
       col = alpha("red",0.30), pch = 17)
axis(side = 1, at = 0:10, c("Not at all likely",rep(NA,9),"Extremely likely"),cex.axis=0.75)
axis(side = 2, at = c(0,10), c("Not at all likely","Extremely likely"),cex.axis=0.75)
par(op)

# Or, as a for loop:
colorsUsed <- c("blue","red")
op <- par(mfrow = c(1,2))
for(i in 1:length(splitKAPData)){
  plot(KAPData$percv_risk, KAPData$percv_sev, xlab = "Perceived Risk of Infection",
       ylab = "Perceived Severity of Infection",
       main = paste("Perceived Risk and Severity For \n",names(splitKAPData)[i]), 
       type = "n",
       xlim = c(0,10), ylim = c(0,10),
       xaxt = "n",
       yaxt = "n")
  points(jitter(splitKAPData[[i]]$percv_risk,2.5),
         jitter(splitKAPData[[i]]$percv_sev,2.5), 
         col = alpha(colorsUsed[i],0.30), pch = 15+i)
  axis(side = 1, at = 0:10, c("Not at all likely",rep(NA,9),"Extremely likely"),cex.axis=0.75)
  axis(side = 2, at = c(0,10), c("Not at all likely","Extremely likely"),cex.axis=0.75)
}
par(op)

# -----------------------

# Plotting histograms

hist(KAPData$percv_sev, xlab = "Perceived Severity of Infection",
     main = "Frequencies of Perceived Severity Scores")

# Adding colors
hist(KAPData$percv_sev, xlab = "Perceived Severity of Infection",
     main = "Frequencies of Perceived Severity Scores", col = "grey")

# Adding breaks
hist(KAPData$percv_sev, xlab = "Perceived Severity of Infection",
     main = "Frequencies of Perceived Severity Scores", col = "grey",
     breaks = seq(0,10,2))

# -----------------------

# Plotting boxplots
boxplot(KAPData[,c("percv_sev","percv_risk","statgov_resp")])

boxplot(KAPData$percv_sev~KAPData$polit)
boxplot(percv_sev~polit, data = KAPData)

boxplot(percv_risk~polit, data = KAPData)

# -----------------------

# Relationships across variables

pairs(KAPData[,c("percv_sev","percv_risk","statgov_resp")])
pairs(sapply(KAPData[,c("percv_sev","percv_risk","statgov_resp")],jitter,2))

# -------------------------------------------------------------

# Example 2
# Initial plot of satisfaction of state government's response state vs. optimism that the
# pandemic will end in 3 months
# Note that the study was conducted in March 2020, so this assumes that participants were
# optimistic of the pandemic ending by June 2020!

# Group means and cell means
optimismMeans <- tapply(KAPData$statgov_resp, KAPData$optimism, mean)
politMeans <- tapply(KAPData$statgov_resp, KAPData$polit, mean)
cellMeanMatrix <- tapply(KAPData$statgov_resp, list(KAPData$optimism, KAPData$polit), mean)

# Standard error (std.error in plotrix package) and 95% (ci.mean in Publish package) confidence intervals
cellSEMatrix <- tapply(KAPData$statgov_resp, list(KAPData$optimism, KAPData$polit), std.error)
cellCILowerMatrix <- tapply(KAPData$statgov_resp, list(KAPData$optimism, KAPData$polit),
                            function(x){ci.mean(x)$lower})
cellCIUpperMatrix <- tapply(KAPData$statgov_resp, list(KAPData$optimism, KAPData$polit),
                            function(x){ci.mean(x)$upper})

# We can also use the aggregate function to get cell means, etc. in long format:
aggregate(statgov_resp~optimism*polit, KAPData, mean)
aggregate(statgov_resp~optimism*polit, KAPData, std.error)

# -----------------------

# Barplots

# Optimism
barplot(optimismMeans,beside=TRUE,col=c("orange","purple", "green", "goldenrod4"),
        ylim=c(0,8))

# Political Views
# Colorblind friendly colors (from http://colorbrewer2.org):
colPlots <- c("#ca0020","#f4a582", "#bababa", "#404040")
barplot(politMeans,beside=TRUE,col=colPlots,
        ylim=c(0,15))

# Cell Means
barplot(cellMeanMatrix,beside=TRUE,col=c("orange","purple", "green", "goldenrod4"),
        legend.text = rownames(cellMeanMatrix),args.legend=list(x="top"),
        ylim=c(0,15))

# Adding confidence intervals

# 2*SE bars
ciLocations <- barplot(cellMeanMatrix,beside=TRUE,col=c("orange","purple", "green", "goldenrod4"),
                       legend.text = rownames(cellMeanMatrix),args.legend=list(x="top"),
                       ylim=c(floor(min(cellMeanMatrix-2*cellSEMatrix))-1, ceiling(max(cellMeanMatrix+2*cellSEMatrix))+1))

arrows(x0=ciLocations,y0=cellMeanMatrix-2*cellSEMatrix,x1=ciLocations,y1=cellMeanMatrix+2*cellSEMatrix,
       length=.1,angle=90,code=3)

# 95% bars
ciLocations <- barplot(cellMeanMatrix,beside=TRUE,col=c("orange","purple", "green", "goldenrod4"),
                       legend.text = rownames(cellMeanMatrix),args.legend=list(x="top"),
                       ylim=c(floor(min(cellCILowerMatrix))-1, ceiling(max(cellCIUpperMatrix))+1))

arrows(x0=ciLocations,y0=cellCILowerMatrix,x1=ciLocations,y1=cellCIUpperMatrix,
       length=.1,angle=90,code=3)

#------------------------------------------------------------

# Example 3

# Let's use what we've learned to try plotting cell means to see if there's
# an interaction:

# Edited from http://stackoverflow.com/questions/34671337/r-plotting-factor-with-values-on-y-axis
# and https://www.r-bloggers.com/interaction-plot-from-cell-means/

# Plotting factor B on the x axis
f <- as.factor(c("B1", "B2"))
# xaxt = "n" just stops the default ticks of the x-axis from being plotted
plot(f,c(6,20),type="n",xaxt = "n",xlab="Factor B",ylab="DV",ylim=c(7.5, 18.5))
lines(f,c(10,8),col="blue")
lines(f,c(12,18),col="red",lty=3)
points(f,c(10,8),col="blue")
points(f,c(12,18),col="red")
axis(1, 1:2, levels(f))
legend("topleft",legend=c("A1","A2"),col=c("blue","red"),lty=c(1,3))

# Plotting Factor B on the y axis
f <- as.factor(c("B1", "B2"))
# yaxt = "n" just stops the default ticks of the y-axis from being plotted
plot(c(6,20),f,type="n",yaxt = "n",xlab="DV",ylab="Factor B",xlim=c(7.5,18.5))
lines(c(10,8),f,col="blue")
lines(c(12,18),f,col="red",lty=3)
points(c(10,8),f,col="blue")
points(c(12,18),f,col="red")
axis(2, 1:2, levels(f))
legend("bottomright",legend=c("A1","A2"),col=c("blue","red"),lty=c(1,3))

# How would we plot Factor A on the x or y axis?