
--All data from CovidDeaths
Select *
From [Project 1]..CovidDeaths
Order by 3,4

--Total_cases vs total_deaths in location like states 
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
From [Project 1]..CovidDeaths
where location like '%states%'
Order by 1,2

--Total_cases vs total_deaths in location like Africa
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
From [Project 1]..CovidDeaths
where location like '%africa%'
Order by 1,2

--Total_cases vs population in location like states
Select location, date, total_cases, population,  (total_cases/population)*100 as infected_population_percentage
From [Project 1]..CovidDeaths
where location like '%states%'
Order by 1,2

--Total_cases vs population in location like Africa
Select location, date, total_cases, population, (total_cases/population)*100 as infected_population_percentage
From [Project 1]..CovidDeaths
where location like '%africa%'
Order by 1,2

--Location with the highest infection rate compared with population
Select location,population, MAX(total_cases) as highest_infection_count, MAX(total_cases/population)*100 as infected_population_percentage
From [Project 1]..CovidDeaths
--where location like '%states%'
Group by location, population
Order by infected_population_percentage desc



--Query by continent

--continent with the highest death rate compared with population

Select continent, MAX(cast(total_deaths as int)) as highest_death_count
From [Project 1]..CovidDeaths
Where continent is not null
Group by continent                
Order by highest_death_count desc

--Global numbers

--Total_cases, Total_deaths and Death_percent by date


Select date, SUM(new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_deaths, SUM (cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
From [Project 1]..CovidDeaths
--where location like '%africa%'
Where continent is not null
group by date
Order by 1,2

--Total_cases, Total_deaths and Death_percent

Select SUM(new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_deaths, SUM (cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
From [Project 1]..CovidDeaths
--where location like '%africa%'
Where continent is not null
--group by date
Order by 1,2

--All data from CovidVaccinations

Select *
From [Project 1]..CovidVaccinations
Order by 3,4

 --Join


Select *
From [Project 1]..CovidDeaths as CD
Join [Project 1]..CovidVaccinations as CV
	On CD.location = CV.location
	and CD.date = CV.date

	--Total Population Vs Vaccination

Select CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations
From [Project 1]..CovidDeaths as CD
Join [Project 1]..CovidVaccinations as CV
	On CD.location = CV.location
	and CD.date = CV.date
Where CD.continent is not null
Order by 2,3

--Another way for Total Population Vs Vaccination

--USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
Select CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, SUM(Convert(int,CV.new_vaccinations)) Over(partition by CD.location order by CD.location, CD.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Project 1]..CovidDeaths as CD
Join [Project 1]..CovidVaccinations as CV
	On CD.location = CV.location
	and CD.date = CV.date
Where CD.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac



--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinatons numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, SUM(Convert(int,CV.new_vaccinations)) Over(partition by CD.location order by CD.location, CD.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Project 1]..CovidDeaths as CD
Join [Project 1]..CovidVaccinations as CV
	On CD.location = CV.location
	and CD.date = CV.date
Where CD.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated




--CREATE VIEW TO STORE DATA

Create View PercentPopulationVaccinated as
Select CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, SUM(Convert(int,CV.new_vaccinations)) Over(partition by CD.location order by CD.location, CD.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Project 1]..CovidDeaths as CD
Join [Project 1]..CovidVaccinations as CV
	On CD.location = CV.location
	and CD.date = CV.date
Where CD.continent is not null
--Order by 2,3







































