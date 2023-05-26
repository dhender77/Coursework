#Chapter 5 Notes

rm(list=ls())

#Things that will be covered:
#Itrerative Approach to Data Analysis and Modeling

#Automatic Variable Selection Procedures

#Residual Analysis 

#Influential Points

#Colinearity

#Selection Criteria

#Heteroscedasticity

 
#With k variables, there are 2^k possible linear models that can be made

#Stepwise Regression Algorithm:

#Compute the t-ratio for each variable. Choose the variable with the highest t -ratio 
# that also exceeds a pre-specified t-ratio value

#Absolute value of t-ratio

#Delete the variable that has the smallest t-ratio.
#Anytime you add or take an x away, the %variance explained for each variable changes

#So, Let's say you choose X1, X2, and X4. Upon adding X4, maybe X2 is no longer significant...
# take it out

#Drawbacks of Stepwise Regression:
#1. Don't fit the sample so well that future points are not predicted well
#2 The algorithm does not search all 2^k possible linear regressions
#3. The algorithm uses just one criterion, a t-ratio, and does not consider
# other criteria such as r2, r2a, and s
#4. Does not take into account the joint effect of independent variables

#Variants of Stepwise Regression
#Forward Selection: Add one variable without trying to delete variables
#Backwards selection: Start with the full model and delete one variable at a time
# without trying to add variables

#For Backward: Throw out the worst variable one at a time based on highest p-value.
#Stop when all t p-values < alpha.
#benefit: Every x get's a chance
#benefit: Pick alpha, and track r2, r2a, etc.

#stop when all pvalues are less than alpha

#Automatic Variable Selection Process

#stepwise regression and best regressions are examples of automatic variable selection

#Does it for us. Pretty sick
#Doesn't check non linearity or interaction

############################ 5b ##############################

liquid= read.csv(choose.files(), header=T)
# file name is liquidity

attach(liquid)


head(liquid)

cor(cbind(VOLUME, AVGT, NTRAN, PRICE, SHARE, VALUE, DEBEQ))
#correlation only measures linear relationship

#let's try stepwise regression:

m0=lm(VOLUME~1)
#Null model with no variables
summary(m0)

m1=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ)
summary(m1)
#Full model with all the X's

step(m0, scope=list(lower=m0, upper=m1, direction ="both"))

#step command contains in it the different methods of stepwise regression
#'both' is what is doing the stepwise
# If I put forward in there, m0 is still the starting point
# IF i put backwards in there, then the starting point would be m1

#AIC is used to judge model comparisons

#The smaller the AIC the better the fit

#Balances the fit in the first part and the penalty for complexity in the second part

#Anything above the none line means that these are decisions that would make the model better
# anything below would make the model worse

#The next model that it will build will include the top variable

# + are for adding variables to the model
# - are for throwing variables out of the model

#The stopping point is the final model that stepwise has chosen, slong with values
# for bo and the slopes.

mStep=lm(VOLUME~NTRAN+AVGT+SHARE)
summary(mStep)

#R2 went down a little from .849 to .8469. This is very little, and a good sign
# r2a went up since we take less of a penalty for fewer X's
# s went down a little from 4.237 to 4.212, which is a little better
# all with only 3 X's instead of 6

#Let's try Backward Regression this time:

summary(m1)

#Let's throw out PRICE, because it has the highest p-value=.5465>any alpha.

# So it's doing the worst job of predicting VOLUME. You can only throw out 1 X at a time:

m2=lm(VOLUME~AVGT+NTRAN+SHARE+VALUE+DEBEQ)
summary(m2)

#VALUE has the worst p-value. Throw it out


m3=lm(VOLUME~AVGT+NTRAN+SHARE+DEBEQ)
summary(m3)

#Now we hate DEBEQ
m4=lm(VOLUME~AVGT+NTRAN+SHARE)
summary(m4)

#All remaining variables are under alpha @.05

############################# 5C #####################################

#Notes:

#Residual plots should have a random scatter and equal variance

