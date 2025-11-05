# STATA-PortfolioCode


# README – Gender and Labor Data Task

### **Overview**

In this project, I created a pair of synthetic datasets using Python to simulate **county-level economic and gender-related data** for 2024.
The goal was to build a dataset that mirrors the structure of the **PREDOC pollution–mortality exercise**, but focused on **gender gaps and education effects in economics**.

I have created a data structure that is a panel with:

**Cross-sectional units** : County × Gender combinations (58 counties × 2 genders = 116 panels)
**Time dimension**: Daily observations throughout 2024 (366 days)

This project demonstrates skills in:

* Data cleaning and merging
* Generating and summarizing statistics
* Creating data visualizations
* Running regressions and interpreting coefficients
* Thinking critically about identification and causality

---

## **Files**

###  `synthetic-data-generation.ipynb` [Link](https://github.com/abhys28/STATA-PortfolioCode/blob/0fa7ff174ecaba4009a47c6191f90b0633e4081a/synthetic-data-generation.ipynb)

I wrote this Python script to generate two CSV datasets:

* `county_wages_2024.csv`
* `county_education_2024.csv`

Each dataset captures realistic variation in wages, education, and demographics across **58 California counties** in 2024.

To run the script:

```bash
jupyter notebook synthetic-data-generation.ipynb
```

It will output the two CSV files in your current directory.

---

## **Dataset Descriptions**

### 1. `county_wages_2024.csv` [Link](https://github.com/abhys28/STATA-PortfolioCode/blob/f4d43726432b58cad22d93d080ae420bd0438628/county_education_2024.csv)

**Daily-level panel data** with 42,394 observations (intentionally incomplete for cleaning practice).

| Column | Description |
|--------|-------------|
| `county_code` | Numeric identifier (1-58) |
| `county_name` | County name (County_1, County_2, ...) |
| `date` | Date in YYYY-MM-DD format |
| `gender` | Male or Female |
| `wage` | Average hourly wage (USD) |
| `hours` | Average hours worked per week |
| `employment_rate` | Employment rate (0-1) |
| `population` | County population |
| `urban` | Binary indicator: 1 = urban, 0 = rural |

**Expected structure:** 58 counties × 366 days (2024 is a leap year) × 2 genders = 42,504 rows  
**Actual rows:** 42,394 (missing one full month for one county)

**Key features:**
- **Gender wage gap**: Women earn approximately $3 less per hour than men on average
- **Missing data**: One randomly selected county is missing an entire month of data
- **Daily granularity**: Allows for time-series analysis practice

### 2. `county_education_2024.csv` [Link](https://github.com/abhys28/STATA-PortfolioCode/blob/f4d43726432b58cad22d93d080ae420bd0438628/county_wages_2024.csv)

**County-level cross-sectional data** with 58 observations.

| Column | Description |
|--------|-------------|
| `county_code` | Numeric identifier (1-58) |
| `county_name` | County name |
| `region` | Geographic region (North, Central, South) |
| `urban` | Binary indicator: 1 = urban, 0 = rural |
| `education_avg` | Average years of education |
| `college_share` | Share of population with college degree (0-1) |
| `median_income` | Median household income (USD) |


---

## **Data Generation Logic**

### Wage Determination

The synthetic wage is calculated using the following formula:

```
wage = base_wage + gender_effect + education_effect + random_noise
```

Where:
- **Base wage**: ~$30/hour (with variation)
- **Gender effect**: -$3 for women (based on literature [1])
- ###  Education Effect

Education contributes **$0.8/hour per extra year of average schooling**.
This is based on the **Mincer equation**, which suggests that each additional year of education produces an individual a rate of return to schooling of about 5–8% per year, ranging from a low of 1% to more than 20% in some countries. Check References [2] Hence, here I assume that counties with more educated populations have slightly higher wages, roughly +$0.8 per additional year of average schooling above 12.
- **Random noise**: Adds realistic individual-level variation
I added small random shocks to wages, hours, and employment to make the dataset more natural and ensure no perfect patterns.

---

### Missing Data Pattern

To simulate real-world data issues:
- One random county is missing an entire month of data
- This creates an opportunity to practice identifying and handling missing data in Stata or other tools

---

## **Stata Do-File Overview**

### [`master_analysis.do`](https://github.com/abhys28/STATA-PortfolioCode/blob/main/master_analysis.do)

This is the **core Stata script** demonstrating my data cleaning, visualization, and econometric analysis workflow. It reproduces the kinds of empirical tasks common in **RA and pre-doc assignments**.

#### **Structure & Sections**

1. **Data Processing and Summarizing**

   * Imports and saves raw CSVs as `.dta` files
   * Merges the wage and education datasets using `county_code`
   * Converts date formats, checks for missing data, and produces summary statistics

2. **Visualizing the Data**

   * Creates **kernel density plots** of wages by gender
   * Produces **time series plots** of female wages over 2024 for a selected county
   * Exports publication-ready `.png` graphs

3. **Analysis: Gender, Education, and Wages**

   * Runs regressions of wages on gender with **county and time fixed effects** using `reghdfe`
   * Interprets the estimated gender wage gap (`β₁ ≈ -3.0`)
   * Demonstrates use of Stata’s high-dimensional FE tools (`ftools`, `reghdfe`)

#### **Outputs**

* Cleaned datasets (`.dta`), merged Excel file (`merged.xlsx`)
* Visualizations (`WageDistribution.png`, `AverageWageWomen.png`)
* Regression results output to the console

#### **Skills Demonstrated**

* Efficient **data cleaning** and **merging**
* Advanced **panel data management**
* Use of **visualization** and **fixed-effects regression tools**
* Reproducible workflow design

---
## **License**

This project uses fully **synthetic data** generated for educational and demonstration purposes only.
It contains no real individuals or sensitive information.

---

## **Author Note**

I built this dataset and documentation as part of a project to simulate real-world economic data tasks like those used in research assistant applications and data analysis training. It’s meant to demonstrate the experience working with structured, interpretable data that captures core empirical relationships between **gender, education, and economic outcomes**.

---

