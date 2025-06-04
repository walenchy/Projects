

SELECT *
FROM [Portfolio project].dbo.CovidDeaths2


SELECT *
FROM [Portfolio project].dbo.CovidDeaths2
WHERE continent IS NOT NULL
ORDER BY 3,4

--Select *
--From [Portfolio project].dbo.Covidvacination
--order by 3,4

-- lets work on Covid dealth table and select my data

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio project].dbo.CovidDeaths2
WHERE continent IS NOT NULL
order by 1,2


-- check the total cases vs total deaths
-- showing the likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths,
(CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0)) * 100 AS DeathPercentage
From [Portfolio project].dbo.CovidDeaths2
Where location like '%states%'
and continent IS NOT NULL
order by 1,2



-- looking at the total cases vs population
-- Show what percentage of population got covid

Select Location, date,  population, total_cases,
(CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS PercentPopulationInfected
From [Portfolio project].dbo.CovidDeaths2
WHERE continent IS NOT NULL
--WHERE location LIKE '%state%'
order by 1,2

-- looking at countries with highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max(CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 as PercentPopulationInfected
From [Portfolio project].dbo.CovidDeaths2
WHERE continent IS NOT NULL
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio project].dbo.CovidDeaths2
--Where location like '%states%'
WHERE continent IS NOT NULL
Group by Location
order by TotalDeathCount desc


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio project].dbo.CovidDeaths2
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc






-- GLOBAL NUMBERS

SELECT 
  SUM(CAST(new_cases AS FLOAT)) AS total_cases, 
  SUM(CAST(new_deaths AS FLOAT)) AS total_deaths, 
  (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM 
  [Portfolio project].dbo.CovidDeaths2
  --Where location like '%states%'
WHERE 
  continent IS NOT NULL
  --Group By date
ORDER BY 
  1, 2;


  -- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select *
From [Portfolio project].dbo.Covidvacination
order by 3,4

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 -- USE CTE FOR THIS, COS THIS COLUMN JUST CREATED
From   [Portfolio project].dbo.CovidDeaths2 dea
Join   [Portfolio project].dbo.Covidvacination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent IS NOT NULL
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio project].dbo.CovidDeaths2 dea
Join  [Portfolio project].dbo.Covidvacination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *,
    (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 as VaccinationPercentage
From PopvsVac




-- Using Temp Table to perform Calculation on Partition By in previous query

-- Step 1: Create the temporary table
DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated 
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- Step 2: Insert cleaned data
INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    TRY_CONVERT(NUMERIC, dea.population) AS population,
    TRY_CONVERT(NUMERIC, vac.new_vaccinations) AS new_vaccinations,
    SUM(TRY_CONVERT(BIGINT, vac.new_vaccinations)) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM 
    [Portfolio project].dbo.CovidDeaths2 dea
JOIN  
    [Portfolio project].dbo.Covidvacination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

-- Step 3: Calculate vaccination percentage
SELECT *, 
    (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(CAST(Population AS FLOAT), 0)) * 100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated;

-- (Optional) Drop the temp table at the end of your session
-- DROP TABLE #PercentPopulationVaccinated;


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio project].dbo.CovidDeaths2 dea
Join [Portfolio project].dbo.Covidvacination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--DROP View if exists PercentPopulationVaccinated


SELECT *
FROM PercentPopulationVaccinated













