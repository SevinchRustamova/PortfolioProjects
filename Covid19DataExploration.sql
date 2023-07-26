
/*
Covid 19 Data Exploration 

*/


-- Select Data that we are going to be starting with

Select location, date, total_cases, new_cases, total_deaths, population
From database.coviddeaths
order by 1, 2;

-- Looking at Total cases and Total deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From database.coviddeaths
where location like '%istan%'
order by 1, 2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From database.coviddeaths
order by 1, 2;

-- Countries with highest infection rate compared to population

Select location, population, max(total_cases) as HighestInfection, max((total_cases/population))*100 as PercentagePopulationInfected
From database.coviddeaths
Group by location, population
order by PercentagePopulationInfected desc;

-- Countries with highest death count per population

Select location, max(total_deaths) as TotalDeathCount
From database.coviddeaths
Group by location
order by  TotalDeathCount desc;

-- Showing continents with the highest death count per population

Select continent, max(total_deaths) as TotalDeathCount
From database.coviddeaths
where continent is not null
Group by continent
order by  TotalDeathCount desc;
 
 -- Global numbers 
 
 Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
 From database.coviddeaths
 where continent is not null
--  Group by date
 order by 1, 2;
 
--  Total Population vs Vaccinations
--  Shows percentage of population that has received at least one Covid vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From database.coviddeaths dea
Join database.covidvaccinations vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2, 3;
 
-- Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From database.coviddeaths dea
Join database.covidvaccinations vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null;