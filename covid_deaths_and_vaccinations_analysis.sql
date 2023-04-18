# In this SQL, I am exploring World Covid Data to extract statistics involving the virus and countries around the world. 

# Tool being used: BigQuery

#1. Select Data that we are going to be starting with.

SELECT 
  date,
  location, 
  total_cases, 
  new_cases, 
  total_deaths, 
  population
FROM
  covid_data.covid_deaths
ORDER BY
  location,
  date;

#2. What is the cumulative death rate (total cases / total deaths) per country from 2020 to 2023?

SELECT
  location,
  ROUND((total_deaths/total_cases)*100,2) AS death_rate
FROM 
  (
  SELECT
    location,
    SUM(total_cases) AS total_cases,
    SUM(total_deaths) AS total_deaths
  FROM
    covid_data.covid_deaths
  WHERE
  location NOT IN (
    'World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Europe', 'Asia', 'North America', 
    'South America')
  GROUP BY
    location
  )
ORDER BY
  death_rate DESC;

#3. What percent of each country's population was infected with Covid-19 per day?

SELECT
  date,
  location,
  population,
  total_cases,
  ROUND((total_cases/population)*100,2) AS percent_infected
FROM
  covid_data.covid_deaths
WHERE
  location NOT IN (
    'World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Europe', 'Asia', 'North America', 
    'South America')
ORDER BY
  location,
  date;

#4. At the peak of severity for each country, what percent of the population was infected with Covid-19?
 
SELECT
  Location, 
  Population, 
  MAX(total_cases) as highest_total_cases,  
  ROUND(Max(total_cases)/MAX(population)*100,2) as highest_percent_infected
FROM
  covid_data.covid_deaths
WHERE
  location NOT IN (
    'World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Europe', 'Asia', 'North America', 
    'South America')
GROUP BY
  location, 
  population
ORDER BY
  highest_percent_infected DESC;

#5. Which countries have had the highest death counts?

SELECT
  location,
  MAX(total_deaths) AS death_count
FROM
  covid_data.covid_deaths
WHERE
  location NOT IN (
    'World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Europe', 'Asia', 'North America', 
    'South America')
GROUP BY
  location
ORDER BY
  death_count DESC;

#6. How many total cases have there been in the world? How many deaths? What is the global death rate for Covid-19?

SELECT
  SUM(new_cases) AS total_cases,
  SUM(new_deaths) AS total_deaths,
  (SUM(new_deaths))/(SUM(new_cases))*100 AS global_death_rate
FROM
  covid_data.covid_deaths
WHERE
  location NOT IN (
    'World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Europe', 'Asia', 'North America', 
    'South America')

#7. Demonstrate the increasing number of people vaccinated for each country and what percent of the population this is.

SELECT  
  continent, location, date, population, new_vaccinations,rolling_people_vaccinated,
  ((rolling_people_vaccinated/population)*100) AS rolling_percent_vaccinated
FROM (
  SELECT
    cd.continent, 
    cd.location, 
    cd.date, 
    cd.population,
    cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.Location ORDER BY cd.location, cd.date) as rolling_people_vaccinated
  FROM
    covid_data.covid_deaths AS cd
  JOIN
    covid_data.covid_vax AS cv
  ON 
    cd.location = cv.location AND
    cd.date = cv.date
  WHERE
    cd.location NOT IN (
      'World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Europe', 'Asia', 'North America', 
      'South America')
    AND cd.continent IS NOT NULL
  ORDER BY
    cd.location,
    cd.date
  )

