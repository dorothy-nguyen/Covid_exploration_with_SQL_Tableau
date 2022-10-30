# Covid_exploration_with_SQL_Tableau

## 1. Overview of dataset and project

> This project aims to apply SQL queries to explore Covid 19 dataset and then use Tableau to visualize the key findings.
 
> Dataset includes 230465 rows and was extracted from [_Our World in Data_](https://ourworldindata.org/covid-deaths) on October 27th, 2022. 

> Skills used: SQL joins, CTE's, temp tables, window functions, aggregate functions, views, data type conversion, Tableau dashboard.

## 2. Project workflow

- After downloading the csv file from *Our World in Data* webpage, I splited the file into two Excel Workbook files: _CovidDeaths.xlsx_ and _CovidVaccinations.xlsx_.
- Database named *PortfolioProject* was created in Microsoft SQL Server Management Studio and the Excel Workbook files above were imported into Microsoft SQL Server to be then added as the *PortfolioProject* database tables. 
- Common keys such as location, date, and continent were used to perform joins on two tables CovidDeaths and CovidVaccinations.
- Various queries were scripted to answer questions related to Covid figures of total cases, total deaths, total vaccinations, infection rate, vaccination rate, etc... at both country and continent levels.
- To continue, I applied window functions to count the rolling number of vaccinations partitioned by location. 
- I then created the temp table to perform calculation on partition by in previous query.
- Additionally, I created views to store data for later visualizations.
- Five charts based on SQL queries were embedded into one dashboard which was published on my Tableau account. 

## 3. Summary of main findings 

> Answers to those questions are found over the SQL exploration process: 

- The likelihood of dying if someone contracts to Covid in my country -- Finland over time
- The likelihood of the population infected with Covid in my country over time
-	Countries that had the highest infection rate by population
-	Top 10 countries that had the highest total death count
-	Total cases, total deaths and death percentage of Covid worldwide
-	Continents in the order of highest death count
-	Percentage of population that received at least one Covid Vaccine per country

> A dashboard is created on my Tableau public account to demonstrate the key findings.

**Check out my viz on Tableau via [`Covid updated by 0ct 2022`](https://public.tableau.com/app/profile/dorothy2029/viz/Covid_dashboard_updated_to_Oct_2022/Dashboard1) and I hope you enjoy my dashboard :smiley:**
