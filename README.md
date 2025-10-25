# STATA-PortfolioCode


# 📘 README – Gender and Labor Data Task

### **Overview**

In this project, I created a pair of synthetic datasets and a Python script to simulate **county-level economic and gender-related data** for 2024.
The goal was to build a dataset that mirrors the structure of the **PREDOC pollution–mortality exercise**, but focused on **gender gaps and education effects in economics**.

This project is demonstrates skills in:

* Data cleaning and merging
* Generating and summarizing statistics
* Creating data visualizations
* Running regressions and interpreting coefficients
* Thinking critically about identification and causality

---

## **Files**

### 🧮 `generate_gender_econ_data.py`

I wrote this Python script to generate two CSV datasets:

* `county_wages_2024.csv`
* `county_education_2024.csv`

Each dataset captures realistic variation in wages, education, and demographics across **58 California counties** for **12 months in 2024**.

To run the script:

```bash
python generate_gender_econ_data.py
```

It will output the two CSV files in your current directory.

---

### 📄 `county_wages_2024.csv`

**Unit of observation:** County × Gender × Month
(58 counties × 12 months × 2 genders = 1,392 rows)

| Variable          | Description                              |
| ----------------- | ---------------------------------------- |
| `county_code`     | Numeric county identifier                |
| `county_name`     | County name                              |
| `date`            | Month (YYYY-MM-DD)                       |
| `gender`          | Male or Female                           |
| `wage`            | Average hourly wage (USD)                |
| `hours`           | Average weekly hours worked              |
| `employment_rate` | Share of working-age population employed |
| `population`      | County population                        |
| `urban`           | 1 = Urban county, 0 = Rural county       |

#### How I generated this:

* I started with a **base wage** around $30/hour.
* I applied a **gender effect**, where females earn $3/hour less on average.
* I added an **education effect**: for every extra year of average schooling in a county, wages rise by **$0.8/hour**.
* I included random noise to make the data more realistic, with some seasonal and urban–rural variation.

---

### 🎓 `county_education_2024.csv`

**Unit of observation:** County (58 rows)

| Variable        | Description                          |
| --------------- | ------------------------------------ |
| `county_code`   | Numeric county identifier            |
| `county_name`   | County name                          |
| `region`        | Region (North, Central, South)       |
| `urban`         | 1 = Urban, 0 = Rural                 |
| `education_avg` | Average years of schooling           |
| `college_share` | Share of adults with college degrees |
| `median_income` | Median household income (USD)        |

#### How I generated this:

I created county-level characteristics that vary realistically by region:

* Urban counties have higher education and income levels.
* Rural counties have lower education levels but more employment volatility.
* Education ranges roughly from 11 to 16 years on average, with corresponding changes in median income.

---

## **Analytical Design**

### 🎯 Gender Effect

I built in a **gender wage gap of about $3/hour**, which allows for clear analysis of gender differences in labor market outcomes.

### 🎓 Education Effect

Education contributes **$0.8/hour per extra year of average schooling**.
This is based on the **Mincer equation**, which suggests that each additional year of education produces an individual a rate of return to schooling of about 5–8% per year, ranging from a low of 1% to more than 20% in some countries. Check References [2] Hence, here I assume that counties with more educated populations have slightly higher wages, roughly +$0.8 per additional year of average schooling above 12.


### ⚙️ Randomization

I added small random shocks to wages, hours, and employment to make the dataset more natural and ensure no perfect patterns.

---

## **Dependencies**

I used:

* Python ≥ 3.8
* pandas
* numpy

Install them with:

```bash
pip install pandas numpy
```

---

## **License**

This project uses fully **synthetic data** generated for educational and demonstration purposes only.
It contains no real individuals or sensitive information.

---

## **Author Note**

I built this dataset and documentation as part of a project to simulate real-world economic data tasks like those used in research assistant applications and data analysis training. It’s meant to demonstrate the experience working with structured, interpretable data that captures core empirical relationships between **gender, education, and economic outcomes**.

---

