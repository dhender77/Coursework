---
title: "Analyst Intern, Data Science & Solutions Project"
output: html_document
author: "Danny Henderson"
date: "10/15/2022"
---

# Introduction  

You will work your way through this R Markdown document, answering questions as you go along. Please begin by adding your name to the "author" key in the YAML header. When you"re finished with the document, come back and type your answers into the answer key at the top. Please leave all your work below and have your answers where indicated below as well. Please note that we will be reviewing your code so make it clear, concise and avoid extremely long printouts. Feel free to add in as many new code chunks as you"d like.

Remember that we will be grading the quality of your code and visuals alongside the correctness of your answers. Please try to use the tidyverse as much as possible (instead of base R and explicit loops.)  

**Note:**    

**Throughout this document, the `season` column represents the year each season started. For example, the 2015-16 season will be in the dataset as 2015. For most of the rest of the project, we will refer to a season by just this number (e.g. 2015) instead of the full text (e.g. 2015-16). This nomenclature is used for the playoffs too, so if we say "the 2015 playoffs," we"re referring to the playoffs from the 2015-16 season, which actually happened in 2016. (Sorry, I know this is a little confusing.)**   

# Answers    

**Question 1:** Please list the team(s) and last playoffs appearance below in the document.  
**Question 2:** XX.X%        
**Question 3:** XX.X%  
**Question 4:** X.X Years  
**Question 5:** Plotting question, put answer below in the document.     
**Question 6:** Written question, put answer below in the document.    
**Question 7:** EAST: XX.X%, WEST: XX.X%      
**Question 8:** Written question, put answer below in the document.    
**Question 9:** Written question, put answer below in the document.   
**Question 10:** X Stints of length(s) ___.  
**Question 11:** Mean: X.X, Median: Y.Y    
**Question 12:** East: X.X, West: Y.Y   
**Question 13:** Plotting and written question, please put your answers to (a) and (b) below in the document.  
**Question 14:** Written question, put answer below in the document.  

rm(list= ls())
```{r}
library(tidyverse)
results <- read.csv(choose.files(), header=T)
team_conferences <- read.csv(choose.files(), header=T)
```


# Making the Playoffs  

If a team falls out of the playoffs, how many seasons are they likely to miss the playoffs before making it back? We"re going to investigate this question through the next several questions.

### Question 1  

**QUESTION:** Are there any teams that are currently on an active streak of not making the playoffs that started in **2016-17** or earlier? If so, list the team(s) and the last time each team made the playoffs.


```{r}
streak = subset(results[1:3], results$made_playoffs == "FALSE" & season >= 2016)
print(streak)
table(streak$team)
#any teams with observations==6 are in streak
streak1 = subset(results[1:3], results$team == "CHA" & results$made_playoffs == "TRUE"| results$team == "SAC" & results$made_playoffs == "TRUE")

```

**ANSWER 1: CHA(2015), SAC(2005)**   

### Question 2  

**QUESTION:** Starting from the 2005 season (the earliest season in the dataset), what percentage of teams who make the playoffs make the playoffs again in the following season? Please give your answer in the format XX.X%.  

   

next_season_playoffs = ifelse(results$season == "2021", "NA", results$made_playoffs[-1])
results$next_season_playoffs = next_season_playoffs
playoffs = subset(results[c(1:3,23)], made_playoffs == "TRUE" & season != "2021")
sum(playoffs$next_season_playoffs== "TRUE")/nrow(playoffs)

**ANSWER 2: 73.8%** 

### Question 3  

**QUESTION:** Starting from the 2005 season (the earliest season in the dataset), what percentage of teams who miss the playoffs make the playoffs in the following season? Please give your answer in the format XX.X%.  

playoffs_no = subset(results[c(1:3,23)], made_playoffs == "FALSE" & season != "2021")
sum(playoffs_no$next_season_playoffs== "TRUE")/nrow(playoffs_no)

