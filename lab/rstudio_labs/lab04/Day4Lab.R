
#
# Lab Day 4: t-tests and ANOVA by regression: using trend analysis, then other contrasts
#
# January 6th, 2021
#
# Karen and Joey
#
# Custom-made data
#

# Packages

library(truncnorm)
library(psych)
library(car)
library(Publish)
library(plotrix)
library(WebPower)

#---------------------------------------------------------------------------

# Create/Read in Data

set.seed(1926)
group1 <- round(rtruncnorm(n=214, a=1, b=40, mean=14, sd=3.75))
group2 <- round(rtruncnorm(n=214, a=1, b=40, mean=26, sd=5.50))
group3 <- round(rtruncnorm(n=214, a=1, b=40, mean=30, sd=4.25))

SHHWMaskSciData <- data.frame("Q30_HowOftenDoYouWearAMask"=
                                ordered(rep(c("Never","Sometimes","Always"),each=214),
                                        levels = c("Never","Sometimes","Always")),
                              "Q31_BeliefInScienceQuestionnaireSum"=c(group1,group2,group3))

#---------------------------------------------------------------------------

# Example 1 (two groups/t-test by Regression): How well can we use participants' willingness
# to wear masks (No or Yes) to predict their belief in science?

# Check structure of data
head(SHHWMaskSciData)
tail(SHHWMaskSciData)
str(SHHWMaskSciData)

# Higher numbers for the belief in science variable = higher belief in science

# Let's suppose that there were actually two categories: participants who wear masks, and those
# who don't.

# To do this, let's combine the Sometimes and Always categories:
levels(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask)

# There are a few different ways in which we can do this, but let's try a new one: the Recode function!
SHHWMaskSciData$DoYouWearMasks <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                         "'Always' = 'Yes';
                                         'Sometimes' = 'Yes';
                                         'Never' = 'No'",
                                         as.factor=TRUE,
                                         levels=c("No","Yes"))

# Now, let's go through all our usual hypothesis testing steps.

#-------------------------

# ...but first, our pre-study power analysis!

# Let's assume that we expect a medium effect size.
# By Cohen's conventions, this would be an f2 of 0.15.

# How many participants do we need to get at least a minimum threshold of
# 80% power?

# t-test by regression only has one predictor, so p1 = 1

wp.regression(p1=1, f2=0.15, power = .80)

#-------------------------

# Step 1: State research and null hypotheses

# Null Hypothesis: There is no difference in average science belief scores between those who
# wear masks and those who don't.

# Alternative hypothesis: There is a difference in average science belief scores between those who
# wear masks and those who don't.

boxplot(Q31_BeliefInScienceQuestionnaireSum ~ DoYouWearMasks, data=SHHWMaskSciData)

#-------------------------

# Step 2: Determine the characteristics of the comparison distribution

# Step 2a: Descriptive statistics

# -- Frequencies
# How many participants don't wear masks? How many do?
table(SHHWMaskSciData$DoYouWearMasks)

# Number of missing values:
sum(is.na(SHHWMaskSciData$DoYouWearMasks))

# This isn't necessary (and usually we don't do this, since this is our DV), but may be helpful
# for our next question:
table(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum)

# Number of missing values:
sum(is.na(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum))

# Next Question: What is the level of measurement for DoYouWearMasks?
# For Q31_BeliefInScienceQuestionnaireSum?

# -- Descriptives
describe(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum)
summary(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum)
IQR(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum)

# Since we're getting descriptive stats within groups, we can use the tapply function:
tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
       SHHWMaskSciData$DoYouWearMasks,
       describe)
tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
       SHHWMaskSciData$DoYouWearMasks,
       summary)

# Or do it manually using subsetting:
describe(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="No"])
describe(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="Yes"])

summary(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="No"])
summary(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="Yes"])

#-------------------------

# Steps 2b/c: Plotting data and testing assumptions