# always check for these two^

 
#Ideally, we want the y and yhat values to be as close as possible

#1. Random Scatter -> Residual Plot
#2. Equal variance (homoscedasticity) ->Residual Plot
#3. Normality
#4. Linearity

#Four Types of Patterns:
#- Large Residuals : omit outliers _> remove points
#- Residuals related to explanatory variables -> put in an x^2 term
#- Heteroscedastic residuals-> Log transformation may help

#Standardized residual: residual divided by its estimated standard error
# Reasons to use it:
# we can focus on relationships
# achieve carry-over of experience from one data set to another

#Outliers are points unusual in the Y direction
#They are considered unusually large if their absolute value is > 2
#options for handling outliers:
#-ignore them in the analusis but be sure to discuss their effects
#- Delete them from the data set -> most common
#- Create a binary variables to indicate their presence

######################### Code 5d ################################

liquid=read.csv(choose.files())
#Read in liquidity

attach(liquid)

#Scatterplot matrix to start

vars=data.frame(AVGT, NTRAN, SHARE, VALUE, DEBEQ, VOLUME)
pairs(vars, upper.panel = NULL)
#Notice that there is 1 point in the corner for all of the plots
#If we remove it, our model can improve quite a bit

#Essentially, trimming the outliers can help a ton.

#Might have 1 or 2 points as outliers, there are a coiple of points off
# in the corners of each of the plots which are the same points.
# So, removing them may improve how our model fits with several
# X's.

#How to make a graph with the observation numbers instead of dots
# kinda sick

plot(SHARE, VOLUME, type="n")
#This will build the graph technically, but doesn't put the points on there.
text(SHARE, VOLUME, labels=rownames(liquid))
#60 is the point that is in the top of the corner of all the graphs
# We are referencing the points based on the regression line

# So, the residual for 122 is worse than 60.

#Let's finf the outliers, points that are unusual in the Y
attach(liquid)
m1=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ)
summary(m1)
#standardized residuals:
rsta=rstandard(m1)
rsta[order(rsta)]
#We can see that observation 79 and 122 are both greater than the 
# absolute value of 2, so they are outliers

#Then if we come down to the positive end, we see 6 points that are 
# above 2. So they are also outliers

#Now let's find studentized residuals:

rstu=rstudent(m1)
rstu[order(rstu)]

#The studentized residuals are made a bit larger, but we still go
# based off the > 2 rule.Takes the values greater than 2 and makes them larger.

liquid[which(rstandard(m1)>2.0),]
#FOr rows greater than 2 and all columns

liquid[which(rstandard(m1)< -2.0),]

############################ 5e ###################################

#Influential Points are observations that have a lot to say about a regression fit.
#They have larger residuals, high leverage, or both

#High leverage Points are those that are unusual in the horizontal or x direction
#options for handling high leverage points:
#- Ignore them and discuss their effects
# - Delete them from the data set
# - Choose another variable to represent the information
#- Use a non linear transformation of an explanatory variable

#Now lets find the high leverage points, those that are unusual in the x direction.

leverages= hatvalues(m1)
leverages[order(leverages)]
# cutoff for a high leverage point = 3(k+1)/n
dim(liquid)
#6 variables in model output =k and n = 123
3*(6+1)/123

#High leverage points that exceed this cutoff are 112,94,77,53,122,38,60

liquid[which(hatvalues(m1)>.1707),]

#Cook's Distance
#Another measure of influence. It measures both the explanatory and response variables

cooksd=cooks.distance(m1)
cooksd[order(cooksd)]

#df1 = K+1 -> 6+1 =7
#df2= n-(k+1)-> 123-(6+1) = 116

qf(.95, 7, 116)
#=2.08

#We don't have any points greater than the cooks cutoff, so by cooks, we wouldn't get rid of any 
# points.

vars=data.frame(AVGT, NTRAN, SHARE, VALUE, DEBEQ, VOLUME)
pairs(vars, upper.panel = NULL)

#Now, lets remove the outliers and high leverage points we found from the 
# dataset, then redo our graphs and model.

