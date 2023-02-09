SELECT * FROM SSMSProject.dbo.CovidDeath
Order By 1,2

SELECT * FROM SSMSProject.dbo.CovidVaccination
Order By 1,2

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM SSMSProject.dbo.CovidDeath
Order By 1,2

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
FROM SSMSProject.dbo.CovidDeath
where location like 'aus%'
Order By 1,2

SELECT location,date,population,(total_cases/population)*100 as case_Percentage
FROM SSMSProject.dbo.CovidDeath
where location like 'aus%'
Order By 1,2

SELECT location,population,Max(total_cases) as highest_infection_count, Max(total_cases/population)*100 as Infected_Percentage
FROM SSMSProject.dbo.CovidDeath
where continent is not null
Group By location,population
Having location like 'A%'
Order By Infected_Percentage DESC;

SELECT location,population,max(total_cases),max(total_cases/population)*100 as case_Percentage
FROM SSMSProject.dbo.CovidDeath
where continent is not null
Group by location,population, total_cases
Having location like 'A%'
Order By case_Percentage

SELECT * FROM SSMSProject.dbo.CovidDeath
where continent is not null
Order By 1,2



SELECT continent,Max(total_cases)as total_cases ,Max(total_cases/population)*100 as case_Percentage
FROM SSMSProject.dbo.CovidDeath
where continent is not null
Group by continent
Order By case_Percentage DESC


SELECT sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
FROM SSMSProject.dbo.CovidDeath
where continent is not null
Order By 1,2


WITH PopVsVac (Continent,Location, Date,Population, new_vaccinations,rolling_peoplevaccination)
as
(
SELECT  dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, 
dea.date) as rolling_peoplevaccination
FROM SSMSProject.dbo.CovidDeath as dea
Join SSMSProject.dbo.CovidVaccination as vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--Order by 2,3
)
Select * ,(rolling_peoplevaccination/Population)*100
From PopVsVac





Drop table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date	datetime,
population int,
New_vaccination int,
rolling_peoplevaccination int
)

Insert Into #percentpopulationvaccinated
SELECT  dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, 
dea.date) as rolling_peoplevaccination
FROM SSMSProject.dbo.CovidDeath as dea
Join SSMSProject.dbo.CovidVaccination as vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--Order by 2,3

Select * ,(rolling_peoplevaccination/Population)*100
From #percentpopulationvaccinated



Create view percentpopulationvaccinated as 
SELECT  dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, 
dea.date) as rolling_peoplevaccination
FROM SSMSProject.dbo.CovidDeath as dea
Join SSMSProject.dbo.CovidVaccination as vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