# -- Histograms
# Separately:
hist(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="No"],
     main="Histogram of Science Beliefs for Participants\nWho Don't Wear Masks",
     xlim=c(0,40),ylim = c(0,80),breaks=12)
hist(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="Yes"],
     main="Histogram of Science Beliefs for Participants\nWho Do Wear Masks",
     xlim=c(0,40),ylim = c(0,80),breaks=12)

# As one plot:
hist(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="No"],
     main="Science Belief for Mask Users/Non Users",
     xlim=c(0,40),ylim = c(0,80),breaks=12, col=rgb(1,0,0,0.5), xlab="Score on Science Questionnaire")
hist(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="Yes"],
     xlim=c(0,40),ylim = c(0,80),breaks=12,col=rgb(0,0,1,0.5), add=TRUE)
legend(1, 80, legend=c("Mask Nonusers", "Mask Users"), col=c("red", "blue"), pch=15)

# -- Q-Q Plots
# The DV as a whole:
qqnorm(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
       main="Q-Q Plot of Science Beliefs for All Participants")
qqline(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum)

# For each group
qqnorm(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="No"],
       main="Q-Q Plot of Science Beliefs for Participants\nWho Don't Wear Masks")
qqline(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="No"])
qqnorm(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="Yes"],
       main="Q-Q Plot of Science Beliefs for Participants\nWho Do Wear Masks")
qqline(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$DoYouWearMasks=="Yes"])

# For the model (best to use this over other Q-Q plots)
plot(lm(Q31_BeliefInScienceQuestionnaireSum ~ DoYouWearMasks, data = SHHWMaskSciData), which = 2,
     main = "Q-Q Plot of Model using Mask Wearing To Predict Science Beliefs")

# -- Boxplots
boxplot(Q31_BeliefInScienceQuestionnaireSum ~ DoYouWearMasks, SHHWMaskSciData,
        main = "Boxplot of Science Beliefs for\nThose Who Don't Wear Masks vs. Mask Wearers",
        xlab = "Do You Wear Masks", ylab = "Science Belief Questionnaire Scores")

# -- Residual plots
# Normally here we'd do residual plots at this point, but we'll talk about them next week!
# You don't need these in your presentation tomorrow either :)
# Here's a sneak peak:
op <- par(mfrow=c(2,2))
plot(lm(Q31_BeliefInScienceQuestionnaireSum ~ DoYouWearMasks, data = SHHWMaskSciData))
par(op)

# -- Relationship plots
# Since our predictor is categorical, we'll be using a barplot to look at our relationship:

# Start with creating our vectors of means and standard errors:
maskYesNoMeans <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                         SHHWMaskSciData$DoYouWearMasks,
                         mean)
maskYesNoSEMatrix <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                            SHHWMaskSciData$DoYouWearMasks,
                            std.error)
maskYesNoCILowerMatrix <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                                 SHHWMaskSciData$DoYouWearMasks,
                                 function(x){ci.mean(x)$lower})
maskYesNoCIUpperMatrix <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                                 SHHWMaskSciData$DoYouWearMasks,
                                 function(x){ci.mean(x)$upper})

# Barplot
ciLocations <- barplot(maskYesNoMeans,beside=TRUE,col=c("darkgray","darkgreen"),
                       ylim=c(0,40), xlab = "Do You Wear Masks",
                       ylab = "Science Belief Questionnaire Scores",
                       main="Barplot of Science Beliefs for\nThose Who Don't Wear Masks vs. Mask Wearers"
)
# 2*SE
arrows(x0=ciLocations,y0=maskYesNoMeans-2*maskYesNoSEMatrix,x1=ciLocations,
       y1=maskYesNoMeans+2*maskYesNoSEMatrix,
       length=.1,angle=90,code=3)
# 95% CI (not much different from 2*SE, since SE is so small)
arrows(x0=ciLocations,y0=maskYesNoCILowerMatrix,x1=ciLocations,y1=maskYesNoCIUpperMatrix,
       length=.1,angle=90,code=3,col="lightblue")

