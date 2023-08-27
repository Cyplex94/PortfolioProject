-- use portfolioProject

SELECT new_cases
FROM PortfolioProject..CovidDeathsCleaned
--order by 3, 4

--SELECT *
--FROM PortfolioProject.. CovidVaccinationsCleaned

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeathsCleaned
order by 1,2 


-- Looking at Total Cases vs Total Deaths
-- Shows lokelihood of dying if you contract COVID in your country
select location, date, total_cases, total_deaths, (CAST(total_deaths as float) / CAST(total_cases as float)*100) as  DeathPercentage
from PortfolioProject.. CovidDeathsCleaned
Where location like '%states%'
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got COVID
select location, date, population, total_cases,  (CAST(total_cases as float) / CAST(population as float)*100) as PercentPopulationInfected
from PortfolioProject..CovidDeathsCleaned
where location like '%states%'
order by 1,2 



-- Looking at countries with highest infection rate compared to population
select population, location,  MAX(CAST(total_cases as int)) as HighestInfectionCount, MAX(CAST(total_cases as float) /CAST(population as float))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeathsCleaned
--where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc



-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Showing Countries with highest death count per population
select continent,  MAX(CAST(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeathsCleaned
--where location like '%states%'
WHERE continent is not null
Group by continent
order by TotalDeathCount desc



-- Showing continents with highest death count per population
select continent,  MAX(CAST(total_deaths as float)) / MAX(CAST(population as float))*100 as PercentageOfTotalDeaths
from PortfolioProject..CovidDeathsCleaned
--where location like '%states%'
WHERE continent is not null
Group by continent
order by PercentageOfTotalDeaths desc



-- GLOBAL NUMBERS
select SUM(CAST(new_cases as int)) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as float)) / SUM(CAST(new_cases as float))*100 as  DeathPercentage
from PortfolioProject.. CovidDeathsCleaned
--Where location like '%states%'
where continent is not null
AND new_cases NOT LIKE 0
--Group by date
order by DeathPercentage asc




-- Looking at Total Population vs Vaccinations
-- I have added a partition by that sums every new vaccination by date, per location, and will reset once the location changes
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingCountPeopleVaccinated
From PortfolioProject.. CovidDeathsCleaned dea
Join PortfolioProject.. CovidVaccinationsCleaned vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
order by 2,3




-- USE CTE
With PopVsVac (Continent, Location, Date, Population, new_vaccinations, RollingCountPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingCountPeopleVaccinated
From PortfolioProject.. CovidDeathsCleaned dea
Join PortfolioProject.. CovidVaccinationsCleaned vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--order by 2,3
)
Select *, (RollingCountPeopleVaccinated/Population)*100
From PopVsVac





-- Temp Table
-- I have added Drop statement for reusability purposes 
DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingCountPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingCountPeopleVaccinated
From PortfolioProject.. CovidDeathsCleaned dea
Join PortfolioProject.. CovidVaccinationsCleaned vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--order by 2,3

Select *, (RollingCountPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated





-- Creating View to store data for later vizualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingCountPeopleVaccinated
From PortfolioProject.. CovidDeathsCleaned dea
Join PortfolioProject.. CovidVaccinationsCleaned vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--order by 2,3


Select *
From PercentPopulationVaccinated