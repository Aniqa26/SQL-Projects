# 120 Years of Olympics History

## A. Data Cleansing Steps
The dataset contains two files in `.csv` format. While importing the data into databse, ensure the columns have the right data type. By analysing the  csv files, I came to the following conclusions: 
- `ID`, `Age`, `Height`, `Weight` and `Year` columns should have int datatype. Rest of the fields should be string. 
- `Age`, `Height` and `Weight` have "NA" values. NA represents that the information is not available for the record. These values should be replaced for the successful conversion of column values to int. 
- Ensure that no "NA" value is present in any other column as well. Remove those values and leave the cell blank.

Since the files are in `.csv` format, by default csv is comma delimated. While importing a comma delimated csv file, any comma that occurs in the file corresponds to the value in the next column. This can cause some trouble if there is any valid value of the column having a comma in it. The dataset have some values of this nature and hence the data import failed multiple times. 

After cleaning the NA values from the dataset and making sure there are no other visible anomalies in the data, save the file as `.xlxs` file. Once done, change the delimeter setting for `.csv` file and replace it with a semi-colon. Finally, save the `.xslx` file as `.csv` now and import the data into the database. 

For this case study, I am working with SQL databse and I used the **SQL Server Import Export Wizard** to load data through flat file data source on my local SQL Server Database. 