### Remember, you're only responsible for steps 1, 2a, and 2b (and your rationale and future plans) for
# tomorrow's presentation! ###

#-------------------------

# Steps 2d/3/4: Conducting the analysis

# At this point, we should make sure that our contrasts in R match our intended contrasts.
# To perform trend analysis, we need to set the group with the lower mean to -1, and the
# group with the higher mean to 1.

# In actual research, we only need to do one of these two approaches. Approach 1 matches lecture
# more closely, while approach 2 is more typical in real-life practice.

# Approach 1: Construct variables that correspond with these contrasts, and use them as predictors
SHHWMaskSciData$t.contrasts <- Recode(SHHWMaskSciData$DoYouWearMasks,
                                      "'No' = -1;
                                   'Yes' = 1",
                                      as.factor=FALSE)
# Yes-No model - Y_hat = b_0 + b_1*X_Linear
maskYesNoModel <- lm(Q31_BeliefInScienceQuestionnaireSum ~ t.contrasts, data = SHHWMaskSciData)
summary(maskYesNoModel)

# Reminder that b_0 is always the mean of the two group means, but is only the grand mean when
# group sample sizes are equal!

mean(maskYesNoMeans)

# Connection to Wednesday's class: Using model comparisons
# Base model - Y_hat = b_0
baseModel <- lm(Q31_BeliefInScienceQuestionnaireSum ~ 1, data = SHHWMaskSciData)
summary(baseModel)

# Note that using 1 on the IV side = no predictors
# This 1 is implied usually, so DV ~ IV is the same as DV ~ 1 + IV.
AIC(baseModel,maskYesNoModel)
BIC(baseModel,maskYesNoModel)

# Approach 2: Set contrasts directly
# By default, R uses dummy/treatment coding for R-unordered factors (i.e., when using the factor function)
# We'll learn about dummy/treatment coding in Example 3
contrasts(SHHWMaskSciData$DoYouWearMasks)
contr.treatment(2)# 2 = number of groups

# To use trend analysis, we can use contr.poly(Number of Groups). This is the default for R-ordered factors
# (i.e., when using the ordered function)
contr.poly(2)

# R multiplies our usual contrasts by a constant, but multiplying contrasts by a constant don't
# affect our test statistics or p-values (Regression coefficients are multiplied by 1/constant)

# Setting the contrasts:
contrasts(SHHWMaskSciData$DoYouWearMasks) <- contr.poly(2)

# And performing our analysis:
maskYesNoModelPoly <- lm(Q31_BeliefInScienceQuestionnaireSum ~ DoYouWearMasks, data = SHHWMaskSciData)
summary(maskYesNoModelPoly)

# Same t-value/p-value, and b_1Poly = (our approach 1 b_1)*1/0.7071068
6.7348*1/0.7071068

AIC(baseModel,maskYesNoModelPoly)
BIC(baseModel,maskYesNoModelPoly)

# Alternatively, we can set our contrasts directly by creating a matrix:
tTestContrasts <- matrix(c(-1,1), nrow = 2, ncol = 1, dimnames=list(c("No","Yes"),"NoVsYes_Linear"))
tTestContrasts

# Setting the contrasts:
contrasts(SHHWMaskSciData$DoYouWearMasks) <- tTestContrasts

# And performing our analysis:
maskYesNoModelDirect <- lm(Q31_BeliefInScienceQuestionnaireSum ~ DoYouWearMasks, data = SHHWMaskSciData)
summary(maskYesNoModelDirect)
AIC(baseModel,maskYesNoModelDirect)
BIC(baseModel,maskYesNoModelDirect)

#-------------------------

# Step 5: Effect size and writing up your results

# -- Effect size
# Our R^2 for our model is 64.2%, and a model with no predictors has an R^2 of 0, so our f2 is
# f2=(R2_full-R2_reduced)/(1-R2_full)
(0.642 - 0)/(1 - 0.642)

