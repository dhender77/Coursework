#Project 2
rm(list= ls())

library(rpart)
library(rpart.plot)
library(ggplot2)
library(pROC)
library(RColorBrewer)
library(randomForest)

Twins = read.csv("Project 2 data.csv", stringsAsFactors = FALSE)

str(Twins)
head(Twins)

#-----DATA CLEANING------

#there are 5 random variables at the end here that are all NA, let's remove
#ROE(Reach on error) is a stat that is not controlled by a hitter,
#we are only looking at the impact of the offense, remove ROE
#RBI(Runs batted in) is a statistic that is loosely correlated with ROE,
#and is normally the same value as R(runs) unless there are errors, we'll
#remove RBI as well
#Since we want to make a strategy around winning Game Count, we should take out
#R(Runs) because that's very obvious, score more= win more
#Let's also take out at-bats, because it is strongly correlated
#With hits and walks

str(Twins)

Twins_clean2 = subset(Twins, select = -c(22:26, 4,5,10, 14))
head(Twins_clean2)


#We have successfully removed the variables we don't need

#now let's convert our character variables to factors

Twins_clean2$Home.Away = as.factor(Twins_clean2$Home.Away)
Twins_clean2$Opp= as.factor(Twins_clean2$Opp)
Twins_clean2$Rslt= as.factor(Twins_clean2$Rslt)
Twins_clean2$Thr= as.factor(Twins_clean2$Thr)

str(Twins_clean2)


### --- EXPLORATORY ANALYSIS -------

#Let's start with their overall record
summary(Twins_clean2$Rslt)
#Their overall record was 373-335
373/(373+335)
#Winning percentage of 0.5268362

#Let's make histograms of the counting stats

display.brewer.all(colorblindFriendly = TRUE)

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= OPS), binwidth = 0.01)+
  ggtitle("Histogram of OPS")+
  labs(x= "OPS", y= "Game Count")
#Majority of OPS is in .660 to .860 range
#Binwidth of .01 for every 10 points of OPS

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= H), binwidth = 1)+
  ggtitle("Histogram of Hits")+
  labs(x= "Hits", y= "Game Count")
#Almost normally distributed aroumd 9, slightly right-skewed
#This is expected

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= X2B), binwidth = 1)+
  ggtitle("Histogram of Doubles")+
  labs(x= "Doubles", y= "Game Count")
#Right-skewed with majority of observations between 0 and 3


ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= HR), binwidth = 1)+
  ggtitle("Histogram of Home Runs")+
  labs(x= "Home Runs", y= "Game Count")
#Right-skewed with most data being less than or equal to 3

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= BB), binwidth = 1)+
  ggtitle("Histogram of Walks")+
  labs(x= "Walks", y= "Game Count")
mean(Twins_clean2$BB)
#Slightly right-skewed with a mean around 3.5

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= SO), binwidth = 1)+
  ggtitle("Histogram of Strikeouts")+
  labs(x= "Strikeouts", y= "Game Count")
#Pretty normally distributed around 9

#Could be inferrred that X3B(Triples), HBP, SB, and CS will have low values with a majority being 0
#So we will leave out these graphs

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= BA), binwidth = .005)+
  ggtitle("Histogram of Batting Average")+
  labs(x= "Batting Average", y= "Game Count")
#Majority of observations are between .230 and .280

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= LOB), binwidth = 1)+
  ggtitle("Histogram of Runners Left on Base")+
  labs(x= "Runners Left on Base", y= "Game Count")
#normal distribution around 7

#Let's now add a component that fills based on Win or loss
#Let's choose OPS and Hits

display.brewer.all(colorblindFriendly = TRUE)
#chose palette 14, most reasonable color for a baseball theme

ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= OPS, fill= Rslt), position = "fill", binwidth = 0.01)+
  ggtitle("Win Proportion by OPS")+
  labs(x= "OPS", y= "Proportion")+
  scale_fill_brewer(palette= 14)+
  theme_bw()
#not necessarily a direct positive relationship with OPS and win proportion


ggplot(data=Twins_clean2)+
  geom_histogram(aes(x= H, fill= Rslt), position = "fill", binwidth = 1)+
  ggtitle("Win Proportion by Total Hits")+
  labs(x= "Hits", y= "Proportion")+
  scale_fill_brewer(palette= 14)+
  theme_bw()
