/*
	SQL Queries Used For TABLEAU PROJECT
*/

USE covid;
-- 1
SELECT 
    SUM(new_cases) total_cases,
    SUM((new_deaths )) total_deaths,
    SUM((new_deaths )) / SUM(new_cases) * 100 DeathPercent
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

-- 2
SELECT 
    location, SUM(new_deaths) TotalDeathCount
FROM
    coviddeaths
WHERE
    continent IS NULL
        AND location NOT IN ('world' , 'european union', 'international')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- 3
SELECT 
    location,
    population,
    MAX(total_cases) HighestInfectionCount,
    MAX((total_cases / population)* 100) PercentagePopulationInfected
FROM
    coviddeaths
GROUP BY location , population
ORDER BY PercentagePopulationInfected DESC; 

-- 4
SELECT 
    location,
    population,
    date,
    MAX(total_cases) HighestInfectionCount,
    MAX((total_cases / population)) * 100 PercentPopulationInfected
FROM
    coviddeaths
GROUP BY location , population , date
ORDER BY PercentPopulationInfected DESC;