# Wow! A very large effect size!

# How much power is that?
wp.regression(n = 642, p1=1, f2=1.793296)

# Our power is 1, or almost 100%!

# -- Conclusion
# From our analyses above, we can conclude that as hypothesized, there is a statistically significant 
# difference in average science belief scores between those who don't wear masks (M = 14.08, SD = 3.52)
# and those who do (M = 20.82, SD = 5.26). Those who wear masks have statistically higher science beliefs
# on average compared to those who don't, b = 6.73, t(640) = 33.88, p < .001, with an overall large effect
# (f2 = 1.79). See Table __ for other descriptive statistics, and see Table __ for AIC and BIC from our
# model comparisons.

# Note that at this point you can go on to discuss additional interpretations of your results, and include
# tables of your descriptive statistics, frequencies, and AIC/BIC from all your model comparisons!

#---------------------------------------------------------------------------

# Example 2 (three groups/ANOVA by Regression): How well can we use participants' willingness
# to wear masks (Never, Sometimes, Yes) to predict their belief in science?

# Now let's go back to the original HowOftenDoYouWearAMask variable, which has three categories.

# Since we went through the full hypothesis steps earlier, let's just get to the good stuff.
# Note that for your project, make sure to follow example 1's structure!

#-------------------------

# Pre-study power analysis

# Let's assume that we expect a medium effect size.
# By Cohen's conventions, this would be an f2 of 0.15.

# How many participants do we need to get at least a minimum threshold of
# 80% power?

# We have three groups, so we'll have 3-1 = 2 predictors; therefore, p1 = 2

wp.regression(p1=2, f2=0.15, power = .80)

#-------------------------

# Descriptive statistics

# -- Frequencies
table(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask)

# -- Descriptives

# Since we're getting descriptive stats within groups, we can use the tapply function:
tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
       SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
       describe)
tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
       SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
       summary)

#-------------------------

# Plotting data and testing assumptions

# -- Histograms

op <- par(mfrow=c(1,3))
hist(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$Q30_HowOftenDoYouWearAMask=="Never"],
     main="Histogram of Science Beliefs for Participants\nWho Never Wear Masks",
     xlim=c(0,40),ylim = c(0,60),breaks=12)
hist(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$Q30_HowOftenDoYouWearAMask=="Sometimes"],
     main="Histogram of Science Beliefs for Participants\nWho Sometimes Wear Masks",
     xlim=c(0,40),ylim = c(0,60),breaks=12)
hist(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum[SHHWMaskSciData$Q30_HowOftenDoYouWearAMask=="Always"],
     main="Histogram of Science Beliefs for Participants\nWho Always Wear Masks",
     xlim=c(0,40),ylim = c(0,60),breaks=12)
par(op)

# -- Q-Q Plots

# For the model
plot(lm(Q31_BeliefInScienceQuestionnaireSum ~ Q30_HowOftenDoYouWearAMask, data = SHHWMaskSciData),
     which = 2,
     main = "Q-Q Plot of Model using Mask Wearing To Predict Science Beliefs")

# -- Boxplots
boxplot(Q31_BeliefInScienceQuestionnaireSum ~ Q30_HowOftenDoYouWearAMask, SHHWMaskSciData,
        main = "Boxplot of Science Beliefs Across Mask Wearing Amounts",
        xlab = "How Often Do You Wear Masks", ylab = "Science Belief Questionnaire Scores")

# -- Relationship plots
# Since our predictor is categorical, we'll be using a barplot to look at our relationship:

# Start with creating our vectors of means and standard errors:
maskHowOftenMeans <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                            SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                            mean)
maskHowOftenSEMatrix <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                               SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                               std.error)
maskHowOftenCILowerMatrix <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                                    SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                    function(x){ci.mean(x)$lower})
maskHowOftenCIUpperMatrix <- tapply(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum,
                                    SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                    function(x){ci.mean(x)$upper})