**ANSWER 3: 29.9%**  


## Data Cleaning Interlude  

For the next part of the analysis, we're going to consider every team/season combination as a starting point (whether or not the team made the playoffs in that season) to begin to answer the question of how long teams tend to need to wait before making the playoffs.   

This will require some significant data cleaning and wrangling that will affect several future questions, so please read the specifications and examples carefully.  


  - Like the starting dataset, your clean dataset will have one row per team/season. We will only include starting points from 2005 to 2015. This is to give most teams the chance to have made it back to the playoffs at least once again after their 2015 row so that we don"t need to deal with many ongoing streaks.  
    - This means that your clean dataset should have 330 rows (30 teams over 11 seasons).  
  - Your dataset should have a column called `missed_seasons` which represents the number of times *after* the start/row season that the team missed the playoffs.  
      - Regardless of where a team finishes in the year corresponding to a row, if that teams makes the playoffs in the following year, they will have `missed_seasons` = 0. For example, the Bucks missed the playoffs in 2013, but their 2013 row will still have `missed_seasons` = 0 because they made the playoffs in 2014. However, the Bucks 2012 row would have `missed_seasons` = 1 due to the miss in 2013.     
      - The Hornets missed the playoffs in 2010, 2011, and 2012 and then made the playoffs in 2013. This means that the 2009 CHA row should have `missed_seasons` = 3.  
  - In the event that a team has *not* made the playoffs in 2016 through 2021, you will need to make an assumption about their wait time. Let"s be charitable and assume they will make the playoffs next season.  
      - The 2015 row for a team that has not made the playoffs in 2016 onward will have `missed_seasons` = 6, which will turn out to be correct if they make the playoffs next season in 2022. (miss in "16, "17, "18, "19, "20, "21).   
      
**There are many possible ways to create this dataset. If you can, please do this data cleaning wihtout using nested for loops. We will consider the quality of your code alongside just getting the answers correct while evaluating your project.**  


```{r}

#create new rows that reference each number of season where playoffs were missed, with a max of 16 (SAC)
#very sloppy but couldn't figure out any other way without
#nested for loop
#I copied and pasted this multiple times... did not type all of this out

next_season_playoffs1 = results$next_season_playoffs
next_season_playoffs1[next_season_playoffs == "NA"]= "TRUE"
results$next_season_playoffs1 = next_season_playoffs1

next_season_playoffs2 = ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs1[-1])
results$next_season_playoffs2 = next_season_playoffs2

next_season_playoffs3 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs2[-1])
results$next_season_playoffs3 = next_season_playoffs3

next_season_playoffs4 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs3[-1])
results$next_season_playoffs4 = next_season_playoffs4

next_season_playoffs5 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs4[-1])
results$next_season_playoffs5 = next_season_playoffs5

next_season_playoffs6 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs5[-1])
results$next_season_playoffs6 = next_season_playoffs6


next_season_playoffs7 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs6[-1])
results$next_season_playoffs7 = next_season_playoffs7

next_season_playoffs8 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs7[-1])
results$next_season_playoffs8 = next_season_playoffs8

next_season_playoffs9 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs8[-1])
results$next_season_playoffs9 = next_season_playoffs9

next_season_playoffs10 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs9[-1])
results$next_season_playoffs10 = next_season_playoffs10

next_season_playoffs11 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs10[-1])
results$next_season_playoffs11 = next_season_playoffs11

next_season_playoffs12 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs11[-1])
results$next_season_playoffs12 = next_season_playoffs12

next_season_playoffs13 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs12[-1])
results$next_season_playoffs13 = next_season_playoffs13

next_season_playoffs14 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs13[-1])
results$next_season_playoffs14 = next_season_playoffs14

next_season_playoffs15 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs14[-1])
results$next_season_playoffs15 = next_season_playoffs15

next_season_playoffs16 =  ifelse(results$season %in% c("2021"), "TRUE", results$next_season_playoffs15[-1])
results$next_season_playoffs16 = next_season_playoffs16



missed_seasons = ifelse(results$next_season_playoffs,0, ifelse(results$next_season_playoffs2, 1, ifelse(results$next_season_playoffs3, 2, ifelse(results$next_season_playoffs4, 3, ifelse(results$next_season_playoffs5, 4, ifelse(results$next_season_playoffs6, 5, 
ifelse(results$next_season_playoffs7, 6,
ifelse(results$next_season_playoffs8, 7, 
ifelse(results$next_season_playoffs9, 8,
ifelse(results$next_season_playoffs10, 9,
ifelse(results$next_season_playoffs11, 10,
ifelse(results$next_season_playoffs12, 11,
ifelse(results$next_season_playoffs13, 12,
ifelse(results$next_season_playoffs14, 13,
ifelse(results$next_season_playoffs15, 14,
ifelse(results$next_season_playoffs16, 15,16 ))))))))))))))))
results$missed_seasons = missed_seasons

results_clean = subset(results[-c(23:39)], results$season <= 2015)
print(results_clean$missed_seasons)
table(results_clean$missed_seasons)
```

