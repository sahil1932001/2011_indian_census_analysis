# 2011_indian_census_analysis

### Problem Statement : We have to Analyse Indian Census which was conducted in 2011 Using SQL and visualize it using Tableau.

We have two csv files containg data. In first dataset we have State, district ,Growth ,sex_ratio and Literacy rate and In second dataset we have State, district ,Area and Population.

So we perform different different task to analyse the data in SQL. we checked total population of india, average sex ratio by states, average literacy rate by state, top 3 states having highest growth, top 3 and bottom 3 states in Literacy in single table, extract count of male and female using  mathematical equation, calculating total literacy rate(percentage of student who is educated) by states and many more. you can have a look at SQL file.

after this analysis part know i load the data in tableau for making interactive visualization.

I made previous population of male count and female count also literated people and illiterated people counts using Calculated Field.

In first Dashboard we shown state wise population using bubble chart and difference between previous population and current population Using Area Chart.
Total 20% population increased in india from previous census to current census.
Nagaland has highest population percent in current census.

![d1](https://user-images.githubusercontent.com/95639758/204150578-756b6148-fda6-47e4-84a5-b40080eec2c4.png)

In Second Dashboard ,We shown statewise Literacy rate Using Bar Chart .Kerala has the highest Literacy count and india's Literacy rate is 72%.

![d2](https://user-images.githubusercontent.com/95639758/204151985-7d5e4e90-d840-43c9-9bac-12cc46ee36e5.png)

In Third Dashboard ,we analyzed Area_Per_Popualtion.for almost every state Area per Population has reduced since population is increasing.

![d3](https://user-images.githubusercontent.com/95639758/204152066-973f62c4-f22a-47b6-9b40-1458a7987b68.png)


