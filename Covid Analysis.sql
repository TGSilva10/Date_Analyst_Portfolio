-- 1. Sumário por continente: Total de casos, mortes e vacinações
SELECT 
    d.continent,
    SUM(d.total_cases) AS total_cases,
    SUM(d.total_deaths) AS total_deaths,
    SUM(v.total_vaccinations) AS total_vaccinations
FROM 
    CovidDeaths d
LEFT JOIN 
    CovidVaccinations v
ON 
    d.continent = v.continent AND d.location = v.location AND d.date = v.date
WHERE 
    d.continent IS NOT NULL
GROUP BY 
    d.continent
ORDER BY 
    total_cases DESC;
	
-- 2. Tendências globais: Casos e mortes ao longo do tempo
SELECT 
    d.date,
    SUM(d.new_cases) AS daily_cases,
    SUM(d.new_deaths) AS daily_deaths
FROM 
    CovidDeaths d
WHERE 
    d.date IS NOT NULL
GROUP BY 
    d.date
ORDER BY 
    d.date;
	
-- 3. Top 10 países com mais casos, mortes e vacinações
SELECT 
    d.location AS country,
    MAX(d.total_cases) AS max_cases,
    MAX(d.total_deaths) AS max_deaths,
    MAX(v.total_vaccinations) AS max_vaccinations
FROM 
    CovidDeaths d
LEFT JOIN 
    CovidVaccinations v
ON 
    d.location = v.location AND d.date = v.date
WHERE 
    d.continent IS NULL  -- Excluir agrupamentos por continentes
GROUP BY 
    d.location
ORDER BY 
    max_cases DESC
LIMIT 10;

-- 4. Relação entre vacinação e mortalidade ao longo do tempo
SELECT 
    d.date,
    SUM(d.new_deaths) AS daily_deaths,
    SUM(v.new_vaccinations) AS daily_vaccinations
FROM 
    CovidDeaths d
LEFT JOIN 
    CovidVaccinations v
ON 
    d.location = v.location AND d.date = v.date
WHERE 
    d.date IS NOT NULL
GROUP BY 
    d.date
ORDER BY 
    d.date;
	
-- 5. Países com maior taxa de mortalidade (mortes por casos confirmados)
SELECT 
    d.location AS country,
    ROUND(MAX(d.total_deaths) * 100.0 / MAX(d.total_cases), 2) AS mortality_rate
FROM 
    CovidDeaths d
WHERE 
    d.total_cases > 0 -- Evitar divisão por zero
GROUP BY 
    d.location
ORDER BY 
    mortality_rate DESC
LIMIT 10;

-- 6. Continentes com maior crescimento diário médio de casos
SELECT 
    d.continent,
    ROUND(AVG(d.new_cases), 2) AS avg_daily_cases_growth
FROM 
    CovidDeaths d
WHERE 
    d.new_cases IS NOT NULL
GROUP BY 
    d.continent
ORDER BY 
    avg_daily_cases_growth DESC;
	
-- 7. Taxa de vacinação por continente
SELECT 
    d.continent,
    ROUND(SUM(v.total_vaccinations) * 100.0 / SUM(d.population), 2) AS vaccination_rate
FROM 
    CovidDeaths d
LEFT JOIN 
    CovidVaccinations v
ON 
    d.continent = v.continent AND d.location = v.location AND d.date = v.date
WHERE 
    d.continent IS NOT NULL
GROUP BY 
    d.continent
ORDER BY 
    vaccination_rate DESC;

-- 8. Países com maior número de casos por milhão de habitantes
SELECT 
    d.location AS country,
    ROUND(MAX(d.total_cases_per_million), 2) AS cases_per_million
FROM 
    CovidDeaths d
GROUP BY 
    d.location
ORDER BY 
    cases_per_million DESC
LIMIT 10;

-- 9. Evolução percentual diária de casos globais
SELECT 
    d.date,
   ROUND( (SUM(d.new_cases) * 100.0 / LAG(SUM(d.total_cases)) OVER (ORDER BY d.date)), 2)AS daily_case_growth_rate
FROM 
    CovidDeaths d
GROUP BY 
    d.date
ORDER BY 
    d.date;




