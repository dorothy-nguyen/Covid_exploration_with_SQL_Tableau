/*
Queries used for Tableau Project
*/
-- 1. Total cases, total deaths and death percentage of Covid worldwide

SELECT SUM(new_cases) total_cases, SUM(CAST(new_deaths AS int)) total_deaths, ROUND(SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100,2) death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1 DESC, 2 DESC;

-- 2. Number of total deaths at continent level. 
-- I cross out rows that do not represent continents for Tableau visualization purpose.

SELECT location, SUM(CAST(new_deaths AS int)) total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent is null AND location NOT IN ('World', 'European Union', 'International','High income','Upper middle income',
												'Lower middle income','Low income')
GROUP BY location
ORDER BY 2 DESC;

-- 3. Countries with the highest infection rate by population

SELECT location, population, MAX(total_cases) highest_infection_count,  ROUND(Max((total_cases/population))*100,2) infection_rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC;

-- 4. Countries with the highest infection rate by population breaking down by date

SELECT location, population, date, MAX(total_cases) highest_infection_count,  ROUND(Max((total_cases/population))*100,2) infection_rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population, date
ORDER BY 5 DESC;

-- 5. Percentage of population that has recieved at least one Covid Vaccine

WITH rolling_vaccine AS 
(SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
		SUM(CAST(v.new_vaccinations AS bigint)) OVER (PARTITION BY d.location ORDER BY d.location,d.date) as rolling_count_vaccinated
FROM PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
ON d.location=v.location AND d.date=v.date
WHERE d.continent IS NOT NULL),

t2 AS (SELECT *, ROUND((rolling_count_vaccinated/population)*100,2) rolling_vaccine_by_population
FROM  rolling_vaccine)

SELECT t2.location, t2.population, SUM(CONVERT(bigint,t2.new_vaccinations)) total_vaccines, MAX(t2.rolling_vaccine_by_population) vaccine_percentage
FROM t2
GROUP BY t2.location, t2.population
ORDER BY vaccine_percentage DESC;