# Barplot
ciLocations <- barplot(maskHowOftenMeans,beside=TRUE,col=c("darkgray","goldenrod3","darkgreen"),
                       ylim=c(0,40), xlab = "How Often Do You Wear Masks",
                       ylab = "Science Belief Questionnaire Scores",
                       main="Barplot of Science Beliefs\nAcross Mask Wearing Amounts")
# 2*SE
arrows(x0=ciLocations,y0=maskHowOftenMeans-2*maskHowOftenSEMatrix,x1=ciLocations,
       y1=maskHowOftenMeans+2*maskHowOftenSEMatrix,
       length=.1,angle=90,code=3)
# 95% CI (not much different from 2*SE, since SE is so small)
arrows(x0=ciLocations,y0=maskHowOftenCILowerMatrix,x1=ciLocations,y1=maskHowOftenCIUpperMatrix,
       length=.1,angle=90,code=3,col="lightblue")

#-------------------------

# Conducting the analysis

# At this point, we should make sure that our contrasts in R match our intended contrasts.

# Approach 1: Construct variables that correspond with these contrasts, and use them as predictors
SHHWMaskSciData$linearANOVA <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                      "'Always' = 1;
                           'Sometimes' = 0;
                           'Never' = -1",
                                      as.factor=FALSE)
SHHWMaskSciData$quadANOVA <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                    "'Always' = 1;
                           'Sometimes' = -2;
                           'Never' = 1",
                                    as.factor=FALSE)
# How Often model - Y_hat = b_0 + b_1*X_Linear + b_2*X_Quadratic
maskHowOftenModel <- lm(Q31_BeliefInScienceQuestionnaireSum ~ linearANOVA + quadANOVA,
                        data = SHHWMaskSciData)
summary(maskHowOftenModel)

# b_0 is now both the mean of the two group means and the grand mean, since here the sample sizes
# are equal
mean(maskHowOftenMeans)
mean(SHHWMaskSciData$Q31_BeliefInScienceQuestionnaireSum)

# Connection to Wednesday's class: Using model comparisons
# Base model - Y_hat = b_0
# (Note that we're using the same criterion as example 1, so this baseModel is the same)
baseModel <- lm(Q31_BeliefInScienceQuestionnaireSum ~ 1, data = SHHWMaskSciData)
summary(baseModel)
AIC(baseModel,maskHowOftenModel)
BIC(baseModel,maskHowOftenModel)

# Approach 2: Set contrasts directly
# Now we have three groups, so we'll be using contr.poly(3)
# Setting the contrasts:
contr.poly(3)
contrasts(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask) <- contr.poly(3)

# And performing our analysis:
maskHowOftenModelPoly <- lm(Q31_BeliefInScienceQuestionnaireSum ~ Q30_HowOftenDoYouWearAMask,
                            data = SHHWMaskSciData)
summary(maskHowOftenModelPoly)

AIC(baseModel,maskHowOftenModelPoly)
BIC(baseModel,maskHowOftenModelPoly)

# Alternatively, we can set our contrasts directly by creating a matrix:
anovaContrasts <- matrix(c(-1,0,1,1,-2,1), nrow = 3, ncol = 2, dimnames=list(c("Never","Sometimes","Always"),
                                                                             c("Linear","Quadratic")))
anovaContrasts

# Setting the contrasts:
contrasts(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask) <- anovaContrasts

# And performing our analysis:
maskHowOftenModelDirect <- lm(Q31_BeliefInScienceQuestionnaireSum ~ Q30_HowOftenDoYouWearAMask, 
                              data = SHHWMaskSciData)
summary(maskHowOftenModelDirect)
AIC(baseModel,maskHowOftenModelDirect)
BIC(baseModel,maskHowOftenModelDirect)

#-------------------------

# Step 5: Effect size and writing up your results