#another fairly direct positive relationship with hits and win proportion


#now let's make bar charts with some of the character variables
#Home/Away and Thr(dominant hand of the opposing starting pitcher)
#are probably pretty important

ggplot(data=Twins_clean2)+
  geom_bar(aes(x= Home.Away, fill= Rslt), position = "fill")+
  ggtitle("Win Proportion Away vs Home")+
  labs(x= "Away/Home", y= "Proportion")+
  scale_fill_brewer(palette= 14)+
  theme_bw()
#As expected, higher winning percentage at home. But not by much

ggplot(data=Twins_clean2)+
  geom_bar(aes(x= Thr, fill= Rslt), position = "fill")+
  ggtitle("Win Proportion by Opposing Starter")+
  labs(x= "Lefty/Righty", y= "Proportion")+
  scale_fill_brewer(palette= 14)+
  theme_bw()
#Higher winning percentage against right-handed starters


summary(Twins_clean2$Thr)
#faced 206 lefties and 502 righties
206/(206+502)
#0.2909605 of games against lefties
1-206/(206+502)
#0.7090395 of games against righties

#--- Data preparation ----------
RNGkind(sample.kind = "default")
set.seed(2291352)
train.idx = sample(x= 1:nrow(Twins_clean2), size= floor(.8*nrow(Twins_clean2)))
head(train.idx)
#train.idx are the row numbers that will go into the training data
#create training data
train.df= Twins_clean2[train.idx,]
#create test data frame
test.df= Twins_clean2[-train.idx,]

###----BASELINE FOREST-----

myforest= randomForest(Rslt~.,
                       data= train.df,
                       ntree= 1000,#B= 1000, number of trees
                       mtry= 4, #mtry= m= 4= sqrt(16) (approx)
                       importance= TRUE
)

myforest

#out of bag accuracy
(146+224)/(146+73+123+224)
#0.6537102
#predicted the result correctly 65.4% of the time

#out of bag error
1-(146+224)/(146+73+123+224)
#0.3462898
#predicted the result incorrectly 34.6% of the time

#----Tuning Forest-----


mtry= c(1:16)
#make room for OOB errors and mtry values
keeps= data.frame(m= rep(NA, length(mtry)),
                  OOB_err_rate= rep(NA, length(mtry)))

for (idx in 1:length(mtry)){
  print(paste0("Fitting m=", mtry[idx]))
  tempforest= randomForest(Rslt~ .,
                           data= train.df,
                           ntree=1000,
                           mtry= mtry[idx])
  keeps[idx, "m"]= mtry[idx]
  keeps[idx, "OOB_err_rate"]= mean(predict(tempforest) != train.df$Rslt)
}

ggplot(data= keeps)+
  geom_line(aes(x=m, y= OOB_err_rate)) +
  scale_x_continuous(breaks= c(1:16)) +
  ggtitle("Selecting M")
labs(x= "m (mtry) values", y= "OOB error rate")

#m=12 gave me my lowest OOB error rate

final_forest= randomForest(Rslt~.,
                           data= train.df,
                           ntree= 1000,
                           mtry= 12, #lowest OOB error rate
                           importance= TRUE
)


###---- RESULTS----

#ROC curve with positive event "W"
pi_hat= predict(final_forest, test.df, type= "prob")[,"W"]
rocCurve= roc(response= test.df$Rslt, #truth
              predictor= pi_hat,
              levels= c("L", "W")) #positive event second
plot(rocCurve, print.thres= TRUE, print.auc=TRUE)
#With a pi-hat of .492 we achieve
#AUC: .754
#Specificity: .667
#Sensitivity: .789



#---- INTERPRETATION----
#Sensitivity:
#We predict a win 78.9% of the time when the Twins actually win
#Specificity:
#We predict a loss 66.7% of the time when the Twins actually lose

#AUC: Area under the curve is .757, which is an okay value
#pretty much exactly between .5 and 1.
#Around 75.4% of the time my forest will predict my response correctly
#based on my in and out of bag testing

#----GLM MODEL CHOICE AND JUSTIFICATION----

varImpPlot(final_forest, type= 1)
#The MeandecreaseAccuracy plot shows:
#"H"(Hits) is by far the most significant variable
#In terms of predicting correctly
#Homeruns and Walks(BB) are in the next tier of significant variables

