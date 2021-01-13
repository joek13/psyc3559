#
# Lab Day 6: Stepwise Regression; Ridge and Lasso Regression; Quantile Regression
#
# January 11th, 2021
#
# Cynthia Tong
#
# KAP data
#
#set working directory! 
KAPData<-read.csv("../data/KAPJTerm.csv",check.names=FALSE,na.strings = "",sep=",", stringsAsFactors = TRUE)
KAPData$optimismNum <- Recode(KAPData$optimism, "'Strongly Disagree' = 0; 'Disagree' = 1; 'Agree' = 2; 'Strongly Agree' = 3;", as.factor=FALSE, as.numeric=TRUE)

dim(KAPData)
head(KAPData)
tail(KAPData)
str(KAPData)

describe(KAPData, na.rm=TRUE)
summary(KAPData, na.rm=TRUE)


#Check structure of data
str(KAPData, list.len = ncol(KAPData))

#install.packages('MASS')
library(MASS)


# Let's set up multiple regression models.  

# Y-pred = What is the perceived severity of COVID?
# X1 = percv_risk; What is the perceived risk of infection?
# X2 = anxSum; Sum of all anxiety questions from the PHQ 
# X3 = voteNum; Are you eligible to vote in local, state, or federal 2020 election?
# X4 = threatSum; The coronavirus is a threat to my: Sum of threat_secur, threat_econ, threat_pers (personal finances)
# X5 = StatePolit; Political leaning of state participant is located in. 0 (Most conservative) to 1 (Most liberal)
# X6 = behavSum; Sum of protective behaviors (behav1-behav12: 1 for each behavior performed)
# X7 = knowSum; Knowledge about COVID-19 score
# X8 = knowiInfSum; Knowledge about preventing infection score
# X9 = age

#save the variables that we are interested in to a new dataset "data"
data <- cbind(KAPData$percv_sev,KAPData$percv_risk,KAPData$anxSum,KAPData$voteNum,KAPData$threatSum,
              KAPData$StatePolit,KAPData$behavSum,KAPData$knowSum,KAPData$knowInfSum,KAPData$age, KAPData$optimismNum)
colnames(data) <- c("percv_sev","percv_risk","anxSum","voteNum","threatSum","StatePolit","behavSum",
                    "knowSum","knowInfSum","age", "optimismNum")

head(data)
dim(data)

# pick out participants with missing values
mis.row <- NULL
for(i in 1:5485){
  for(j in 1:10){
    if(is.na(data[i,j])){mis.row <- c(mis.row,i)}
  }
}

#check the number of participants who have missing values
length(unique(mis.row))

#delete participants who have missing values (be cautious! Missing data should not be simply deleted..)
data <- data[-unique(mis.row),]

data <- data.frame(data)

#full model
model.f <- lm(percv_sev~ percv_risk+ anxSum + voteNum+ threatSum+ StatePolit + behavSum+ knowSum+ knowInfSum+ age, data=data)
#or
model.f <- lm(percv_sev~., data=data)
summary(model.f)

#model without any predictor
model.0 <- lm(percv_sev~1,data=data)
summary(model.0)

#model with one predictor
model.1 <- lm(percv_sev~voteNum,data=data)
summary(model.1)

##########################################################################
##########################################################################
#stepwise regression - forward
forward <- stepAIC(model.0,scope=list(lower=model.0,upper=model.f),direction="forward",trace=FALSE)
forward$anova

#stepwise regression - backward
backward <- stepAIC(model.f,direction="backward",trace=FALSE)
backward$anova

#stepwise regression - both
both <- stepAIC(model.1,scope=list(lower=model.0,upper=model.f),direction="both",trace=FALSE)
both$anova

# Note: the stepAIC function can add or delete variables, so your starting model is not all that important.

model.0 <- lm(optimismNum ~ 1, data=data)
model.f <- lm(optimismNum ~ ., data=data)