liquid1 = subset(liquid, leverages<.1707& rsta<2&rsta>-2)
dim(liquid1)

attach(liquid1)

vars=data.frame(AVGT, NTRAN, SHARE, VALUE, DEBEQ, VOLUME)
pairs(vars, upper.panel = NULL)

#We can see that some of the points are trimmed off from the 
# original plots and many plots have different ranges now that 
# points on the edges were removed.

#Let's rebuild model 1 and see how that fit has changed

m1b=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ)
summary(m1b)

#The signs for the slopes are all the same as before.
#DEBEQ was not significant before with a pvalue of .306, but now
# it would be significant at alpha=.05 with a p-value of .013.
#The significance of the other variables are unchanged.

#The error for s in the new model has gone down
# the r2 went down

#If you remove only the outlier points, the model almost always gets better
#If you also remove the high leverage points, that may make the model
# better or worse

liquid2 = subset(liquid, rsta<2&rsta>-2) # this only removes outliers for us
attach(liquid2)
m1c=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ)
summary(m1c)
#By only removing outliers, our r2 is much larger, DEBEQ is now insignificant again

#Every one of the goodness of fit statistics improved

#Looking at the scatterplots, lets try a squared term with AVGT and SHARE
attach(liquid1)
avgt_squared= AVGT^2
share_squared=SHARE^2

m4=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ+avgt_squared+share_squared)
summary(m4)

vars=data.frame(AVGT, NTRAN, SHARE, VALUE, DEBEQ, VOLUME)
pairs(vars, upper.panel = NULL)

#The avgt_sqwuared term does not make it, but the share_squared term is significant
#avgt has a p value of .24>alpha.
#share_squared has a p valyue of .013 can be < alpha

###################################### 5f #########################

outlier=read.csv(choose.files(), header=T)
#read in outlier example

attach(outlier)

outlier

#outlier is unusual in the vertical direction (Y)
# High leverage point is unusual in the horizontal direction (X)


modelA=lm(Y~X, subset=-c(21,22))
#This puts in the 19 good points, and leaves a bad point(20)(A) in.


rstandard(modelA)[20] #finds standardized residual for observation 20

hatvalues(modelA)[20] #finds the leverage values

cooks.distance(modelA)[20] #finds the cooks d value

#We can tell that this is an outlier because the standardized residual
# is greater that 2

modelB=lm(Y~X, subset=-c(20,22)) #Leaves in point B with the 19 good points

rstandard(modelB)[20]

#It was observation 21 in the original dataset, however this model would reference
# the 20th point because there are a total of 20

hatvalues(modelB)[20]
cooks.distance(modelB)[20]


modelC=lm(Y~X, subset=-c(20,21))
rstandard(modelC)[20]

hatvalues(modelA)[20] #finds the leverage values

cooks.distance(modelA)[20] #finds the cooks d valus

#hat values might make it, and the cooks distance which corrosponds with the 
# f value is likely too high to make it

#outlier by residual standards

str(modelC)
#Cutoff for rstandard is +/- 2 for outliers
#Cutoff for hatvalues is 3(k+1)/n for high leverge points, 3(1+1)/20
#k is the number of x terms in the model
# n is the number of observations

#Cutoff for Cooks D is the F critical value, df1=K+1, df2=n-(k+1)
# df1= 1+1, df2=20-(1+1)

qf(.95, 2, 18)

#We see that observation 20 (point A) is an outlier because it exceeds the standardized residual = 4.0

#It is not a high leverage point since its hatvalue =.067 does not exceed the .3 cutoff.
# it is also not overly influential according to Cook's D since its value =.577 does not
# exceed the 3.55 cutoff.

#Obs 21 (point B) is not an outlier, does exceed the high leverage cutoff,
# and does not exceed Cook's D cutoff. 

#Obs 22 (point C) is an outlier, does exceed the high leverage cutoff,
# and does exceed Cook's D cutoff. 

#The cutoffs will be the same across the board. So calculate the cutoffs first,m
#and then compare to the residuals, leverage, and cooks distance


