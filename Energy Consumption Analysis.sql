CREATE DATABASE ENERGYDB;
USE ENERGYDB;


-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

ALTER TABLE country
RENAME TO country_3;

SELECT * FROM COUNTRY_3;

-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    con_year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country_3(Country)
);

SELECT * FROM EMISSION_3;


-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    con_year INT,
    Value_0 DOUBLE,
    FOREIGN KEY (countries) REFERENCES country_3(Country)
);

SELECT * FROM POPULATION;

-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    con_year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country_3(Country)
);


SELECT * FROM PRODUCTION;

-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    con_year INT,
    Value_g DOUBLE,
    FOREIGN KEY (Country) REFERENCES country_3(Country)
);

SELECT * FROM GDP_3;

-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    con_year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country_3(Country)
);

SELECT * FROM CONSUMPTION;

-- Data Analysis Questions 
-- General & Comparative Analysis
show tables;
-- What is the total emission per country for the most recent year available?
select country , sum(per_capita_emission) as total_emission
from emission_3
WHERE con_year = (
	select max(con_year) 
    from emission_3)
GROUP BY country
ORDER BY total_emission;

-- What are the top 5 countries by GDP in the most recent year?
SELECT country , value_g 
from gdp_3
WHERE con_year = (
	SELECT max(con_year) 
    from gdp_3
    )
ORDER BY value_g DESC
LIMIT 5;

-- Compare energy production and consumption by country and year. 
SELECT p.country , p.energy ,p.con_year  ,
	c.consumption ,p.production , (p.production - c.consumption) as net_energy
FROM production p
JOIN consumption c
ON p.country = c.country
AND p.energy = c.energy
AND p.con_year = c.con_year
ORDER BY p.country ,p.con_year;

-- Which energy types contribute most to emissions across all countries? -- 
SELECT country , energy_type , sum(per_capita_emission)
as total_emmision
from emission_3
GROUP BY country ,energy_type
ORDER BY total_emmision DESC limit 5; 

-- Trend Analysis Over Time
-- How have global emissions changed year over year?
SELECT con_year,SUM(emission) AS global_emission,
    SUM(emission) - LAG(SUM(emission)) OVER (ORDER BY con_year) 
    AS yearly_change
FROM emission_3
GROUP BY con_year
ORDER BY con_year;