#Based on these two plots let's use "H"(Hits), "HR" and "BB"(Walks)

m= glm(Rslt~ H+ BB+ HR, data= Twins_clean2,
       family= binomial(link="logit"))

summary(m)
#AIC= 850.22

#Let's see if we add variables one by one based on the highest
#mean decreased accuracy if AIC goes down

#Add SO(Strikeouts)
m1= glm(Rslt~ H+ BB+ HR+ SO, data= Twins_clean2,
        family= binomial(link="logit"))

summary(m1)
#AIC= 820.56
#This is better

#Add X2B Doubles
m2= glm(Rslt~ H+ BB+ HR+ SO+ X2B, data= Twins_clean2,
        family= binomial(link="logit"))

summary(m2)
#AIC= 816.55
#This is also better

#Add SB(Stolen bases)
m3= glm(Rslt~ H+ BB+ HR+ SO+ X2B+ SB, data= Twins_clean2,
        family= binomial(link="logit"))

summary(m3)
#AIC= 803.25

#Add LOB(Left on Base)
m4= glm(Rslt~ H+ BB+ HR+ SO+ X2B+ SB+ LOB, data= Twins_clean2,
        family= binomial(link="logit"))

summary(m4)
#AIC= 742.35

#Add OPS
m5= glm(Rslt~ H+ BB+ HR+ SO+ X2B+ SB+ LOB+ OPS, data= Twins_clean2,
        family= binomial(link="logit"))

summary(m5)
#AIC= 739.81

m6= glm(Rslt~ H+ BB+ HR+ SO+ X2B+ SB+ LOB+ OPS+ BA, data= Twins_clean2,
        family= binomial(link="logit"))

summary(m6)
#AIC= 734.08

m7= glm(Rslt~ H+ BB+ HR+ SO+ X2B+ SB+ LOB+ OPS+ BA+ Home.Away, data= Twins_clean2,
        family= binomial(link="logit"))

summary(m7)
#AIC= 734.52
#Higher AIC, we don't want this
#We will go with m6 as our final model

#our final model:

#Random Component:
# Rslt i ~ Bernoulli(πi)
#Systematic Component:
# Link Function
#g(πi) = ni = log [πi/(1- πi)
# Linear Predictor:
# ni = β0 + β1*H + β2*BB + β3*HR + β4*SO + β5*X2B + β6*SB + β7*LOB + β8*OPS + β9*BA

#The GLM above is appropriate because Rslti, is a binary variable.
#We use a link function to link our parameter πi, to our linear predictor.
#We cannot do this with the identity link and an OLR model.
#-Since Rslti is binary, the assumption of normality is not met since a normal distribution is continuous
#- The OLR assumption of homoscedasticity is violated since Rslti is a Bernoulli random variable, which has a nonconstant variance.
#-The identity link allows for probabilities less than 0 and greater than 1, which are not possible values for π.



##----GLM INSIGHTS----
summary(m6)

#Coefficient Interpretations

#Intrpret B1: Holding all other variables constant, for every one unit increase in hits, the odds
#of a win increases by a factor of exp(.44425)= 1.5593.

#Intrpret B2: Holding all other variables constant, for every one unit increase in walks, the odds
#of a win increases by a factor of exp(.46436)= 1.591.

#Intrpret B3: Holding all other variables constant, for every one unit increase in home runs, the odds
#of a win decreases by a factor of exp(-.0962)= .90828.

#Intrpret B4: Holding all other variables constant, for every one unit increase in strikeouts, the odds
#of a win decreases by a factor of exp(-.11417)= .8921

#Intrpret B5: Holding all other variables constant, for every one unit increase in doubles, the odds
#of a win increases by a factor of exp(.12399)= 1.132.

#Intrpret B6: Holding all other variables constant, for every one unit increase in stolen bases, the odds
#of a win increases by a factor of exp(.69091)= 1.9955.

#Intrpret B7: Holding all other variables constant, for every one unit increase in runners left on base, the odds
#of a win decreases by a factor of exp(-.48169)= .61774.

#Intrpret B8: Holding all other variables constant, for every .01 unit increase in OPS, the odds
#of a win increases by a factor of exp(17.27745*.01)= 1.1886.

