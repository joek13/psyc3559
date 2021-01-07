#
# Lab Day 3: Regression and Multiple Regression; Effect Size, Power, and Missingness
#
# January 6th, 2021
#
# Karen and Cynthia 
#
# KAP data
#

KAPData<-read.csv("../data/KAPJTerm.csv",check.names=FALSE,na.strings = "",sep=",", stringsAsFactors = TRUE)


cols = c("knowSum", "anxSum")
KAPData$optimism <- ordered(KAPData$optimism, levels=c("Strongly Disagree", "Disagree", "Agree", "Strongly Agree"))
model <- lm(percv_risk ~ as.numeric(optimism), data=KAPData)
summary(model)

head(KAPData)
tail(KAPData)
str(KAPData)

#install.packages("psych")
library(psych)
library(car)
#describe(KAPData, na.rm=TRUE)
summary(KAPData, na.rm=TRUE)


#Check structure of data
str(KAPData, list.len = ncol(KAPData))

# Let's set up some multiple regression models.  We will expand from lecture, and attempt 3 predictors here...
#
# Model Set 1: 
# Y-pred = What is the perceived severity of COVID?
# X1 = What is the perceived risk of infection?
# X2 = Sum of all anxiety questions from the PHQ 
# X3 = Are you eligible to vote in local, state, or federal 2020 election?


# Correlations 
# Correlations with the Criterion or Outcome, Y:
cor(KAPData$percv_sev, KAPData$percv_risk,   method = "spearman", use = "complete.obs")
cor(KAPData$percv_sev, KAPData$anxSum,   method = "spearman", use = "complete.obs")
cor(KAPData$percv_sev,KAPData$voteNum,   method = "spearman", use = "complete.obs")

# Correlations with each of the X Predictors:
cor(KAPData$anxSum,KAPData$voteNum,   method = "spearman", use = "complete.obs")
cor(KAPData$anxSum, KAPData$percv_risk,   method = "spearman", use = "complete.obs")
cor(KAPData$voteNum, KAPData$percv_risk,   method = "spearman", use = "complete.obs")

#Hmmmm; some of these are not very correlated : )

# Bivariate regressions first:
# Let's start with Perceived risk of infection:

Risk1<-(lm(percv_sev ~ percv_risk, data=KAPData))
summary(Risk1)
AIC(Risk1) # Not interpretable for a single model; we are simply obtaining the estimate
BIC(Risk1) # Not interpretable for a single model; we are simply obtaining the estimate

#How does Risk1 look?

# Next, let's look at Anxiety:

Anxiety1<-(lm(percv_sev ~ anxSum, data=KAPData))
summary(Anxiety1)
AIC(Anxiety1) # Not interpretable for a single model; we are simply obtaining the estimate
BIC(Anxiety1) # Not interpretable for a single model; we are simply obtaining the estimate

# How does Anxiety1 look?

# Finally, Voting

Vote1<-(lm(percv_sev ~ voteNum, data=KAPData))
summary(Vote1)
AIC(Vote1) # Not interpretable for a single model; we are simply obtaining the estimate
BIC(Vote1) # Not interpretable for a single model; we are simply obtaining the estimate

# And, how about Vote1 ??

# Interestingly, sometimes a predictor is not statistically significant in one model, but in
# another model (i.e., in this case, a multiple regression model), it may become stat sig...stay tuned!


# Now multiple regressions...In this lab, we have decided to start with Perceived Risk of infection, and then add in Anxiety:

RiskAnx12<-(lm(percv_sev ~ percv_risk + anxSum, data=KAPData))
summary(RiskAnx12)
AIC(RiskAnx12) # Not interpretable for a single model; we are simply obtaining the estimate
BIC(RiskAnx12) # Not interpretable for a single model; we are simply obtaining the estimate

# How does RiskAnx12 look?

# We can check to see if it is better fit than our base model, Risk1:

AIC(RiskAnx12,Risk1) # Models are not fitted to same N; we are doing this simply for illustration
BIC(RiskAnx12,Risk1) # Models are not fitted to same N; we are doing this simply for illustration

  # Delta R-squared