####################


#Colinearity or multicolinearity: occurs when one explanatory variable is 
# a linear combination of the other exmplanatory variables


#Colinearity is an issue when x variables are too highly correlated with eachother.
#We would hoipe that the X's are highly correlated with the Y
#If they're too highly correlated with eachother, they cant separate themselves.


#Detect this when the F-pvalue is small but the t p-values are large
#how could the model be doing a good job when none of the x's are significant?

#In the house dataset, all of the variables are related to how large the house is
#don't put all of them in

#Variance Inflation Factors
#To detect collinearity, begin with a matrix of correlation coefficents
# of the explanatory variables

# This will exclude the Y

#General cutoffs are .4/.7


#To capture more complex relationships among several variables, use a variance inflation factor (VIF)

#Rule of Thumb: When the VIF exceeds 10, we say that severe collinearlity exists
#This may signal the need for action

#Collineraity example:
head(liquid)

attach(liquid)

m1=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ)
summary(m1)

#4/6 X's are not significant, yet the f p-value is very significant

#Let's start with a correlation matrix between only the X variables to investigate

cor(cbind(AVGT, NTRAN, PRICE, SHARE, VALUE, DEBEQ))
#SHARE and NTRAN
#SHARE and VALUE

#Highest correlations
#we are suspicious of share because the correlations with share and the other variables
# is too high

#Now let's look at the variance inflation factors. To do that, I 
# need to install one of the following packages: car, faraway, HH, or fmsb.

library(car)

#The library will 'call' the package you just installed. In the future
# it should remember the packages you have insstalled

vif(m1)

#None of the numbers are over 10 which is good news. We do not have severe
# collinearity

#We do see that SHARE, VALUE, and NTRAN have the hgihest values just like they
# had the highest correlations

#If you get multiple X's over 10, you dont need to remove both of the variables
# remove 1

#if we had categorical variables, we would get gvif(for generalized vifs)
#and gvif values raised to the power of something. That something is an
# adjustment for the number of terms we have in each variable. We will use those 
# if R gives them to us and still with the cutoff of 10.

####################################### 5G and 6A ######################################

#Continuing with Collinearity and Leverage

# the smaller the AIc the better the fit

#Homoscedasticity <- equal variance
#Heteroscedasticity <- unequal variance

#To detect heteroscedasticity graphically, plot the residuals versus the fitted values

#megaphone shape fixed by log of Y

liquid2 = subset(liquid, rsta<2&rsta>-2) # this only removes outliers for us
attach(liquid2)
m1c=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ)
summary(m1c)
#By only removing outliers, our r2 is much larger, DEBEQ is now insignificant again

#Every one of the goodness of fit statistics improved

#Looking at the scatterplots, lets try a squared term with AVGT and SHARE
attach(liquid1)
avgt_squared= AVGT^2
share_squared=SHARE^2

m4=lm(VOLUME~AVGT+NTRAN+PRICE+SHARE+VALUE+DEBEQ+avgt_squared+share_squared)
summary(m4)

#Let's do some backwards regression, and we will start by eliminating PRICE because it has the highest p-value

m4a=lm(VOLUME~AVGT+NTRAN+SHARE+VALUE+DEBEQ+avgt_squared+share_squared)
summary(m4a)
#Now avgt_ssuared is doing the worst job
m4b=lm(VOLUME~AVGT+NTRAN+SHARE+VALUE+DEBEQ+share_squared)
summary(m4b)
#Now we are going to throw out AVGT
m4c=lm(VOLUME~NTRAN+SHARE+VALUE+DEBEQ+share_squared)
summary(m4c)
#Everything is now significant, so we stop

#Let's look at the residual plot of this model:
plot(residuals(m4c)~fitted.values(m4c), main= "Residuals vs Y-Hat values.")
#We are looking at the scatter here

#There is random scatter in this plot and no obviosu pattern which is good
# Random scatter also means that our assumption of linearity is corroberated

#We have a homoscedastic plot which is good


