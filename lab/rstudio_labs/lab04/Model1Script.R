# R Script for Model 1 Plots


library(truncnorm)
library(psych)
library(car)
library(Publish)
library(plotrix)
library(WebPower)
library(ggplot2)
library(dplyr)
library("ggpubr")

KAPData<-read.csv("../data/KAPJTerm.csv",check.names=FALSE,na.strings = "",sep=",", stringsAsFactors = TRUE)

###############################

# DV: anxSum
# anxSum
#  Cumulative PHQ-4 (anx_1 - anx_4) score
#  Scale: 0 to 12
#  Can be analyzed as:
#   1. continuous
#   2. with a cut-off of 6 for symptoms consistent with depression & anxiety
#   3. dichotomous (no symptoms; any symptoms) and within this dichotomous var by number of symptoms
#  Sources: Jalloh MF, Li W, Bunnell RE, et al. Impact of Ebola experiences and risk perceptions on mental health in Sierra Leone, July 2015. BMJ Global Health.

# IVs:
#
# behav_3
#  Started working from home.
#  False=0; True=1
# belief_3
#  I can financially afford to self-quarantine.
#  Strongly Agree=3; Agree=2; Disagree=1; Strongly Disagree=0
# child
#  Do children under 18 year old live in your household?
#  No=0; 1=Yes

##########################

# ggplot goodies

center <- theme(plot.title = element_text(hjust = 0.5))

# compile into reduced dataset.

model1Data <- KAPData[,c("behav_3", "belief_3", "child", "anxSum")]
colnames(model1Data)[1] <- "workFromHome"
colnames(model1Data)[2] <- "affordQuarantine"
# child has an acceptable name!
colnames(model1Data)[4] <- "anxiety"

model1Data$depressed <- recode(as.factor(model1Data$anxiety >= 6), "FALSE"="Not depressed", "TRUE"="Depressed")
model1Data$anxietyFact <- as.factor(model1Data$anxiety)


# anxiety histogram
d <- ggplot(model1Data[!is.na(model1Data$anxiety), ], aes(x=anxiety, fill=as.integer(anxietyFact), group=anxietyFact)) + center
d + geom_bar() + ggtitle("Distribution of Respondents'\nPHQ-4 Anxiety Scores") + labs(x="PHQ-4 Anxiety Score", y="Number of respondents") + scale_fill_gradient2(name="anxietyFact", low="#e0f3db", mid="#a8ddb5", high="#1382ca") + theme(legend.position = "none")

d <- ggplot(model1Data[!is.na(model1Data$anxiety), ], aes(y=anxiety)) + center
d + geom_boxplot()



# affordQuarantine barplot 
# reorder the factor 
  
model1Data$affordQuarantine<-factor(model1Data$affordQuarantine, levels=c("Strongly Disagree", "Disagree", "Agree", "Strongly Agree"))

d <- ggplot(model1Data[!is.na(model1Data$affordQuarantine),], aes(x=affordQuarantine)) + center

d + geom_bar(fill="#2c7fb8") + scale_y_continuous(limits=c(0,2000)) + labs(x="", y="Number of responses", title="Responses to \"I can financially afford to self-quarantine.\"")

# work from home barplot
d <- ggplot(model1Data[!is.na(model1Data$workFromHome),], aes(x=workFromHome)) + center
d + geom_bar(fill="#2c7fb8", aes(label="stat(count)")) + scale_x_discrete(labels=c("No", "Yes")) + scale_y_continuous(limits=c(0,4000)) + labs(x="", y="Number of responses") + ggtitle("Responses to \"Do you work from home?\"")

# children barplot

d <- ggplot(model1Data[!is.na(model1Data$child),], aes(x=child)) + center
d + geom_bar(fill="#2c7fb8") + scale_x_discrete(labels=c("No", "Yes")) + scale_y_continuous(limits=c(0,4000)) + labs(x="", y="Number of responses") + ggtitle("Responses to \"Do children under 18 years old\nlive in your household?\"")

## IV Relationships

likert_colors = c("Strongly Disagree"="#de2d26", "Disagree"="#fc9272", "Agree"="#addd8e", "Strongly Agree"="#31a354")
yesno_colors = c("FALSE"="#de2d26", "No"="#de2d26", "TRUE"="#31a354", "Yes"="#31a354")