# -- Effect size
# Our R^2 for our model is 69.7%, and a model with no predictors has an R^2 of 0, so our f2 is
# f2=(R2_full-R2_reduced)/(1-R2_full)
(0.697 - 0)/(1 - 0.697)

# Wow! An even larger effect size!

# How much power is that?
wp.regression(n = 642, p1=2, f2=2.30033)

# Our power is 1, or almost 100%!

# -- Conclusion
# From our analyses above, we can conclude that as hypothesized, there is a statistically significant 
# difference in average science belief scores across those who never wear masks (M = 14.08, SD = 3.52),
# those who sometimes wear masks (M = 25.28, SD = 5.36), and those who always wear masks (M = 29.83, SD = 4.03).
# There is a statistically significant linear trend across the three groups, b = 7.87, t(640) = 337.26, p < .001, 
# and a statistically significant quadratic trend across the three groups, b = -1.11, t(640) = -9.06, p < .001,
# with an overall large effect (f2 = 2.30). People who wear masks more frequently tend to believe science more,
# although those who wear masks at least sometimes seem to share closer levels of science beliefs to those who
# always wear masks compared to those who never wear masks. See Table __ for other descriptive statistics, and
# see Table __ for AIC and BIC from our model comparisons.

#---------------------------------------------------------------------------

# Example 3 (Other contrasts)

# Now that we've performed trend analysis to look at how mask wearing predicts how much one believes in science,
# What if we wanted to look at other comparisons? For example, can we keep all three groups separate, but still
# include a comparison in the model between those who wear masks and those who don't?

# Let's try a few different other kinds of comparisons, and see how the results differ.

# Note that the anova functions here are merely to show what happens to the shared variance -- if you decide
# to use one of these contrasts, you only need the summary function (and the appropriate contrast construction).

#-------------------------

# First, let's look at the correlation between the trend analysis variables, to show an example
# when we use orthogonal contrasts:

cor(SHHWMaskSciData$linearANOVA,SHHWMaskSciData$quadANOVA)

#-------------------------

# Dummy/Treatment coding

# In R, we can set our contrasts to contr.treatment(Number of groups) to perform dummy coding
contr.treatment(3)

# To be pedantic: I think Improper -/-> Nonorthogonal
# I think it's false that !Proper -> !Orthogonal

# For the rest of this R script, we'll stick with using approach 1 to construct the contrasts,
# but the R functions will be included if you'd rather use approach 2

# Intercept: mean of our reference (Never masks) group - NOT the mean of the group means

# Comparison 1: Difference between sometimes mean and never mean

SHHWMaskSciData$SometimesVsNever <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                           "'Always' = 0;
                           'Sometimes' = 1;
                           'Never' = 0",
                                           as.factor=FALSE)

# Comparison 2: Difference between always mean and never mean

SHHWMaskSciData$AlwaysVsNever <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                        "'Always' = 1;
                           'Sometimes' = 0;
                           'Never' = 0",
                                        as.factor=FALSE)

# Correlation between contrasts
cor(SHHWMaskSciData$SometimesVsNever,SHHWMaskSciData$AlwaysVsNever)

# Sometimes first
anova(lm(Q31_BeliefInScienceQuestionnaireSum~SometimesVsNever + AlwaysVsNever, data=SHHWMaskSciData))
AIC(lm(Q31_BeliefInScienceQuestionnaireSum ~ 1, data=SHHWMaskSciData),
    lm(Q31_BeliefInScienceQuestionnaireSum ~ SometimesVsNever, data=SHHWMaskSciData),
    lm(Q31_BeliefInScienceQuestionnaireSum ~ SometimesVsNever + AlwaysVsNever, data=SHHWMaskSciData))

# Always first
anova(lm(Q31_BeliefInScienceQuestionnaireSum ~ AlwaysVsNever + SometimesVsNever, data=SHHWMaskSciData))

