# ![icons8-olympic-games-rings-32](https://user-images.githubusercontent.com/112760562/218281574-31f2df77-d74d-4f9b-8d30-cdf17899ebf6.png) 120 Years of Olympics History

## 📚 Table of Contents
- [Business Task](#business-task)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions](#case-study-questions)
- [Solution](Solution.md)
  - [A. Data Cleansing Steps](Solution.md#a-data-cleansing-steps)
  - [B. Data Exploration](Solution.md#b-data-exploration)

***

## Business Task
The Olympics comprises all the Games from Athens 1986 to Rio 2016. The Olympics is more than just a quadrennial multi-sport world championship. It is a lense through which to understand global history, including shifting geopolitical power dynamics, women’s empowerment, and the evolving values of society. 

Through this dataset, we want to gain insights into the performance of different countries and athletes in the Olympics, and understand trends and patterns in medal distribution by sport and gender. 

## Entity Relationship Diagram
For this case study, the dataset is download from [Kaggle](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results). 

![image](https://user-images.githubusercontent.com/112760562/218281466-2ef642a3-852b-4d59-9eb0-000aeb39c3e2.png)

Here are some futher details about the dataset: 
- There are only two tables in the dataset, i.e. `athlete_events` and `noc_regions`. 
- Each row in `athlete_events` corresponds to an individual athlete competing in an individual Olympic event. `ID` is the unique number for each athlete. 
- `Name`, `Sex`, `Age`, `Height` and `Weight` contains information regarding the athlete. `Height` is measured in centimeters and `Weight` in kilograms. 
- `NOC` represents National Olympic Committee 3-letter code.
- `Games` include the Year and Season when the event was held. 
- `Medal` contains the information weather the athelete won any medals of not. 
- `noc_regions` contains contry full name corresponding to the three letter `NOC`. 

10 random rows are shown in the table output below from `athlete_events`:
![image](https://user-images.githubusercontent.com/112760562/218299879-209be3c3-937d-41d8-989e-022dd7f6d06d.png)

## Case Study Questions
1. Which countries have won the most medals over the years?
2. What is the distribution of medals by sport?
3. Which sports have the highest number of participating countries?
4. Has there been an increase or decrease in the number of participating countries over the years?
5. What is the medal distribution by gender?
6. Which athletes have won the most medals in a single Olympic games?
7. What is the distribution of gold, silver, and bronze medals over the years?
8. Which countries have consistently performed well in the Olympics?
9. What is the trend in the medal count of a particular country over the years?
10. What is the average age of medal-winning athletes in different sports?

View my solution [here](Solution.md).
***
