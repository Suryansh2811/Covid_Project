select * 
from CovidProject..CovidDeaths$
where continent is not null
order by 3,4


select location, date, population, total_cases, new_cases, total_deaths
from CovidProject..CovidDeaths$
where continent is not null
order by 1,2

--Comparing total deaths vs total cases around the world

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from CovidProject..CovidDeaths$
where continent is not null
order by 1,2


--Comparing total deaths vs total cases for India

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from CovidProject..CovidDeaths$
Where location like '%India%' and continent is not null
order by 1,2


-- Total cases vs the population
select location, date, total_cases, population, (total_cases/population)*100 as PercentagePeopleInfected
from CovidProject..CovidDeaths$
where continent is not null
order by 1,2

-- Total cases vs the population in India
select location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
from CovidProject..CovidDeaths$
Where location like '%India%' and continent is not null
order by 1,2


-- Countries with highest infection rate compared to the population	
select location,Max(total_cases) as HighestInfectedCount, population, Max((total_cases/population))*100 as PercentagePeopleInfected
from CovidProject..CovidDeaths$
where continent is not null
Group by location, population

order by PercentagePeopleInfected desc

-- Countries with highest death rate
select location,Max(cast(total_deaths as bigint)) as HighestDeathCount
from CovidProject..CovidDeaths$
where continent is not null
Group by location, population
order by HighestDeathCount desc

-- Continents with highest death rate
select location,Max(cast(total_deaths as bigint)) as HighestDeathCount
from CovidProject..CovidDeaths$
where continent is null
Group by location
order by HighestDeathCount desc


-- global data

select date, SUM(new_cases) as TotalCases, sum(cast(new_deaths as bigint)) as TotalDeaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths$
where continent is not null
group by date
order by 1,2