# Work from Home vs. Isolation Affordability

d <- ggplot(model1Data[!is.na(model1Data$workFromHome) & !is.na(model1Data$affordQuarantine),], aes(x=workFromHome, fill=affordQuarantine)) + center
d + geom_bar() + labs(x="Do you work from home?", y = "Number of responses", fill="I can afford to self-isolate.") + scale_x_discrete(labels=c("No", "Yes")) + theme(legend.position = "right") + scale_fill_manual(values = likert_colors) + ggtitle("Work from Home vs. Affordablity of Self-Isolation")

d <- ggplot(model1Data[!is.na(model1Data$workFromHome) & !is.na(model1Data$affordQuarantine),], aes(x=affordQuarantine, fill=workFromHome)) + center
d + geom_bar() + labs(x="\"I can afford to self-isolate.\"", y="Number of responses", fill="Do you work from home?") + ggtitle("Affordability of Self-Isolation vs. Work From Home") + scale_fill_manual(values = yesno_colors, labels=c("No", "Yes"))

# WfH and Children
d <- ggplot(model1Data[!is.na(model1Data$workFromHome) & !is.na(model1Data$child),], aes(x=workFromHome, fill=child)) + center
d + geom_bar() + labs(x="Do you work from home?", y = "Number of responses", fill="Do children under 18\nlive in your household?") + ggtitle("Work From Home vs. Children") + scale_fill_manual(values = yesno_colors, labels=c("No", "Yes"))

d <- ggplot(model1Data[!is.na(model1Data$workFromHome) & !is.na(model1Data$child),], aes(x=child, fill=workFromHome)) + center
d + geom_bar() + labs(x="Do children under 18 live in your household?", y = "Number of responses", fill="Do you work from home?") + ggtitle("Children vs. Work From Home") + scale_fill_manual(values = yesno_colors, labels=c("No", "Yes"))

# Affordability and Children
d <- ggplot(model1Data[!is.na(model1Data$affordQuarantine) & !is.na(model1Data$child),], aes(x=child, fill=affordQuarantine)) + center
d + geom_bar() + labs(x="Do children under 18 live in your household?", y = "Number of responses", fill = "I can afford to self-isolate.") + scale_fill_manual(values=likert_colors) + ggtitle("Children vs. Affordability of Self-Isolation")

# Children and Affordability
d <- ggplot(model1Data[!is.na(model1Data$workFromHome) & !is.na(model1Data$child),], aes(x=affordQuarantine, fill=child)) + center
d + geom_bar() + labs(x="\"I can afford to self-isolate.\"", y="Number of responses", fill="Do children under 18\nlive in your household?") + ggtitle("Affordability of Self-Isolation vs. Children") + scale_fill_manual(values = yesno_colors, labels=c("No", "Yes"))

# DV plots
d <- ggplot(model1Data[!is.na(model1Data$workFromHome) & !is.na(model1Data$anxiety),], aes(x=workFromHome, y=anxiety)) + center
box1 <- d + geom_boxplot(fill="#1382ca") + labs(x="Do you work from home?", y="PHQ-4 Anxiety Score") + scale_x_discrete(labels=c("No", "Yes")) + ggtitle("Work From Home vs. PHQ-4 Anxiety Score")

d <- ggplot(model1Data[!is.na(model1Data$affordQuarantine) & !is.na(model1Data$anxiety),], aes(x=affordQuarantine, y=anxiety)) + center
box2 <- d + geom_boxplot(fill="#1382ca") + labs(x="\"I can afford to self-isolate.\"", y="PHQ-4 Anxiety Score") + ggtitle("Affordability of Self-Isolation vs. PHQ-4 Anxiety Score")

d <- ggplot(model1Data[!is.na(model1Data$child) & !is.na(model1Data$anxiety),], aes(x=child, y=anxiety)) + center
box3 <- d + geom_boxplot(fill="#1382ca") + labs(x="Do you have children?", y="PHQ-4 Anxiety Score") + ggtitle("Children vs. PHQ-4 Anxiety Score")


ggarrange(box1, box2, box3, ncol=3)