#Intrpret B9: Holding all other variables constant, for every .005 unit increase in batting average, the odds
#of a win decreases by a factor of exp(-50.63114*.005)= .776347.



#Likelihood Confidence Intervals
confint(m6)
#B1: We are 95% confident that the odds of winning increase by a factor between exp(.34255)= 1.4085
#and exp(.551815)= 1.7364 for each one unit increase in hits.

#B2: We are 95% confident that the odds of winning increase by a factor between exp(.342128)= 1.4079
#and exp(.59316)= 1.8097 for each one unit increase in walks.

#B3: We are 95% confident that the odds of winning change by a factor between exp(-.29364)= .7455
#and exp(.10074)= 1.106 for each one unit increase in home runs.

#B4: We are 95% confident that the odds of winning decrease by a factor between exp(-.1812)= .8323
#and exp(-.0489)= .9523 for each one unit increase in strikeouts.

#B5: We are 95% confident that the odds of winning change by a factor between exp(-.037)= .96368
#and exp(.28716)= 1.3326 for each one unit increase in doubles.

#B6: We are 95% confident that the odds of winning increase by a factor between exp(.375)= 1.455
#and exp(1.0253)= 2.788 for each one unit increase in stolen bases.

#B7: We are 95% confident that the odds of winning decrease by a factor between exp(-.6103)= .5432
#and exp(-.3598)= .6978 for each one unit increase in runners left on base.

#B8: #B2: We are 95% confident that the odds of winning increase by a factor between exp(7.2092*.01)= 1.07475
#and exp(27.5794*.01)= 1.31758 for each .01 unit increase in OPS.

#B9: #B2: We are 95% confident that the odds of winning decrease by a factor between exp(-86*.005)= .6505
#and exp(-15.187*.005)= .9269 for each .005 unit increase in batting average.

##---- DATA ENHANCEMENT-----

#Here I want to import the Minnesota Twins schedule for next season
#and use this model to predict their record just using home/away and
#opponents

#I orginally thought that home/away and opponent would be variables in my
#final model, but they weren't and these are the only two we know for next
#season

#So what I think I want to do is create a function that adds up the probability of winning
#If the Twins can hit a certain level for some of the variables in my final model

#I can do their predicted record if they hit their averages and do their predicted level
#If they hit slightly better

#I'll choose the 4 most important variables from the variable important plot

#I'll find their averages and put that into the prediction

mean(Twins_clean2$H)
#8.685028

mean(Twins_clean2$HR)
#1.409605

mean(Twins_clean2$BB)
#3.475989

mean(Twins_clean2$SO)
#8.385593

m_enhance= glm(Rslt~ H+ BB+ HR+ SO+ Opp+ Home.Away, data= Twins_clean2,
               family= binomial(link="logit"))
summary(m_enhance)

new= data.frame(H= 8.685028, HR= 1.409605, BB= 3.475989, SO= 8.385593, Opp= "NYY", Home.Away= "Away")

predict(m_enhance,new)

new1= data.frame(H= 8.685028, HR= 5, BB= 3.475989, SO= 9, Opp= "NYY", Home.Away= "Away")
predict(m_enhance,new1)

exp(-1.134013)/(exp(-1.134013 )+1)


#With a pi-hat of .518

enhance = read.csv("Project 2 prediction.csv", stringsAsFactors = FALSE)
enhance$H = 8.685028
enhance$HR= 1.409605
enhance$BB= 3.475989
enhance$SO= 8.385593

enhance$logodds= predict(m_enhance, enhance)

enhance$probabilities= exp(enhance$logodds)/(exp(enhance$logodds)+1)

summary(enhance$probabilities)
sum(enhance$probabilities)
#Rounded record: 90.74 wins (out of 162)


#Let's run some sensitivities:
#5% increases by variable, holding others constant
enhance$H = 8.685028*1.05
#94.65 wins

enhance$HR= 1.409605*1.05
#95.28 wins

enhance$BB= 3.475989*1.05
#94.59 wins

enhance$SO= 8.385593*1.05
#87.85 wins

#5% decrease
enhance$H = 8.685028/1.05
#86.98

enhance$HR= 1.409605/1.05
#90.07

enhance$BB= 3.475989/1.05
#89.66

enhance$SO= 8.385593/1.05
#93.47
