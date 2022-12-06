/* 
	COVID 19 DATA EXPLORATION
    SKILLS USED: Joins, CTE's, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


USE covid;
DESC coviddeaths;
DESC covidvaccinations;

SELECT 
    *
FROM
    coviddeaths;
    
SELECT 
    *
FROM
    covidvaccinations;

SELECT 
    location, date, total_cases, total_deaths, population
FROM
    coviddeaths
ORDER BY 1 , 2;

-- TotalCases VS TotalDeaths
-- Shows likelyhood of dying  if you contract covid in your country
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 DeathPercentage
FROM
    coviddeaths
WHERE
    location LIKE '%india%'
ORDER BY 1 , 2;

-- TotalCases VS Population
-- Shows what percentage of population got covid 
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 PercentageCases
FROM
    coviddeaths
ORDER BY 1 , 2;

-- Countries with Highest Infection Rate compared to Population

SELECT 
    location,
    population,
    MAX(total_cases) HighestInfectionCount,
    MAX((total_cases / population)* 100) PercentagePopulationInfected
FROM
    coviddeaths
GROUP BY location , population
ORDER BY PercentagePopulationInfected DESC; 

-- Countries with Highest Death Count per Population

SELECT 
    location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC; 


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing Continents with Highest Death Count per Population

SELECT 
    continent,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC; 

-- GLOBAL NUMBERS

SELECT 
    SUM(new_cases) total_cases,
    SUM((new_deaths )) total_deaths,
    SUM((new_deaths )) / SUM(new_cases) * 100 DeathPercent
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

-- Total Population VS Vaccinations
-- Shows the Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
	d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations, 
    SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) RollingPeopleVaccinated
FROM 
	coviddeaths d
JOIN 
	covidvaccinations v
ON 
	d.location = v.location
AND 
	d.date = v.date
WHERE 
	d.continent IS NOT NULL 
ORDER BY 2,3;

-- Using CTE to Perform Calculation on Partition By in the above query

WITH PopvsVac (
	continent, 
    location, 
    date, 
    population, 
    new_vaccinations, 
    RollingPeopleVaccinated) 
AS 
	(SELECT 
		d.continent, 
        d.location, 
        d.date, 
        d.population, 
        v.new_vaccinations, 
        SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) RollingPeopleVaccinated 
	FROM 
		coviddeaths d 
	JOIN 
		covidvaccinations v 
	ON 
		d.location = v.location 
	AND 
		d.date = v.date 
	WHERE 
		d.continent IS NOT NULL) 
SELECT *, (RollingPeopleVaccinated/population)*100 
FROM PopvsVac;

-- Using A Temp table to perform calculation on Partition By in Previous Query

DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
	continent VARCHAR(255),
	location VARCHAR(255),
	date DATETIME,
	population NUMERIC,
	new_vaccinations NUMERIC,
	RollingPeopleVaccinated NUMERIC
);

INSERT INTO PercentPopulationVaccinated
SELECT 
	d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations, 
    SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) RollingPeopleVaccinated
FROM 
	coviddeaths d
JOIN 
	covidvaccinations v
ON 
	d.location = v.location
AND 
	d.date = v.date;
 
SELECT *, (RollingPeopleVaccinated/population)*100 
FROM PercentPopulationVaccinated;
 
-- Creating a View to Store data for later Visualizations

CREATE VIEW PercentPopulationVaccinatedView AS 
SELECT 
	d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations, 
    SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) RollingPeopleVaccinated
FROM 
	coviddeaths d
JOIN 
	covidvaccinations v
ON 
	d.location = v.location
AND 
	d.date = v.date
WHERE 
	d.continent IS NOT NULL;

SELECT * FROM PercentPopulationVaccinatedView;