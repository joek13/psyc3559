# Load libraries
library(car)
library(plotrix)
library(Publish)
library(scales)

KAPData <- read.csv("../data/KAPJTerm.csv", stringsAsFactors = TRUE)

KAPData$polit

politicalSplit = list(
  democrat = KAPData[KAPData$polit == "Democrat",],
  republican = KAPData[KAPData$polit == "Republican",]
)


boxplot(KAPData[,c("percv_sev", "percv_risk", "statgov_resp")])
median(KAPData$statgov_resp, na.rm = TRUE)

dissatisfied <- KAPData[KAPData$statgov_resp <= 5]