# Both simultaneously
Anova(lm(Q31_BeliefInScienceQuestionnaireSum~SometimesVsNever + AlwaysVsNever, data=SHHWMaskSciData)) # capital-a Anova comes from `car` package, which uses simultaenous instead of sequential sum of squares approximation

# ANOVA by Regression
summary(lm(Q31_BeliefInScienceQuestionnaireSum~SometimesVsNever + AlwaysVsNever, data=SHHWMaskSciData))

#-------------------------

# Deviation (effect) coding

# R contrast function (if you decide to use approach 2):
contr.sum(3)
# Note that this assumes that the last level is the control group, not the first!

# Intercept: grand mean

# Comparison 1: Difference between sometimes mean and grand mean

SHHWMaskSciData$SometimesVsGrand <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                           "'Always' = 0;
                           'Sometimes' = 1;
                           'Never' = -1",
                                           as.factor=FALSE)

# Comparison 2: Difference between always mean and grand mean

SHHWMaskSciData$AlwaysVsGrand <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                        "'Always' = 1;
                           'Sometimes' = 0;
                           'Never' = -1",
                                        as.factor=FALSE)

# Correlation between contrasts
cor(SHHWMaskSciData$SometimesVsGrand,SHHWMaskSciData$AlwaysVsGrand)

# Sometimes first
anova(lm(Q31_BeliefInScienceQuestionnaireSum~SometimesVsGrand + AlwaysVsGrand, data=SHHWMaskSciData))

# Always first
anova(lm(Q31_BeliefInScienceQuestionnaireSum ~ AlwaysVsGrand + SometimesVsGrand, data=SHHWMaskSciData))

# Both simultaneously
Anova(lm(Q31_BeliefInScienceQuestionnaireSum~SometimesVsGrand + AlwaysVsGrand, data=SHHWMaskSciData))

# ANOVA by Regression
summary(lm(Q31_BeliefInScienceQuestionnaireSum~SometimesVsGrand + AlwaysVsGrand, data=SHHWMaskSciData))

#-------------------------

# Complex orthogonal comparisons

# R contrast construction (if you decide to use approach 2):
customContrasts <- matrix(c(-2,1,1,0,-1,1), nrow = 3, ncol = 2, dimnames=list(c("Never","Sometimes","Always"),
                                                                              c("NoVsYes","SometimesVsAlways")))
customContrasts

# Intercept: Grand mean

# Comparison 1: Never vs. average of sometimes and always
# (this is meant to be an equivalent comparison to the "Yes" vs. "No" comparison earlier, but with
# better weighting)

SHHWMaskSciData$NoVsYesContrasts <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                           "'Always' = 1;
                           'Sometimes' = 1;
                           'Never' = -2",
                                           as.factor=FALSE)

# Comparison 2: Sometimes vs. Always

SHHWMaskSciData$SometimesVsAlways <- Recode(SHHWMaskSciData$Q30_HowOftenDoYouWearAMask,
                                            "'Always' = 1;
                           'Sometimes' = -1;
                           'Never' = 0",
                                            as.factor=FALSE)

# Correlation between contrasts
cor(SHHWMaskSciData$NoVsYesContrasts,SHHWMaskSciData$SometimesVsAlways)

# Never mask first
anova(lm(Q31_BeliefInScienceQuestionnaireSum~NoVsYesContrasts+SometimesVsAlways,data=SHHWMaskSciData))

# Comparison between the two kinds of mask wearing first
anova(lm(Q31_BeliefInScienceQuestionnaireSum~SometimesVsAlways+NoVsYesContrasts,data=SHHWMaskSciData))

# Both simultaneously
Anova(lm(Q31_BeliefInScienceQuestionnaireSum~NoVsYesContrasts+SometimesVsAlways,data=SHHWMaskSciData))

# ANOVA by Regression
summary(lm(Q31_BeliefInScienceQuestionnaireSum~NoVsYesContrasts+SometimesVsAlways,data=SHHWMaskSciData))