anova(RiskAnx12,Risk1) #Since these two have different Ns, we will wait for another example

# Now, we will add in Voting

RiskAnxVote123<-(lm(percv_sev ~ percv_risk + anxSum + voteNum, data=KAPData))
summary(RiskAnxVote123)
AIC(RiskAnxVote123) #single model; not interpretable
BIC(RiskAnxVote123) #single model; not interpretable


# We can check to see if it is better fit than our RiskAnx12 model:

AIC(RiskAnx12,RiskAnxVote123) # Models are not fitted to same N; we are doing this simply for illustration
BIC(RiskAnx12,RiskAnxVote123) # Models are not fitted to same N; we are doing this simply for illustration

# (For Practice, given unequal N) Conclusion: AIC and BIC are lower for the Full model; however, we have not 
# gained anything by adding in Vote;  Vote is not a significant predictor, statistically. 


##################################################################################################
#
# 
# Model Set 2: We will swap out voteNum to threatSum
# Model Set 2: 
# Y-pred = What is the perceived severity of COVID?
# X1 = What is the perceived risk of infection?
# X2 = Sum of all anxiety questions from the PHQ 
# X3 = The coronavirus is a threat to my: Sum of threat_secur, threat_econ, threat_pers (personal finances)


# Correlations; only the new ones are uncommented...

# Correlations with the Criterion or Outcome, Y:
#cor(KAPData$percv_sev, KAPData$percv_risk,   method = "spearman", use = "complete.obs")
#cor(KAPData$percv_sev, KAPData$anxSum,   method = "spearman", use = "complete.obs")
cor(KAPData$percv_sev,KAPData$threatSum,   method = "spearman", use = "complete.obs")

# Correlations with each of the X Predictors:
cor(KAPData$anxSum,KAPData$threatSum,   method = "spearman", use = "complete.obs")
#cor(KAPData$anxSum, KAPData$percv_risk,   method = "spearman", use = "complete.obs")
cor(KAPData$threatSum, KAPData$percv_risk,   method = "spearman", use = "complete.obs")


#Risk1  --- run in Model Set 1
#Anx1--- run in Model Set 1

# Finally, the swapped 3rd variable: threatSum

Threat1<-(lm(percv_sev ~ threatSum, data=KAPData))
summary(Threat1)
AIC(Threat1) # single model. Just getting the index
BIC(Threat1) # single model. Just getting the index

# And, how about Threat1 ??

# Now, the multiple regressions...In this lab, we have decided to start with Perceived Risk of infection, and then add in Anxiety:
# RiskAnx12 -- already run, above

# For the full model, we add in threatSum
# 

RiskAnxThreat123<-(lm(percv_sev ~ percv_risk + anxSum + threatSum, data=KAPData))
summary(RiskAnxThreat123)
AIC(RiskAnxThreat123) # single model; just getting index
BIC(RiskAnxThreat123) # single model; just getting index


# We can check to see if it is better fit than our RiskAnx12 model:

AIC(RiskAnx12,RiskAnxThreat123) # No issues here! equal N! No warnings : )
BIC(RiskAnx12,RiskAnxThreat123) # # No issues here! equal N! No warnings : )

# Conclusion: AIC and BIC are lower for the Full model; all three predictors are 
# statistically significant predictors.  

#Now, we can test both full models against each other:
AIC(RiskAnxVote123,RiskAnxThreat123) # again; unequal N; shown here just for illustrating the process
BIC(RiskAnxVote123,RiskAnxThreat123) # again; unequal N; shown here just for illustrating the process

# Conclusion: Wow! These models do not differ from each other according to AIC and BIC...why do you think that's so?

#################################################################################################
##################################################################################################

# for Collab Day 3 Worksheet
RiskAnxEdu123 <-lm(percv_sev ~ percv_risk + anxSum + eduNum,  data = KAPData) 
summary(RiskAnxEdu123)

