CREATE DATABASE PORTFOLIOPROJECT;
SELECT * FROM covidvaccinations
ORDER BY 3,4;

SELECT * FROM coviddeaths
ORDER BY 3,4;

SELECT * FROM covidvaccinations
ORDER BY 1,2;

SELECT Location,Date ,total_cases , new_cases,total_deaths, population 
from coviddeaths
ORDER BY 1,2;

-- Total cases vs Total Deaths

SELECT Location,Date ,total_cases ,total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
from coviddeaths
where location like '%Afghanistan%'
and continent is not null
ORDER BY 1,2;

-- Total cases vs Total Population
-- Shows what percentage of population got covid

SELECT Location,Date ,population,total_cases , (total_cases/population) * 100 AS PopulationPercentage
from coviddeaths
where location like '%Afghanistan%'
ORDER BY 1,2;


--- show which counntry has highest infection rate comapared to Population


SELECT Location,population,MAX(total_cases) AS HighestInfectedCount, max((total_cases/population)) * 100 AS PercentPopulationInfected
from coviddeaths
-- where location like '%Afghanistan%'
group by Location,population
ORDER BY PercentPopulationInfected DESC;

-- show which counntry has highest death rate comapared to Population

SELECT Location,MAX(total_deaths) AS HighestDeathCount
from coviddeaths
-- where location like '%Afghanistan%'
where continent is not null
group by Location
ORDER BY HighestDeathCount desc;

--- breaking down by each continent

	SELECT continent,MAX(total_deaths) AS HighestDeathCount
	from coviddeaths
	-- where location like '%Afghanistan%'
	where continent is not null					
	group by continent
	ORDER BY HighestDeathCount desc;
    
    -- GLOBAL NUMBERS
    
SELECT SUM(new_cases) AS TOTALCASES,SUM(new_deaths) as TOTALDEATHS,SUM(new_deaths)/SUM(new_cases) * 100 as DeathPercentage
from coviddeaths
-- where location like '%Afghanistan%'
WHERE continent is not null
-- group by date
ORDER BY 1,2;



select * FROM coviddeaths Dea
JOIN covidvaccinations Vac
ON Dea.location = Vac.location
and Dea.date = Vac.date;




-- Looking at Total Population vs Vaccinations
With PopvsVac (Continent ,Location , Date , Population ,New_Vaccinations,RollingPeopleVaccinated)
as 
(
select Dea.continent , Dea.location , Dea.date , Dea.population , Vac.new_vaccinations , SUM(Vac.new_vaccinations) OVER (Partition by dea.location  order by dea.location,dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)* 100
From coviddeaths Dea JOIN covidvaccinations Vac
ON Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
-- ORDER BY 2,3
)
Select * , (RollingPeopleVaccinated/population) 
from PopvsVac;


-- TEMP TABLE

Create table #PercentPopulationVaccinated
 ( Continent nvarchar (255),
 Location nvarchar (255),
 Date datetime,
 Population numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 
Insert into #PercentPopulationVaccinated
Select Dea.continent , Dea.location , Dea.date , Dea.population , Vac.new_vaccinations , SUM(Vac.new_vaccinations) OVER (Partition by dea.location  order by dea.location,dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)* 100
From coviddeaths Dea JOIN covidvaccinations Vac
ON Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
-- ORDER BY 2,3
Select * , (RollingPeopleVaccinated/population) 
from #PercentPopulationVaccinated;