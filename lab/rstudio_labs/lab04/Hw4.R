
library(truncnorm)
library(psych)
library(car)
library(Publish)
library(plotrix)
library(WebPower)

KAPData<-read.csv("../data/KAPJTerm.csv",check.names=FALSE,na.strings = "",sep=",", stringsAsFactors = TRUE)

KAPData$lin4 <- Recode(KAPData$optimism,
                       "'Strongly Disagree'= -3;
                       'Disagree' = -1;
                       'Agree' = 1;
                       'Strongly Agree' = 3",
                       as.factor=FALSE)

KAPData$qua4 <- Recode(KAPData$optimism,
                       "'Strongly Disagree'= 1;
                       'Disagree' = -1;
                       'Agree' = -1;
                       'Strongly Agree' = 1",
                       as.factor=FALSE)

KAPData$cubi4 <- Recode(KAPData$optimism,
                        "'Strongly Disagree'= -1;
                       'Disagree' = 3;
                       'Agree' = -3;
                       'Strongly Agree' = 1",
                        as.factor=FALSE)

summary(lm(statgov_resp~lin4+qua4+cubi4,data=KAPData))

KAPData$optimism <- factor(KAPData$optimism, levels = c("Strongly Disagree", "Disagree",
                                                        "Agree", "Strongly Agree"))
contrasts(KAPData$optimism) <- contr.poly(4)
summary(lm(statgov_resp~optimism, data=KAPData))

# This first line is only necessary if you haven't run the code in any previous questions
KAPData$optimism <- factor(KAPData$optimism, levels = c("Strongly Disagree", "Disagree",
                                                        "Agree", "Strongly Agree"))
# The code from here on is necessary
customContrasts <- matrix(c(-1,-1,1,1,0,0,-1,1,1,-1,0,0),nrow=4,ncol=3,
                          dimnames = list(levels(KAPData$optimism),
                                          c("Any Agreement vs. Any Disagreement",
                                            "Strongly Agree - Agree",
                                            "Strongly Disgree - Disagree")))
customContrasts
contrasts(KAPData$optimism)<-customContrasts
summary(lm(statgov_resp~optimism,data=KAPData))
