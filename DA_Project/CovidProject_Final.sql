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

-- Vaccination

select *
from CovidProject..CovidDeaths$ dea
join CovidProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date


-- population vs vaccinations 

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert( int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as CumulativePeopleVaccinated
from CovidProject..CovidDeaths$ dea
join CovidProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



with PopvsVac (continent, date, location, population,new_vaccinations, CumulativePeopleVaccinated)
as
(
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert( int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as CumulativePeopleVaccinated
from CovidProject..CovidDeaths$ dea
join CovidProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

)
select *,(CumulativePeopleVaccinated/population)*100 as CumulativePercentageVaccinated
from PopvsVac

--Temp Table

create table #PercentagePopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_Vaccinations numeric,
CumulativePercentageVaccinated numeric)
insert into #PercentagePopulationVaccinated
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert( int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as CumulativePeopleVaccinated
from CovidProject..CovidDeaths$ dea
join CovidProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *,(CumulativePercentageVaccinated/population)*100 as CumulativePercentageVaccinated
from #PercentagePopulationVaccinated