-- What is the trend in GDP for each country over the given years? -- show increasing / decreasing
WITH ranked AS (
    SELECT country, con_year, Value_g,
        FIRST_VALUE(value_g) OVER (PARTITION BY country ORDER BY con_year) AS first_gdp,
        LAST_VALUE(value_g) OVER (PARTITION BY country ORDER BY con_year 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_gdp
    FROM gdp_3),
summary AS (
    SELECT DISTINCT country, first_gdp, last_gdp,
        CASE 
            WHEN last_gdp > first_gdp THEN 'Increasing'
            WHEN last_gdp < first_gdp THEN 'Decreasing'
            ELSE 'Stable'
        END AS gdp_trend
    FROM ranked)
SELECT * FROM summary;

-- How has population growth affected total emissions in each country?
SELECT p.countries , p.con_year , p.value_0 AS population , sum(e.emission) AS total_emission
from population p
JOIN emission_3 e
ON p.countries = e.country
AND p.con_year = e.con_year
GROUP BY p.countries , p.con_year , p.value_0
ORDER BY p.countries ,p.value_0 ;

-- Has energy consumption increased or decreased over the years for major economies?
WITH change_energy AS (
SELECT country,con_year, SUM(consumption) AS con_energy,
SUM(consumption)- LAG(SUM(consumption)) OVER (
	PARTITION BY country ORDER BY con_year) AS yearly_change
FROM consumption
GROUP BY country, con_year)

SELECT * FROM change_energy
ORDER BY country, con_year;

-- What is the average yearly change in emissions per capita for each country? -- review this que

WITH emission_change AS (

    SELECT 
        country,
        con_year,
        AVG(per_capita_emission) AS avg_per_capita_emission,

        AVG(per_capita_emission)
        - LAG(AVG(per_capita_emission)) OVER (
            PARTITION BY country
            ORDER BY con_year
        ) AS yearly_change

    FROM emission_3

    GROUP BY country, con_year
)

SELECT 
    country,
    ROUND(AVG(yearly_change), 4) AS avg_yearly_change
FROM emission_change
WHERE yearly_change IS NOT NULL
GROUP BY country
ORDER BY avg_yearly_change DESC;

-- Ratio & Per Capita Analysis
-- What is the emission-to-GDP ratio for each country by year?
SELECT e.country, e.con_year, SUM(e.emission) AS total_emission,
	g.value_g AS GDP, ROUND(SUM(e.emission) / g.value_g, 6) 
    AS emission_to_gdp_ratio
FROM emission_3 e
JOIN gdp_3 g
ON e.country = g.Country
AND e.con_year = g.con_year
GROUP BY e.country, e.con_year, g.value_g
ORDER BY e.country,e.con_year;

-- What is the energy consumption per capita for each country over the last decade?
    
SELECT c.country, c.con_year, SUM(c.consumption) AS total_consumption,
	p.value_0 AS population,
	ROUND(SUM(c.consumption) / p.Value_0,6) AS consumption_per_capita
FROM consumption c
JOIN population p ON c.country = p.countries
AND c.con_year = p.con_year
WHERE c.con_year >= (
    SELECT MAX(con_year) - 10
    FROM consumption)
GROUP BY c.country,c.con_year, p.value_0
ORDER BY c.country,c.con_year;

-- How does energy production per capita vary across countries? -- across countries consider all the yrs combined
SELECT 
    p.country,

    SUM(p.production) AS total_production,
    SUM(pop.value_0) AS total_population,

    ROUND(
        SUM(p.production) / NULLIF(SUM(pop.value_0), 0),
        6
    ) AS production_per_capita

FROM production p

JOIN population pop
    ON p.country = pop.countries
    AND p.con_year = pop.con_year

GROUP BY 
    p.country

ORDER BY 
    production_per_capita DESC;
-- Which countries have the highest energy consumption relative to GDP? -- combine all the years for one country and limit to 5 
SELECT 
    c.country,

    SUM(c.consumption) AS total_consumption,
    SUM(g.value_g) AS total_gdp,

    ROUND(
        SUM(c.consumption) / NULLIF(SUM(g.value_g), 0),
        6
    ) AS energy_to_gdp_ratio

FROM consumption c

JOIN gdp_3 g
    ON c.country = g.country
    AND c.con_year = g.con_year

GROUP BY 
    c.country

ORDER BY 
    energy_to_gdp_ratio DESC

LIMIT 5;

-- What is the correlation between GDP growth and energy production growth?
WITH base AS (
    SELECT 
        p.country,
        p.con_year,
        SUM(p.production) AS production,
        g.value_g AS gdp
    FROM production p
    JOIN gdp_3 g
    ON p.country = g.country
    AND p.con_year = g.con_year
    GROUP BY p.country, p.con_year, g.value_g
),

growth AS (
    SELECT 
        country,
        con_year,
        production - LAG(production) OVER (
            PARTITION BY country ORDER BY con_year
        ) AS production_growth,
        gdp - LAG(gdp) OVER (
            PARTITION BY country ORDER BY con_year
        ) AS gdp_growth
    FROM base
),

clean AS (
    SELECT *
    FROM growth
    WHERE production_growth IS NOT NULL
      AND gdp_growth IS NOT NULL
)

SELECT 
    ROUND(
        (
            AVG(production_growth * gdp_growth)
            - AVG(production_growth) * AVG(gdp_growth)
        )
        /
        (
            STDDEV(production_growth) * STDDEV(gdp_growth)
        ),
    4) AS correlation_between_gdp_and_production_growth
FROM clean;


-- How does energy production per capita vary across countries? -- combine all the yrs in one country
SELECT 
    p.country,

    SUM(p.production) AS total_production,
    SUM(pop.value_0) AS total_population,

    ROUND(
        SUM(p.production) / NULLIF(SUM(pop.value_0), 0),
        6
    ) AS production_per_capita

FROM production p

JOIN population pop
    ON p.country = pop.countries
    AND p.con_year = pop.con_year

GROUP BY 
    p.country

ORDER BY 
    production_per_capita DESC;
    
-- Which countries have the highest energy consumption relative to GDP? -- 
SELECT 
    c.country,
    c.con_year,
    SUM(c.consumption) AS total_consumption,
    g.value_g AS gdp,
    ROUND(SUM(c.consumption) / g.value_g, 6) AS energy_to_gdp_ratio
FROM consumption c
JOIN gdp_3 g
ON c.country = g.country
AND c.con_year = g.con_year
GROUP BY c.country, c.con_year, g.value_g
ORDER BY energy_to_gdp_ratio DESC limit 5;

-- What is the correlation between GDP growth and energy production growth?
WITH base AS (
    SELECT 
        p.country,
        p.con_year,
        SUM(p.production) AS production,
        g.value_g AS gdp
    FROM production p
    JOIN gdp_3 g
    ON p.country = g.country
    AND p.con_year = g.con_year
    GROUP BY p.country, p.con_year, g.value_g
),

growth AS (
    SELECT 
        country,
        con_year,
        production,
        gdp,

        production - LAG(production) OVER (
            PARTITION BY country ORDER BY con_year
        ) AS production_growth,

        gdp - LAG(gdp) OVER (
            PARTITION BY country ORDER BY con_year
        ) AS gdp_growth
    FROM base
),

clean AS (
    SELECT 
        production_growth,
        gdp_growth
    FROM growth
    WHERE production_growth IS NOT NULL
      AND gdp_growth IS NOT NULL
)

SELECT 
    ROUND(
        (
            AVG(production_growth * gdp_growth)
            - AVG(production_growth) * AVG(gdp_growth)
        )
        /
        (
            STDDEV(production_growth) * STDDEV(gdp_growth)
        ),
    4) AS correlation_between_gdp_and_energy_production_growth
FROM clean;

--  Global Comparisons

-- What are the top 10 countries by population and how do their emissions compare?
WITH pop_rank AS (
    SELECT 
        countries AS country,
        SUM(value_0) AS total_population
    FROM population
    GROUP BY countries
    ORDER BY total_population DESC
    LIMIT 10
)

SELECT 
    p.countries AS country,
    SUM(p.value_0) AS population,
    SUM(e.emission) AS total_emissions
FROM pop_rank pr
JOIN population p 
    ON pr.country = p.countries
JOIN emission_3 e 
    ON p.countries = e.country
    AND p.con_year = e.con_year
GROUP BY p.countries
ORDER BY population DESC;
-- Which countries have improved (reduced) their per capita emissions the most over the last decade?
WITH base AS (
    SELECT 
        e.country,
        e.con_year,
        SUM(e.emission) / NULLIF(SUM(pop.Value_0), 0) AS per_capita_emission
    FROM emission_3 e
    JOIN population pop
    ON e.country = pop.countries
    AND e.con_year = pop.con_year
    GROUP BY e.country, e.con_year
),

trend AS (
    SELECT 
        country,
        con_year,
        per_capita_emission,

        per_capita_emission - LAG(per_capita_emission)
        OVER (PARTITION BY country ORDER BY con_year) AS change_value
    FROM base
)

SELECT 
    country,
    SUM(change_value) AS total_reduction
FROM trend
WHERE con_year >= (
    SELECT MAX(con_year) - 10 
    FROM emission_3
)
GROUP BY country
ORDER BY total_reduction ASC;

-- What is the global share (%) of emissions by country?
WITH total_global AS (
    SELECT SUM(emission) AS global_emission
    FROM emission_3)
SELECT country, SUM(emission) AS country_emission,
	ROUND((SUM(emission) / (SELECT global_emission FROM total_global)) * 100,2
    ) AS emission_share_percent
FROM emission_3
GROUP BY country
ORDER BY emission_share_percent DESC;

-- What is the global average GDP, emission, and population by year?

SELECT g.con_year,
	AVG(g.value_g) AS avg_gdp,AVG(e.emission) AS avg_emission,
    AVG(p.Value_0) AS avg_population
FROM gdp_3 g
JOIN emission_3 e
	ON g.country = e.country
    AND g.con_year = e.con_year
JOIN population p
    ON g.country = p.countries
    AND g.con_year = p.con_year
GROUP BY g.con_year
ORDER BY g.con_year;
