rm(list=ls())


thunder =read.csv(choose.files(), header=T, stringsAsFactors = TRUE)
head(thunder)

thunder = transform(thunder, shot_distance = sqrt(x^2 + y^2))
head(thunder)

thunder = transform(thunder, shot_type = ifelse(abs(x)<22 & shot_distance< 23.75, "2PT",
                                                ifelse(abs(x)>=22.0 & y<= 7.8,"C3", "NC3")))
print(thunder)

thunder = transform(thunder, points = ifelse(fgmade== 0, 0, 
                                             ifelse(fgmade== 1 & shot_type== "2PT",2,3)))
print(thunder)
attach(thunder)

teamA = subset(thunder,team == "Team A")

teamB = subset(thunder, team == "Team B")

                    
shot_distributionA = table(teamA$shot_type)/nrow(teamA)
print(shot_distributionA)
#shot distribution: 2PT 69.29%, C3 6.43%, NC3 24.29%

shot_distributionB = table(teamB$shot_type)/nrow(teamB)
print(shot_distributionB)
#shot distribution: 2PT 66.96%, C3 5.36%, NC3 27.68%




#aggregate is sumif function, sum is countif function
.5*aggregate(points ~ shot_type == "2PT", data = teamA, sum)/sum(teamA$shot_type == "2PT")
#TeamA 2PT eFG% = 48.97%
.5*aggregate(points ~ shot_type == "NC3", data = teamA, sum)/sum(teamA$shot_type == "NC3")
#TeamA NC3 eFG% = 46.32%
.5*aggregate(points ~ shot_type == "C3", data = teamA, sum)/sum(teamA$shot_type == "C3")
#TeamA C3 eFG% = 75.00%

.5*aggregate(points ~ shot_type == "2PT", data = teamB, sum)/sum(teamB$shot_type == "2PT")
#TeamB 2PT eFG% = 44.67%
.5*aggregate(points ~ shot_type == "NC3", data = teamB, sum)/sum(teamB$shot_type == "NC3")
#TeamB NC3 eFG% = 50.81%
.5*aggregate(points ~ shot_type == "C3", data = teamB, sum)/sum(teamB$shot_type == "C3")
#TeamB C3 eFG% = 50.00%