##################################################################################################
##################################################################################################


# POWER ANALYSIS for REGRESSION


library(WebPower)

# we use wp.regression() function. Check out this function ?wp.regression.

# Based on the model, we believe that percv_risk, anxSum, and voteNum can explain 16.12% (R-squared)
# of variance of percv_sev. 

RiskAnxVote123<-lm(percv_sev ~ percv_risk + anxSum + voteNum, data=KAPData)
summary(RiskAnxVote123)

# We have a sample size of 5485 

nrow(KAPData)

#(In fact, the sample size is 5485-455=5030 because of the missing values. 
# We ignore missing values for now).
# This is how we get the number 455.
# length(unique(c(which(is.na(KAPData$percv_risk)),which(is.na(KAPData$anxSum)),which(is.na(KAPData$voteNum)))))


# Given the sample size 5485, what is the statistical power to find significant relationship
# between percv_sev and {percv_risk, anxSum, and voteNum}?

# we need to calculate f2: f2=R2/(1-R2)
f2 <- 0.1612/(1-0.1612)
wp.regression(n=5485, p1=3, f2=0.1921793)

#wow! A power of 1!

# Now, let's consider the effect of voteNum only! what is the statistical power to find 
# significant relationship between percv_sev and voteNum in Model RiskAnxVote123?
# The reduced model is RiskAnxVote12.

RiskAnx12<-lm(percv_sev ~ percv_risk + anxSum, data=KAPData)
summary(RiskAnx12)

# R2 for the reduced model is bigger than that for the full model??! What is the problem?!!

sum(is.na(KAPData$percv_risk))
sum(is.na(KAPData$anxSum))
sum(is.na(KAPData$voteNum))

# It is because of missing values!!
# Let's make the two models more comparable by deleting participants whose VoteNum scores are missing

RiskAnx12.mis<-lm(percv_sev ~ percv_risk + anxSum, data=KAPData[-which(is.na(KAPData$voteNum)),])
summary(RiskAnx12.mis)

# R2 for the reduced model RiskAnx12.mis is 0.161. We calculate f2.
# f2=(R2_full-R2_reduced)/(1-R2_full)
f2 <- (0.1612-0.161)/(1-0.1612)

## effect size so small!

wp.regression(n=5485, p1=3, p2=2, f2=0.0002384359, alpha=0.05)

# Q: is the power of a single variable (by taking the reduced model subtrcation) just the probability that, if that variable is significant, we'll pick up on it??
# power = 0.21

# In order to get a power of 0.8, what is the required sample size?
wp.regression(n=NULL, p1=3, p2=2, f2=0.0002384359, alpha=0.05, power=0.8)

# To generate a power curve given a sequence of sample sizes:
res <- wp.regression(n = seq(5000,40000,5000), p1 = 3, p2=2, f2=0.0002384359, alpha = 0.05, power = NULL)
res
plot(res) 


#################################################################################################
##################################################################################################

# for Collab Day 3 Worksheet
RiskAnxThreat123<-lm(percv_sev ~ percv_risk + anxSum + threatSum, data=KAPData)
summary(RiskAnxThreat123)

#Given the sample size 5485, what is the statistical power to find significant relationship
# between percv_sev and {percv_risk, anxSum, and threatSum}?

# effect size f2
f2 <- ...

wp.regression(n=5485, p1=3, f2=...)

# consider the effect of threatSum only! what is the statistical power to find 
# significant relationship between percv_sev and threatSum in Model RiskAnxThreat123?

# there is no missing value in the threatSum variable.
RiskAnx12<-lm(percv_sev ~ percv_risk + anxSum, data=KAPData)
summary(RiskAnx12)

# Now, What is the effect size f2?
f2 <- ...

# power=?
wp.regression(n=5485, p1=3, p2=2, f2=..., alpha=0.05)


# In order to get a power of 0.8, what is the required sample size?
wp.regression(n=NULL, p1=3, p2=2, f2=..., alpha=0.05, power=0.8)


##################################################################################################
##################################################################################################