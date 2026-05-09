# Energy-Consumption-Analysis
# Energy Consumption Analysis using SQL | Global Sustainability & Economic Insights

##  Project Overview

This project focuses on analyzing the relationship between **energy consumption, GDP growth, carbon emissions, and population trends** using **MySQL**.
A fully normalized relational database named **ENERGYDB** was designed to integrate fragmented global datasets into one analytical framework.

The project helps uncover:

* Global emission trends
* Economic growth vs environmental impact
* Energy production & consumption patterns
* Per-capita sustainability indicators
* Correlation between GDP growth and energy demand

---

#  Key Highlights

Designed a **relational MySQL database** with normalized tables
Performed advanced SQL analytics using:

* CTEs
* Window Functions
* Aggregate Functions
* Correlation Analysis
* Subqueries
* Joins

Built analytical queries for:

* Emission trends
* GDP comparisons
* Energy efficiency
* Population impact
* Sustainability metrics

Created insights useful for:

* Climate policy analysis
* Sustainable development research
* Energy economics
* Business intelligence dashboards

---

# Database Architecture

### Database Name:

```sql
ENERGYDB
```

### Main Tables:

| Table Name  | Description             |
| ----------- | ----------------------- |
| country_3   | Master country table    |
| emission_3  | Carbon emission data    |
| population  | Population statistics   |
| production  | Energy production data  |
| consumption | Energy consumption data |
| gdp_3       | GDP statistics          |

---

#  Skills Used

* MySQL
* SQL Query Optimization
* CTEs
* Window Functions
* Data Analysis
* Relational Database Design
* Sustainability Analytics
* Business Intelligence Concepts

---

#  Major SQL Analysis Performed

## General & Comparative Analysis

* Total emissions by country
* Top GDP countries
* Energy production vs consumption
* Highest emission-producing energy sources

## Trend Analysis

* Year-over-year global emission trends
* GDP growth trends
* Population impact on emissions
* Energy consumption growth analysis

## Ratio & Per Capita Analysis

* Emission-to-GDP ratio
* Energy consumption per capita
* Production per capita
* Energy intensity analysis

## Advanced Analytics

* GDP vs Energy Production Correlation
* Global emission share by country
* Sustainability trend analysis
* Per-capita emission reduction tracking

---

# Example Advanced SQL Concepts Used

## Common Table Expressions (CTEs)

```sql
WITH emission_change AS (
    SELECT 
        country,
        con_year,
        AVG(per_capita_emission) AS avg_per_capita_emission
    FROM emission_3
    GROUP BY country, con_year
)
SELECT * FROM emission_change;
```

---

## Window Functions

```sql
LAG(SUM(emission)) OVER (ORDER BY con_year)
```

Used for:

* Trend analysis
* Growth calculations
* Year-over-year comparisons

---

## Correlation Analysis

```sql
ROUND(
(
AVG(production_growth * gdp_growth)
- AVG(production_growth) * AVG(gdp_growth)
)
/
(
STDDEV(production_growth) * STDDEV(gdp_growth)
),4)
```

Used to measure:

### GDP Growth ↔ Energy Production Growth Relationship

---

# Key Insights

### Environmental Findings

* High GDP growth countries often showed increased emissions.
* Some nations demonstrated signs of sustainable growth through reduced per-capita emissions.
* Energy consumption remains strongly tied to industrial development.

### Energy Insights

* Significant gaps exist between energy production and consumption across countries.
* Certain energy types contribute disproportionately to emissions.

### Economic Insights

* Rapid economic expansion still relies heavily on energy-intensive activities.
* Population growth significantly impacts energy demand and carbon output.

---

# Project Outputs

The project includes:

* SQL analytical outputs
* Trend analysis reports
* Sustainability comparisons
* Relational schema design
* PowerPoint presentation for business insights

---

# Business Problem

As global sustainability challenges increase, energy, GDP, population, and emission datasets remain fragmented across multiple sources.

Without an integrated analytical framework:

* Historical trends are difficult to analyze
* Per-capita environmental impact remains unclear
* Economic growth sustainability cannot be properly measured

This project solves that problem by building a centralized relational database for unified analysis.

---

# Project Objectives

* Build a normalized relational database for global energy analytics
* Analyze sustainability trends using SQL
* Measure economic growth impact on emissions
* Create data-driven insights for policy and strategy decisions

---

# Tools & Technologies

| Tool       | Purpose               |
| ---------- | --------------------- |
| MySQL      | Database & Querying   |
| SQL        | Data Analysis         |
| PowerPoint | Business Presentation |
| Excel/CSV  | Data Sources          |

---

# Project Structure

```bash
📁 Energy-Consumption-Analysis
 ┣ 📄 Energy Consumption Analysis.sql
 ┣ 📄 Project Presentation.pptx
 ┣ 📄 README.md
```

---

#  Learning Outcomes

Through this project, I improved my understanding of:

* Advanced SQL querying
* Database normalization
* Analytical problem-solving
* Sustainability data analysis
* Business intelligence thinking

---

#  Why This Project Matters

This project demonstrates how SQL can be used not only for database management but also for solving real-world sustainability and economic problems through data analysis.

It combines:

* Data Engineering
* Data Analytics
* Environmental Economics
* Business Intelligence

into one integrated analytical solution.

---

#  About Me

I am an MBA graduate with experience in operations and logistics, transitioning into Data Analytics.
I enjoy solving business problems using data and building analytical solutions that support decision-making.

---

#  If You Like This Project

Feel free to:

* Star ⭐ the repository
* Fork 🍴 the project
* Connect with me on LinkedIn

---