### Question 4  

**QUESTION:** For a team that misses the playoffs, what is the average number of years they will need to wait to make it back? For example, if the only two teams in our sample were the 2010 Hornets and the 2011 Nets, the average would be 1 more missed playoffs season (CHA missed two more times in "11 and "12, BKN missed 0 more times by making it in "12). Please give your answer to one decimal place.  

```{r}
missed_playoffs = subset(results_clean, results_clean$made_playoffs == "FALSE")
mean(missed_playoffs$missed_seasons)

```

 **ANSWER 4:** 2.6 Years    


### Question 5  


**QUESTION:** Please make a presentation quality **ggplot** that shows off something interesting about the dataset you just created.  


**ANSWER 5:**  

```{r}
library(ggplot2)
ggplot(data=results_clean)+
  geom_histogram(aes(x= net_rtg, fill = made_playoffs), binwidth = 1)+
  ggtitle("Histogram of Net Rating")+
  labs(x= "Net Rating", y= "Seasons")
```

### Question 6  


**QUESTION:** Write up to four sentences describing any takeaways from the plot you just made.  

**ANSWER 6: This plots shows a distribution of net ratings and fills it based on whether or not the team made the playoffs. An interesting takeaway is that there was a higher proportion of teams with a net rating below 0 that made the playoffs than teams with a net rating above 0 that didn't. The graph also shows that a vast majority of teams make the playoffs if they just have a net rating above 0.**  

### Question 7   

**QUESTION:**  Fit a logistic regression model using your cleaned dataset to predict the probability making the playoffs next season (ie `missed_seasons` = 0) from `net_rtg` and `conference`. That is, given a team"s net rating in one season, what are the odds they make the playoffs the following season? Once you"ve fit the model, give the predicted probability to one decimal place that a team with a net rating of -2 from the East and the West will make the playoffs next season.  

```{r}
data1 = merge(x = results_clean, y = team_conferences, by = "team") #joins the conference dataset to the results one
next_season_binary = ifelse(data1$missed_seasons == 0, 1,0)#1 is made playoffs
data1$next_season_binary = next_season_binary
m0= glm(formula = next_season_binary ~ net_rtg + conference , family= binomial(link="logit"), data = data1)
summary(m0)
(exp(.459+.3118*-2)/(exp(.459+.3118*-2)+1))
(exp(.459+.3118*-2-.5868)/(exp(.459+.3118*-2-.5868)+1))


```

**ANSWER 7:**  

EAST: 45.9%  
WEST: 32.1% 


### Question 8  


**QUESTION:** In no more than 4 sentences, please explain what the difference in predictions (East vs West) from question 8 means. Assume you"re talking to a nontechnical member of the organization and are framing it as how this disparity might impact a Western conference team"s strategic planning.  

**ANSWER 8: A team in the east conference with a net rating of -2, has a 45.9% chance of making the playoffs the following season. Whereas a team in the west conference with a net rating of -2 has a 32.1% chance of making the playoffs the following season**  

### Question 9   

So far, we"ve considered *every* season as a valid starting season. We need to be careful about how we interpret our results, as each "stint" outside the playoffs counts multiple times. For example, recall that the 2009 Hornets made the playoffs, had a three year stint outside the playoffs, and then made the playoffs again. Using our current methodology, we"re counting that as a 3 year gap (starting from 2009), a 2 year gap (2010), a 1 year gap (2011), and a 0 year gap (2012, then making the playoffs the following season).  

Another way to look at this data is to check the length of each stint. In this case the 2009-2013 Hornets would contribute just one datapoint corresponding to a 3 year stint outside the playoffs. To be clear, each time a team falls outside of the playoffs will now constitute just one datapoint, and the number we"re interested in is the number of consecutive seasons outside the playoffs. While 0 was a possible value for `missed_seasons`, each of these stint lengths should be at least 1.  

**QUESTION:** In no more than 3 sentences, please discuss the difference between these two approaches. What types of questions can we answer with each approach?  

**ANSWER 9: In the n-year stint approach, we can only look at the last season the team made the playoffs before they missed. This excludes any data from a season where the team didn't make the playoffs the year before. The other approach counts each time a team misses the playoffs as a separate, independent event. **

**With the n-year approach, you can see what trends lead up to the longest playoff droughts. You can also look at droughts as a singular event. Thus, the drought can be graded and analyzed as a whole. With the other approach, each season is an independent event, so we can look at data on the assumption that the previous season's data isn't correlated. Could also conduct time-series to see the effect of time**  



### Question 10  

Define a "stint" outside the playoffs as a continuous group of seasons in which a team does not make a playoffs appearance. For example, if a given team lmade the playoffs, then missed, missed, missed, made, missed, and then made the playoffs again, they would have two stints outside the playoffs, of length 3 and 1 seasons respectively. 

**QUESTION:** How many stints outside the playoffs have the Phoenix Suns had between 2005 and 2021? What were the lengths of these stints?  

```{r}
suns = subset(data1, team == "PHX")
table(suns$missed_seasons)
```

**ANSWER 10:**  

2 Stints, of length(s) _1 and 10__.  


## Data Cleaning Interlude 2  

Please create the "stint" dataset described above. 

In the event that a team didn"t make the playoffs in 2005, **do not count** that streak of misses as a stint. These stints would not accurately estimate the average stint length, since they may have started several years before 2005. For example, CHA missed the playoffs in 2005 through 2008. This will not contribute to a stint of length 4. There should be only two CHA stints in your dataset, one of length 3 when they missed the playoffs in 2010-2012, and one of length 1 when they missed the playoffs in 2014.  

As before, please only consider stints that started in 2015 or earlier to avoid needing to deal with several short ongoing streaks of missing the playoffs. For example, CHA"s ongoing streak of missing the playoffs (starting in 2016) should not be included. Also as before, be charitable and assume that any ongoing stints that started 2015 or earlier will end next season. For example, if a team were to make the playoffs in 2014, then miss from 2015 to 2021, they would have missed 7 consequtive playoffs so far. We will assume that they make the playoffs next season, and thus their final stint outside the playoffs is 7 seasons long.   

```{r}

stints = data.frame() 

                
for (i in 2:nrow(data1)){
  if(!(data1[i,"season"] == 2005 & data1[i,"made_playoffs"] == "FALSE") & data1[i, "missed_seasons"] != 0 & data1[i-1, "missed_seasons"] == 0 & data1[i,"season"] != 2015){stints = rbind(stints,data1[i,c("season","team","missed_seasons","conference")])}
}
```

### Question 11  

**QUESTION:** To the nearest decimal, please give the mean and median length of these stints.  

**ANSWER 11:** 
```{r}
mean(stints$missed_seasons)
median(stints$missed_seasons)
```

Mean: 3.4 
Median: 3     

### Question 12  

**QUESTION:** To the nearest decimal, please give the mean length of these stints from **each conference.**    

**ANSWER 12:** 

```{r}
east_stints = subset(stints, stints$conference == "East")
mean(east_stints$missed_seasons)
west_stints = subset(stints, stints$conference == "West")
mean(west_stints$missed_seasons)
difference = abs(mean(east_stints$missed_seasons) - mean(west_stints$missed_seasons))
```

East: 2.9    
West: 4.1    

### Question 13  

We are going to investigate whether it’s possible that the difference between conferences you found in the previous question could be reasonably explained by randomness. Sample size might be a concern as we"re looking at a relatively small total number of stints. To do this, you will perform a permutation test.

First, compute the difference in average stint length between the West and the East. If your answer to the last question was West: 5 years, East: 2 years, then this difference would be 3 years.  

For each of 10,000 iterations, randomly **reorder** the conference labels on each stint so that in each iteration, a given stint outside the playoffs might be either East or West. For example, in a given iteration, the 2010 to 2012 Hornets stint might be labeled as either East or West. For each iteration, calculate the difference in averages similar to the one you computed above. Save all 10,000 differences in a vector or dataframe.  



**PART (a):** Make a ggplot comparing these 10,000 randomized differences to the difference you observed in reality.   

**ANSWER 13 (a):**  

```{r}
conference = stints$conference
missed_seasons = stints$missed_seasons



#Permutation test
permutation.test = function(conference, missed_seasons, n){
  distribution=c()
  result=0
  for(i in 1:n){
    distribution[i]=diff(by(missed_seasons, sample(conference, length(conference), FALSE), mean))
  }
  result=sum(abs(distribution) >= abs(difference))/(n)
  return(list(result, distribution))
}

test1 = permutation.test(conference, missed_seasons, 10000)

hist(test1[[2]], breaks=50, col='blue', main="Permutation Distribution", las=1, xlab='')




```

**PART (b):** What do you conclude from your permutation test and plot? Please answer in no more than 3 sentences.  

```{r}

```

**ANSWER 13 (b):This shows us that there isn't a significant difference between playoff drought lengths between the East and the West. The graph is pretty normally distributed around 0.**  


# Modeling  

### Question 14  

**QUESTION:**  

In this question you will fit a model using team statistics to predict how successful the team will be the following season. As opposed to the logistic regression model you fit earlier in question 7, you now have the freedom to fit any type of model using any of the included variables. Please do not bring in any external data sources, use only what we"ve provided.

*Note:* The team statistic variables come from basketball reference. The included data dictionary will give a brief explanation of what each stat represents.  

**Part (a):** Fit a model to predict the variable `next_season_win_pct`.  

```{r}
#Let's look for multicollinearity
cor(cbind(data1$net_rtg, data1$wins, data1$age, data1$strength_of_schedule, data1$three_pt_pct, data1$two_pt_pct, data1$true_shooting_pct, data1$efg, data1$tov_rate, data1$oreb, data1$dreb, data1$free_throw_rate, data1$def_three_pt_pct, data1$def_two_pt_pct, data1$def_efg, data1$def_tov_rate, data1$def_free_throw_rate, data1$missed_seasons))
#wins and net_rating are suspicious
#true_shooting_pct and efg
#two_pt_pct with true shooting and efg
#def_two_pt_pct and def_efg

test = lm(data1$next_season_win_pct ~ data1$net_rtg+ data1$wins+ data1$age+ data1$strength_of_schedule+ data1$three_pt_pct+ data1$two_pt_pct+ data1$true_shooting_pct+ data1$efg+ data1$tov_rate+ data1$oreb+ data1$dreb+ data1$free_throw_rate+ data1$def_three_pt_pct+ data1$def_two_pt_pct+ data1$def_efg+ data1$def_tov_rate+ data1$def_free_throw_rate+ data1$missed_seasons)

library(car)
vif(test)
#anything above 10 has severe multicollinearity
#net_rtg, wins, three_pt_pct, two_pt_pct, three_pt_pct, efg, def_three_pt_pct, def_two_pt_pct, def_efg, def_tov_rate
#let's try taking net_rtg, efg, true_shooting, def_efg out

test2 = lm(data1$next_season_win_pct ~ data1$wins+ data1$age+ data1$strength_of_schedule+ data1$three_pt_pct+ data1$two_pt_pct+ data1$tov_rate+ data1$oreb+ data1$dreb+ data1$free_throw_rate+ data1$def_three_pt_pct+ data1$def_two_pt_pct+ data1$def_tov_rate+ data1$def_free_throw_rate+ data1$missed_seasons)
vif(test2)
#wins is only variable over 10 now, all other variables are below 3.5
#regardless I'm not including missed_seasons, this value already tells whether or not the team made the playoffs the next season, which is a large indicator of win percentage


#now I'll include the character variables and do a stepwise regression:
model0 = lm(data1$next_season_win_pct ~ 1)
model1= lm(data1$next_season_win_pct ~ data1$age+ data1$strength_of_schedule+ data1$three_pt_pct+ data1$two_pt_pct+ data1$tov_rate+ data1$oreb+ data1$dreb+ data1$free_throw_rate+ data1$def_three_pt_pct+ data1$def_two_pt_pct+ data1$def_tov_rate+ data1$def_free_throw_rate + data1$made_playoffs + data1$conference)
step(model0, scope=list(lower=model0, upper=model1, direction ="both"))

step_model = lm(data1$next_season_win_pct ~ data1$made_playoffs + data1$def_two_pt_pct + data1$two_pt_pct + data1$conference + data1$strength_of_schedule + data1$age + data1$tov_rate + data1$def_tov_rate + data1$oreb + data1$three_pt_pct + data1$dreb)
summary(step_model)
#most of the variables here are statistically significant at the a = .05 level
#stepwise created this model based on getting the lowest AIC value
#R square and adjusted R squared values are pretty low
#Let's see what happens if we remove the variables that aren't statistically significant
#residual standard error is .1212
#R2 and R2A are .4148 and .3945
step_model1 = lm(data1$next_season_win_pct ~ data1$made_playoffs + data1$def_two_pt_pct + data1$two_pt_pct + data1$conference + data1$strength_of_schedule + data1$tov_rate + data1$def_tov_rate + data1$oreb)
summary(step_model1)
#remove def_tov_rate

step_model2 = lm(data1$next_season_win_pct ~ data1$made_playoffs + data1$def_two_pt_pct + data1$two_pt_pct + data1$conference + data1$strength_of_schedule + data1$tov_rate + data1$oreb)
summary(step_model2)
#remove tov_rate

step_model3 = lm(data1$next_season_win_pct ~ data1$made_playoffs + data1$def_two_pt_pct + data1$two_pt_pct + data1$conference + data1$strength_of_schedule+ data1$oreb)
summary(step_model3)
#after removing 5 variables:
#R2 went from .4148 to .3883, R2A went from .3945 to .3769
#Residual standard error went from .1212 to .123
#This is definitely a better model than the original stepwise choice because it's simpler.

#the original model with everything had:
#R2 = .4237
#R2A = .3981
#Residual standard error = .1209
#14 variables

#Step model 3 is our final model
```

**Part (b):**  

Explain your model to a member of the front office. What are your takeaways? Please answer in no more than 4 sentenes.  

We can create a model using six statistics from the prior season to predict the winning percentage of a team the following season.These six statistics are two point percentage, two point percentage allowed, strength of schedule, conference, offensive rebounding rate, and whether or not they made the playoffs the prior season. This tells us that those six statistics are the most significant in determining team success for the following season.








