/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


--SELECT * 
--FROM PortfolioProject..CovidDeaths$
--WHERE Continent IS NOT NULL 
--ORDER BY 3,4



--Select Data to start with 



--SELECT Location,Date,total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths$
--WHERE Continent IS NOT NULL
--ORDER BY 1,2




--Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

--SELECT Location,Date,total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths$
--WHERE Location like '%states%'
--AND Continent IS NOT NULL
--ORDER BY 1,2



--Total Cases vs Population
--Shows what percentage of Population infected with Covid 

--SELECT Location,Date,Population,total_cases,(total_cases/Population)*100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths$
--WHERE Location like '%states%'
--ORDER BY 1,2 





--Countries with the Highest Infection Rate Compared to Population

--SELECT Location,Population,MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/Population))*100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths$
--WHERE Location like '%states%'
--GROUP BY Location,Population
--ORDER BY PercentPopulationInfected DESC


--Countries with the Highest Death Count per Population



--SELECT Location,MAX(cast(total_deaths AS int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths$
----WHERE Location like '%states%'
--WHERE Continent IS NOT NULL
--GROUP BY Location
--ORDER BY TotalDeathCount DESC


--BREAKING THINGS DOWN BY CONTINENT

--Showing Continentd with the Highest Death Count per Population


--SELECT Continent,MAX(cast(total_deaths AS int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths$
----WHERE Location like '%states%'
--WHERE Continent IS NOT NULL
--GROUP BY Continent
--ORDER BY TotalDeathCount DESC


--GLOBAL NUMBERS


--SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS Total_Deaths
--FROM PortfolioProject..CovidDeaths$
----WHERE Location Like '%states%'
--WHERE Continent IS NOT NULL
----GROUP BY Date
--ORDER BY 1,2


--Total Population vs Vaccinations
--Shows Percentage of Populaiton that has recevied at least one Covid Vaccine

--SELECT Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations
--, SUM(CONVERT(int,Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--FROM PortfolioProject..CovidDeaths$ Dea
--JOIN PortfolioProject..CovidVaccinations$ Vac
--	ON Dea.Location = Vac.Location
--	AND Dea.Date = Vac.Date
--WHERE Dea.Continent IS NOT NULL
--ORDER BY 2,3


-- Using CTE to perform Calculation of PARTITION BY in previous query


--WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--AS
--(
--SELECT Dea.Continent,Dea.Location,Dea.Date,Dea.Population,Vac.New_Vaccinations
--, SUM(CONVERT(int,Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
----, (RollingPeopleVaccinated/Population)*100
--FROM PortfolioProject..CovidDeaths$ Dea
--JOIN PortfolioProject..CovidVaccinations$ Vac
--	ON Dea.Location = Vac.Location
--	AND Dea.Date = Vac.Date
--WHERE Dea.Continent IS NOT NULL
----ORDER BY 2,3
--)
--SELECT *, (RollingPeopleVaccinated/Population)*100
--FROM PopvsVac



--Using Temp Table to perform Calculation on PARTITION BY in previosu query



--DROP TABLE IF Exists #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_Vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT Dea.Continent,Dea.Location,Dea.Date,Dea.Population,Vac.New_Vaccinations
--, SUM(CONVERT(int,Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
----, (RollingPeopleVaccinated/Population)*100
--FROM PortfolioProject..CovidDeaths$ Dea
--JOIN PortfolioProject..CovidVaccinations$ Vac
--	ON Dea.Location = Vac.Location
--	AND Dea.Date = Vac.Date
----WHERE Dea.Continent IS NOT NULL
----ORDER BY 2,3


--SELECT *, (RollingPeopleVaccinated/Population)*100
--FROM #PercentPopulationVaccinated


--Creating View to store data for later visualizations
 

--CREATE VIEW PercentPopulationVaccinated AS
--SELECT Dea.Continent,Dea.Location,Dea.Date,Dea.Population,Vac.New_Vaccinations
--, SUM(CONVERT(int,Vac.New_Vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.Location, Dea.Date) AS RollingPeopleVaccinated
----, (RollingPeopleVaccinated/Population)*100
--FROM PortfolioProject..CovidDeaths$ Dea
--JOIN PortfolioProject..CovidVaccinations$ Vac
--	ON Dea.Location = Vac.Location
--	AND Dea.Date = Vac.Date
--WHERE Dea.Continent IS NOT NULL


--SELECT *
--FROM PercentPopulationVaccinated





