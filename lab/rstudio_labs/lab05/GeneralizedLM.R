#
# Generalized linear models
#
# Author: M. Joseph Meyer
###############################################################################

# loading in packages

library(car)
library(psych)
library(MASS)
library(AER)
library(nnet)
library(effects)

#-------------------------------------------------

# Reading in and cleaning dataset

# initial dataset
KAPData <- read.csv("../data/KAPJTerm.csv",check.names=FALSE,na.strings = "",stringsAsFactors = TRUE)
str(KAPData, list.len = ncol(KAPData))

# Recoding levels
KAPData$optimism <- factor(KAPData$optimism, levels = c("Strongly Disagree", "Disagree",
                                                        "Agree", "Strongly Agree"))

KAPData$polit <- Recode(KAPData$polit,
                        "'Other' = 'Other/Prefer not to say';
                         'Prefer not to say' = 'Other/Prefer not to say'",
                        as.factor=TRUE,
                        levels=c("Other/Prefer not to say","Democrat","Republican"))

KAPData$drinkMoreNum <- Recode(KAPData$drink,
                               "'Little more' = 1;
                         'Much more' = 1;
                        else = 0",
                               as.factor=FALSE,
                               as.numeric=TRUE)

#-------------------------------------------------

# Binary logistic regression

# Can we use participants' anxiety levels to predict whether they started drinking more?

#------------------

# We know that the proportion data is bounded, and the original data containing
# responses is binary, so it is unlikely that we can just do a general linear model
# on this data!  So, what can we do?

# Enter probit and logit: both of these are 'link functions' that
# transform our binary/proportion data into something roughly linear. The
# 'link function' refers to the fact that we aren't estimating parameters
# on the response variable (e.g. the mean) directly.
# The probit transform itself simply takes the raw proportion values
# and turns them into Z-scores (i.e. standard deviation units). Note
# we usually add an arbitrarily small number (epsilon) to account for
# the fact that a true zero probability is unlikely.

#------------------

# Let's try a logit model.

summary(glm(drinkMoreNum ~ anxSum, family = binomial(link="logit"), data = KAPData))

# Logit is the default, so we can leave this out of the binomial function
summary(glm(drinkMoreNum ~ anxSum, family = binomial(), data = KAPData))

# At a anxiety level of 0, the log-odds of drinking more is -2.41, and for every unit of anxiety, the log-odds of drinking more
# increases by 0.09. (that is, for every unit increase in anxiety, participants are exp(0.09) = 1.09 times more likely that the
# participant will drink more). When participants are not anxious (anxSum = 0), the odds of drinking more are exp(-2.41471) = 0.0894,
# and the probability of drinking more is 0.0894/(1+0.0894) = 8.21%. When participants have the maximum amount of reported anxiety
# (anxSum = 12), the odds of drinking more are exp(-2.41471 + 0.09097*12) = 0.2663, and the probability of drinking more is 21.03%.

#------------------

# Note that exp(yhat) = exp(b0 + b1*x) does not equal exp(b0) + exp(b1)*x.  However, due to the definition of exponents,
# exp(yhat) = exp(b0 + b1*x) = exp(b0)*exp(b1*x).  Therefore, an increase of slope*(increase in x) for yhat is equal to
# multiplying exp(yhat) by exp(slope*(increase in x)).

# In other words, our log-odds equation of -2.41471 + 0.09097*anxSum can be written in terms of odds: 0.0894*1.0942^anxSum.

# We can thus calculate the above odds as
# anxSum = 0: odds = 0.0894*1.0942^0 = 0.0894
# anxSum = 12: odds = 0.0894*1.0942^12 = 0.2663 (give or take some round-off errors)

# This also means that our slope, when using odds or probabilities, isn't linear!

# log odds:
# Y' = -2.41 + 0.091 * anxSum

# odds:
# Y' = exp(-2.41) * exp(0.091 * anxSum) = exp(-2.41) * exp(0.091) ^ anxSum

#------------------

# Visualizing our data:

# We can use the effects package to plot our results

ModelLogit.ef <- allEffects(glm(drinkMoreNum ~ anxSum, family = binomial(), data = KAPData))
plot(ModelLogit.ef)
#plotted on logistic scale, so distance from 0.25 to 0.30 is not the same as the distance from 0.45 to 0.5

#-------------------------------------------------

# Ordered logistic regression

# Can we use participants' anxiety levels to predict whether they feel more/less optimistic about the pandemic
# ending?

#------------------

# The model:

polrAnxModel <- polr(optimism ~ anxSum, data = KAPData)

summary(polrAnxModel)

# Here, we don't get p-values, so we can use the coeftest function in the AER package to get the p-values:
coeftest(polrAnxModel)

#------------------

# Visualizing our data:

plot(allEffects(polrAnxModel), lines=list(multiline=TRUE), 
     confint=list(style = "bands"))

# each intercept represents the cumulative probability of being in everything up to and including the left group (excl. right group)
# StronglyDisagree | Disagree -> 

#-------------------------------------------------

# Unordered logistic regression

# Can we use participants' anxiety levels to predict their reported political party?

#------------------

# The model:

multinomAnxModel <- multinom(polit~anxSum, data = KAPData)

summary(multinomAnxModel)

# Here, we don't get p-values, so we can use the coeftest function in the AER package to get the p-values:
coeftest(multinomAnxModel)

#------------------

# Visualizing our data:

plot(allEffects(multinomAnxModel), lines=list(multiline=TRUE), 
     confint=list(style = "bands"))