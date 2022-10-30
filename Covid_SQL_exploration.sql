/*
Covid 19 Data Exploration - Data extracted from https://ourworldindata.org/covid-deaths by 27/10/2022

Skills applied: Joins, Common Table Expressions CTEs, Temporary Tables, Windows Functions, Aggregation Functions, Creating Views, Data Type Conversion

*/
-- Overview of CovidDeaths table

SELECT * FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

-- Percentage of dying if someone contracts to Covid in my country over time

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) death_percentage
FROM CovidDeaths
WHERE location ='Finland'
ORDER BY 5 DESC;

-- Percentage of population infected with Covid in my country over time

SELECT location, date, total_cases, population, ROUND((total_cases/population)*100,2) infection_rate
FROM CovidDeaths
WHERE location ='Finland'
ORDER BY 5 DESC;

-- Which countries had the highest infection rate by population?

SELECT location, MAX(total_cases) highest_infection_count,  ROUND(Max((total_cases/population))*100,2) highest_infection_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 3 DESC,2 DESC;

-- Which top 10 countries had the highest total death count? 
-- Some results are grouped by continent if we don't include the condition where continent IS NOT NULL
-- total_deaths is stored as varchar, hence we have to convert it to interger data type for aggregation function

SELECT TOP 10 location, MAX(CAST (total_deaths AS int)) total_death_count 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;

-- Total cases, total deaths and death percentage of Covid worldwide

SELECT SUM(new_cases) total_cases, SUM(CAST(new_deaths AS int)) total_deaths, ROUND(SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100,2) death_percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1 DESC, 2 DESC;

-- BREAKING THINGS DOWN BY CONTINENT
-- Continents in the order of highest death count

SELECT continent, MAX(total_cases) total_case_count, MAX(CAST(total_deaths AS int)) total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC, 3 DESC;

-- Percentage of population that has recieved at least one Covid Vaccine
-- join two tables CovidDeaths AND CovidVaccinations 
-- use CTE to perform calculation on Partition By query

WITH rolling_vaccine AS 
(SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
		SUM(CAST(v.new_vaccinations AS bigint)) OVER (PARTITION BY d.location ORDER BY d.location,d.date) as rolling_count_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location=v.location AND d.date=v.date
WHERE d.continent IS NOT NULL),

t2 AS (SELECT *, ROUND((rolling_count_vaccinated/population)*100,2) rolling_vaccine_by_population
FROM  rolling_vaccine)

SELECT t2.location, t2.population, SUM(CONVERT(bigint,t2.new_vaccinations)) total_vaccines, MAX(t2.rolling_vaccine_by_population) vaccine_percentage
FROM t2
GROUP BY t2.location, t2.population
ORDER BY vaccine_percentage DESC;

-- CREATE TEMP TABLE TO PERFORM CALCULATION ON PARTITION BY IN PREVIOUS QUERY

DROP TABLE IF exists #Rolling_count_vaccinated
CREATE TABLE #Rolling_count_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_count_vaccinated numeric
)

INSERT INTO #Rolling_count_vaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
		SUM(CAST(v.new_vaccinations AS bigint)) OVER (PARTITION BY d.location ORDER BY d.location,d.date) as rolling_count_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location=v.location AND d.date=v.date
WHERE d.continent IS NOT NULL

SELECT *, ROUND((rolling_count_vaccinated/population)*100,2) rolling_vaccine_by_population
FROM #Rolling_count_vaccinated
ORDER BY 7 DESC;

-- Creating View to store data for later visualizations

CREATE VIEW percent_vaccinated_by_population AS 
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
		SUM(CAST(v.new_vaccinations AS bigint)) OVER (PARTITION BY d.location ORDER BY d.location,d.date) as rolling_count_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location=v.location AND d.date=v.date
WHERE d.continent IS NOT NULL;