Here is a snippet of `athlete_events` table after data cleansing is performed on it. 
![image](https://user-images.githubusercontent.com/112760562/218299879-209be3c3-937d-41d8-989e-022dd7f6d06d.png)

***
## B. Data Exploration
### 1. Which countries have won the most medals over the years?
- Group the data by countries to find the count. Make sure to exlcude the records with no medals won. 
- There are 136 countries that have won any medal in the olympics. To refine the analysis, select to top 5 to see the highest ones. 

````sql
SELECT TOP 5 
  nr.Country Country,
  COUNT(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
  COUNT(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
  COUNT(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon,
  COUNT(ID) TotalMedalsWon
FROM athlete_events ae
INNER JOIN noc_regions nr
  ON nr.NOC = ae.NOC
WHERE Medal != ''
GROUP BY nr.Country
ORDER BY TotalMedalsWon DESC
````
![image](https://user-images.githubusercontent.com/112760562/218303846-b5a2e5c1-3e7e-480b-9e02-739b792dc76b.png)

### 2. What is the distribution of medals by sport?
````sql
DECLARE @TotalMedals float = (SELECT
  COUNT(ID) MedalsCount
FROM athlete_events
WHERE Medal != '')

SELECT
  Sport,
  COUNT(ID) MedalsCount,
  ROUND((COUNT(ID) / @TotalMedals) * 100, 2) Percentage
FROM athlete_events
WHERE Medal != ''
GROUP BY Sport
ORDER BY MedalsCount DESC
````
![image](https://user-images.githubusercontent.com/112760562/218303877-3c644ffb-6368-4bdf-9f64-78fb0695bd23.png)

### 3. Which sports have the highest number of participating countries?
````sql
SELECT TOP 10
  ae.Sport,
  COUNT(DISTINCT nr.Country) ParticipatingCountries,
  COUNT(ID) NoOfParticipants
FROM athlete_events ae
INNER JOIN noc_regions nr
  ON nr.NOC = ae.NOC
GROUP BY ae.Sport
ORDER BY NoOfParticipants DESC
````
![image](https://user-images.githubusercontent.com/112760562/218303926-7f52451b-d6bc-4157-9e00-2763a9436e2a.png)

### 4. Has there been an increase or decrease in the number of participating countries over the years?
````sql
SELECT
  ae.Year,
  COUNT(DISTINCT nr.Country) ParticipatingCountries,
  COUNT(ID) NoOfParticipants
FROM athlete_events ae
INNER JOIN noc_regions nr
  ON nr.NOC = ae.NOC
GROUP BY ae.Year
ORDER BY Year ASC
````
![image](https://user-images.githubusercontent.com/112760562/218303963-90aa06c4-dd29-416b-ba8a-da448ab7a9f5.png)

The trend will be better visualized in a graph over time.  

### 5. What is the medal distribution by gender?
- Calculate the total # of medals and save it in a variable. 
- Use that variable to calculate percenatges of medals won by gender 

````sql
DECLARE @TotalMedals float = (SELECT
  COUNT(ID) MedalsCount
FROM athlete_events
WHERE Medal != '')

SELECT
  Gender,
  COUNT(ID) MedalsCount,
  ROUND((COUNT(ID) / @TotalMedals) * 100, 2) Percentage
FROM athlete_events
WHERE Medal != ''
GROUP BY Gender
ORDER BY MedalsCount DESC
````
![image](https://user-images.githubusercontent.com/112760562/218304095-f3fa962f-6553-4153-b0f7-f904c5990013.png)

### 6. Which athletes have won the most medals in a single Olympic games?
- Use `DENSE_RANK()` instead of `ROW_NUMBER()` to the athletes having same number of medals. If `ROW_NUMBER()` was used, only 1 row would be returned. 

````sql
SELECT
  ID,
  Name,
  Games,
  MedalsWon
FROM (SELECT
  DENSE_RANK() OVER (ORDER BY COUNT(Id) DESC) Position,
  ae.Id,
  ae.Name,
  ae.Games,
  COUNT(Id) MedalsWon
FROM athlete_events ae
WHERE Medal != ''
GROUP BY ae.Id,
         ae.Name,
         ae.Games) m
WHERE Position = 1
````
![image](https://user-images.githubusercontent.com/112760562/218304125-6e0383dc-90f3-45b1-957c-cb15696d1958.png)

### 7. What is the distribution of gold, silver, and bronze medals over the years?
````sql
SELECT
  Year,
  COUNT(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
  COUNT(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
  COUNT(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon
FROM athlete_events
WHERE Medal != ''
GROUP BY Year
ORDER BY Year
````
![image](https://user-images.githubusercontent.com/112760562/218304260-87c8618f-8093-46cb-85ff-0204d069be02.png)

A line chart representing the Gold, Silver and Bronze medals won over time should be used to visualize this trend. 

### 8. Which countries have consistently performed well in the Olympics?
- Use `ROW_NUMBER()` to find top 5 countries of every year olympics. 
- Find out which country was consistently present in top rankings. 

````sql
SELECT TOP 5
  Country,
  COUNT(Year) InTop5
FROM (SELECT
  ROW_NUMBER() OVER (PARTITION BY Year ORDER BY COUNT(ID) DESC) Ranking,
  nr.Country Country,
  Year,
  COUNT(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
  COUNT(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
  COUNT(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon,
  COUNT(ID) TotalMedalsWon
FROM athlete_events ae
INNER JOIN noc_regions nr
  ON nr.NOC = ae.NOC
WHERE Medal != ''
GROUP BY nr.Country,
         Year) m
WHERE Ranking <= 5
GROUP BY Country
ORDER BY InTop5 DESC
````
![image](https://user-images.githubusercontent.com/112760562/218304319-dc1e04a9-e69c-46c2-95e4-c9bc3aee42cf.png)

### 9. What is the trend in the medal count of a particular country over the years?
- Added a where clause to display records of a specific country and visualize the trend. 

````sql
SELECT
  nr.Country Country,
  Year,
  COUNT(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
  COUNT(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
  COUNT(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon,
  COUNT(ID) TotalMedalsWon
FROM athlete_events ae
INNER JOIN noc_regions nr
  ON nr.NOC = ae.NOC
WHERE Medal != '' and Country = 'Colombia'
GROUP BY nr.Country,
         Year
ORDER BY Country, Year
````
![image](https://user-images.githubusercontent.com/112760562/218304452-f0c0b30c-a0b7-494f-adda-ad7e4904f17a.png)

### 10. What is the average age of medal-winning athletes in different sports?
````sql
SELECT
  Sport,
  COUNT(ID) MedalsWon,
  ROUND(AVG(CONVERT(float, Age)), 2) AvgAgeOfAtheletes
FROM athlete_events
WHERE Medal != ''
GROUP BY Sport
ORDER BY MedalsWon DESC
````
![image](https://user-images.githubusercontent.com/112760562/218304493-728e845e-fc29-46eb-b05a-d87c5adac27c.png)

Find the complete SQL syntax [here](SQL%20Syntax/Olympics%20History.sql). 