both <- stepAIC(model.opt, scope=list(lower=model.0,upper=model.f), direction="both", trace=FALSE)

##########################################################################
##########################################################################
##lasso
#install.packages('glmnet')
library(glmnet)

#predictors are assumed to be normalized
s.data<-scale(data)
x<-s.data[,2:10]
#outcome is assumed to be centered.
y<-as.matrix(data[,1])
y<-y-mean(y)


?glmnet

#fit lasso regressions
las <- glmnet(x,y,alpha=1) # tuning parameter (when alpha = 1 -> lasso, when alpha = 0 -> ridge regression, when alpha between 0 and 1: elastic net)

#find the tuning parameter lambda using cross validation
cvlas<-cv.glmnet(x,y,nfolds=10)
cvlas$lambda.min

plot(cvlas)

#lasso regression coefficients
coef(las,s=cvlas$lambda.min)


##ridge regression
ridge <- glmnet(x,y,alpha=0)
cvrid<-cv.glmnet(x,y,nfolds=10)
cvrid$lambda.min
plot(cvrid)
#ridge regression coefficients
coef(ridge,s=cvrid$lambda.min)


##elasticnet regression
ela <- glmnet(x,y,alpha=0.5)
cvela<-cv.glmnet(x,y,nfolds=10)
cvela$lambda.min
plot(cvela)
#ridge regression coefficients
coef(ela,s=cvela$lambda.min)


##########################################################################
##########################################################################
#quantile regression

#install.packages('quantret')
library(quantreg)

#set different quantiles
taus <- c(0.05,0.1,0.25,0.5,0.75,0.9,0.95)

#quantile regression vs. ordinary regression

summary(rq(percv_sev~percv_risk+anxSum+threatSum,tau=c(0.5),data))
summary(lm(percv_sev~percv_risk+anxSum+threatSum,data))


rq(percv_sev~percv_risk,tau=taus,data)
lm(percv_sev~percv_risk,data)

##plot regression lines
plot(data$percv_risk,data$percv_sev,xlab="percv_risk",ylab="percv_sev", col=rgb(1,0,0,0.1))
abline(lm(percv_sev~percv_risk,data),lty=1,col='red')

for(i in 1:length(taus)){
  abline(rq(percv_sev~percv_risk,tau=taus[i],data),col='blue')
}

fit <- rq(percv_sev~percv_risk,tau=0.95,data)

summary(fit)
plot(summary(rq(percv_sev~percv_risk,tau=1:9/10,data)))


#multiple regression plot
plot(summary(rq(percv_sev~percv_risk+anxSum+threatSum,tau=1:9/10,data)),parm=1)
plot(summary(rq(percv_sev~percv_risk+anxSum+threatSum,tau=1:9/10,data)),parm=2)
plot(summary(rq(percv_sev~percv_risk+anxSum+threatSum,tau=1:9/10,data)),parm=3)
plot(summary(rq(percv_sev~percv_risk+anxSum+threatSum,tau=1:9/10,data)),parm=4)





#################################################################################################
##################################################################################################

# for Collab Day 3 Worksheet

KAPData$sleepMoreNum <- Recode(KAPData$sleep,
                               "'Little more' = 1;
                         'Much more' = 1;
                        else = 0",
                               as.factor=FALSE,
                               as.numeric=TRUE)
model <- glm(sleepMoreNum~behavSum, family=binomial(),data = KAPData)

# what's the probability of sleeping more since the pandemic started, given behavSum = 6
intercept <- -1.75254
slope <- 0.21024
log_odds <- intercept + 6 * slope
odds <- exp(log_odds)
prob <- odds / (1 + odds)

behavSum <- c(6)
d <- data.frame(behavSum)

predict.glm(model, newdata=d)

#find the median regression coefficients
lm(percv_sev ~ percv_risk + anxSum, data=data)
rq(percv_sev~percv_risk+anxSum,tau=0.5,data)



##################################################################################################
##################################################################################################


