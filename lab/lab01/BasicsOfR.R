# Lab 1: Basics of R
#
# Author: M. Joseph Meyer

###############################################################################

# Getting and setting working directory
getwd()
setwd("/Users/mjosephmeyer/eclipse-Rstuff/Spring2021-TextFiles")

#############################

# Welcome to R (and RStudio)! This exercise will help you get familiar with 
# some of the basics of the program.

# Let's start by running this line of code below. 
# Do this by putting your cursor on the line you wish to run (or highlighting 
# the code) and hitting ctrl+enter on Windows or command+enter on Mac.

((10*6-21/3+17)*(4-18/(3*3)))%%6

# Great! The answer to this problem should show up in the console.

#############################

# Now run the next four lines. If it helps, you can highlight them to run them
# all at once!
w <- 7
x <- 522
y <- 18
z <- 29

# What is w*y?
w*y

# What does R return when running the code "x > y*z"? Is x greater than y*z?
x > y*z

# What does R return when running the code "x == y*z"? Is x equal to y*z?
x == y*z

# What is the output of prod(w, y)?
prod(w, y)

# What does R return when running the code "w*y == prod(w, y)"? Are w*y and prod(w,y) equal?
w*y == prod(w, y)

# What do you think the function "prod()" does?

############################################################################

# Good job! Now, let's look at some data. Run the two lines below. Make sure KAPData is in your working directory!
KAPData <- read.csv("../data/KAPJTerm.csv",check.names=FALSE,na.strings = "",
                    stringsAsFactors = TRUE)
KAPData <- KAPData[, c("id", "knowSum", "anxSum", "sleep")]

# Note that we're subsetting the data (using brackets!) so that our only columns are id (the id's of the participants),
# knowSum (the summed score for the knowledge questionnaire), anxSum (the summed score for the anxiety questionnaire),
# and sleep (whether sleep has changed since the Covid pandemic was made public). Over the next two weeks, we'll be
# looking at a few different variables from the SHHW and KAP datasets.

# The knowledge questions are below, and the summed score is how many questions participants got correct.
# know_1: Coronavirus is a contagious disease. (True)
# know_2: A person infected with Coronavirus is not contagious until after symptoms appear. (False)
# know_3: Coronavirus cannot be spread through sneezing and coughing. (False)
# know_4: Currently, there is an FDA approved drug for treating individuals with Coronavirus. (False (as of study))
# know_5: Coronavirus can live on surfaces outside of the body for a few hours or several days. (True)
# know_6: There is no vaccine currently available to prevent infection with Coronavirus. (True (as of study))
# know_7: Children are at high risk for complications from Coronavirus. (False)
# know_8: Older people with other health conditions are more likely to die from Coronavirus. (True)
# know_9: People with Coronavirus can have no symptoms at all. (True)
# know_10: Most people with Coronavirus will have severe or critical symptoms. (False)
# know_11: Alcohol-based hand sanitizers cannot protect you from Coronavirus. (False)
# know_12: Coronavirus may be transmitted by mosquito bites. (False)
# know_13: Coronavirus originated from animals (True (based on knowledge at time of study))

# And the anxiety questions and scale are below, and the summed score is the sum of the numeric scale responses.
# anx_1 - Feeling nervous, anxious, or on edge?
# anx_2 - Not being able to stop or control worrying?
# anx_3 - Feeling down, depressed, or hopeless?
# anx_4 - Little interest or pleasure in doing things (that I used to enjoy)?
# higher sums = more anxiety
# scale: Not at all=0; Several days=1; More than half the days=2; Nearly every day=3

# The frequencies of the sleep data are below:
table(KAPData$sleep)

# Now, let's do some statistics. Normally we begin by looking at the data, to see what it looks like.
# Run the line below to do this.
KAPData

# Wow, this is a lot of data! Normally we don't do this in R, especially if we have a lot of data. 
# Instead, we just look at the first few rows of data, to see what the variables look like.

# To do this, we use the head() function. 
head(KAPData)

#############################

# Now, let's look at some descriptive statistics. 

# How many rows of data do we have?
nrow(KAPData)

# Did participant 6's sleep change after the pandemic was made public? How much?
KAPData$sleep[KAPData$id == "ID0006"]

# What is the mean summed score for the knowledge questionnaire (knowSum) for all participants?
mean(KAPData$knowSum)

# What is the median summed score for the anxiety questionnaire (anxSum) for all participants?
median(KAPData$anxSum, na.rm = TRUE)

# Note that na.rm is an argument used when we have missing data. What happens when we don't include
# that argument?
median(KAPData$anxSum)

# How much missing data is in the anxiety questionnaire summed score?
sum(is.na(KAPData$anxSum))

# What is the standard deviation for the knowledge questionnaire summed score (knowSum) for all
# participants?
sd(KAPData$knowSum)

#############################

# Wait, do we have to run those functions for every statistic and every variable? 
# No, of course not! We can just run the "describe()" function from the psych package.

# Let's start by installing and loading the psych package. Run the lines below.

# If the psych package is not installed run the line below without the "#" 
# install.packages("psych")
# Otherwise, you can just load the package without installing it! 

library(psych)

# Note that in future R scripts, we'll be adding all library function calls to the beginning
# of the R script

# And now run this line of code to look at all of the statistics for the entire dataset.
describe(KAPData)

############################################################################

# Congratulations! You have done your first analysis in R!
