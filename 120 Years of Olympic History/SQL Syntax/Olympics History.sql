USE Olympic_History

--1. Which countries have won the most medals over the years?
Select nr.Country Country,
Count(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
Count(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
Count(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon,
Count(ID) TotalMedalsWon
from athlete_events ae
inner join noc_regions nr on nr.NOC = ae.NOC
Where Medal != ''
group by nr.Country
order by TotalMedalsWon desc

--2. What is the distribution of medals by sport?

DECLARE @TotalMedals float = (Select Count(ID) MedalsCount from athlete_events Where Medal != '')

Select Sport, Count(ID) MedalsCount, Round((Count(ID)/@TotalMedals)*100, 2) Percentage
from athlete_events
Where Medal != ''
group by Sport
Order by MedalsCount desc

--3. Which sports have the highest number of participating countries?

Select top 10 ae.Sport, Count(distinct nr.Country) ParticipatingCountries, Count(ID) NoOfParticipants
from athlete_events ae 
inner join noc_regions nr on nr.NOC = ae.NOC
group by ae.Sport
Order by NoOfParticipants desc

--4. Has there been an increase or decrease in the number of participating countries over the years?
Select ae.Year, Count(distinct nr.Country) ParticipatingCountries, Count(ID) NoOfParticipants
from athlete_events ae 
inner join noc_regions nr on nr.NOC = ae.NOC
group by ae.Year
Order by Year asc

--5. What is the medal distribution by gender?
--DECLARE @TotalMedals float = (Select Count(ID) MedalsCount from athlete_events Where Medal != '')
Select Gender, Count(ID) MedalsCount, Round((Count(ID)/@TotalMedals)*100, 2) Percentage
from athlete_events
Where Medal != ''
group by Gender
Order by MedalsCount desc

--6. Which athletes have won the most medals in a single Olympic games?
Select ID, Name, Games, MedalsWon 
from (
Select 
DENSE_RANK() over (order by Count(Id) desc) Position,
ae.Id, ae.Name, ae.Games, Count(Id) MedalsWon
from athlete_events ae
Where Medal != ''
group by ae.Id, ae.Name, ae.Games
)m
Where Position = 1

--7. What is the distribution of gold, silver, and bronze medals over the years?
Select Year, 
Count(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
Count(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
Count(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon
from athlete_events 
Where Medal != ''
group by Year
Order by Year

--8. Which countries have consistently performed well in the Olympics?
Select top 5 Country, Count(Year) InTop5 
from (
Select ROW_NUMBER() over (partition by Year Order by Count(ID) desc) Ranking,
nr.Country Country, Year,
Count(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
Count(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
Count(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon,
Count(ID) TotalMedalsWon
from athlete_events ae
inner join noc_regions nr on nr.NOC = ae.NOC
Where Medal != ''
group by nr.Country, Year
)m
Where Ranking <= 5
group by Country
Order by InTop5 desc

--9. What is the trend in the medal count of a particular country over the years?
Select 
nr.Country Country, Year,
Count(CASE WHEN Medal = 'Gold' THEN ID END) GoldMedalsWon,
Count(CASE WHEN Medal = 'Silver' THEN ID END) SilverMedalsWon,
Count(CASE WHEN Medal = 'Bronze' THEN ID END) BronzeMedalsWon,
Count(ID) TotalMedalsWon
from athlete_events ae
inner join noc_regions nr on nr.NOC = ae.NOC
Where Medal != '' and Country = 'Colombia'
group by nr.Country, Year 
Order by Country, Year 

--10. What is the average age of medal-winning athletes in different sports?
Select Sport, Count(ID) MedalsWon, Round(AVG(Convert(float, Age)), 2) AvgAgeOfAtheletes 
from athlete_events 
Where Medal != ''
group by Sport
Order by MedalsWon desc
