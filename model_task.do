********************************************************************************
*MASTER DO-FILE
*********************************************************************************

***PURPOSE:
*I built this dataset and documentation as part of a project to simulate real-world economic data tasks like those used 
*in research assistant applications and data analysis training. It’s meant to demonstrate the experience working with structured, 
*interpretable data that captures core empirical relationships between gender, education, and economic outcomes.

*Table of Contents
*Inputs/Outputs
*Technical Information
********************************************************************************


*ssc install egenmore
*ssc install nvals
*ssc install unique
*ssc install reghdfe

cd "C:\Users\lubi\Desktop\Abhi's Desktop\Learning\Coding and econometrics\STATA_Practice\PREDOC 2025\Portfolio"
clear
set more off

import delimited "county_education_2024.csv", clear
save "county_edu.dta",replace

import delimited "county_wages_2024.csv", clear
save "county_wa.dta", replace


******SECTION 1: Data Processing and Summarizing *******************************

**Input files and investigate structure

//Inputting the first dataset for investigation

use "county_edu.dta", clear
desc

//Inputting the second dataset for investigation
use "county_wa.dta", clear
desc

//Converting date variable from string to stata date format for better analysis
gen datevar = date(date, "YMD")
format datevar %td
save "county_wa.dta", replace

//Creating a unique id for each obersvation for better analysis
egen uid = group(county_code date gender)
order uid county_code county_name date gender wage hours employment_rate population urban datevar
sort uid


*QUES  1. Merge the two datasets using county_code as the key. Describe how you handled missing values or duplicates.

//Merging
merge m:1 county_code using "county_edu.dta", assert(match) 
 //The assert here is KEY because it ensures that each observation in the master dataset matches with the counterpart in the using dataset
 //If not the code is broken 
 
drop date _merge //Cleaning at every step
export excel using "merged", firstrow(variables) replace

*QUES  2. Produce a table with the mean, median, min, max, and standard deviation for:Wage, Hours worked and Employment rate

tabstat wage hours employment_rate, columns(statistics) statistics(me med mi max sd ) // mean, median, minimum, maximum, and standard deviation
*esttab using "summ.csv", replace title("Summary Stats")

*QUES 3. Produce a table with the same statistics for wages, but split by gender. Include the number of observations in each group.

tabstat wage, statistics(mi me max sd med N) by( gender)

*QUES 4: Does the table you produced provide any evidence that the data quality may be systematically different?
//What other evidence would help support this conclusion (discuss, but do not produce, the evidence)?


*QUES 5: Aggregate the data to a county-date level, where each observation represents the average wage and employment for that day (or month) across genders.
*Describe how you aggregated the data and handled differences in reporting frequency.

collapse (mean) wage employment_rate, by(county_name county_code datevar gender hours education_avg college_share median_income)

*QUES 6: How many counties are missing months?

 //THE KEY in this question is to understand that they aren't directly asking if theres a date cell with missing value for a county rather if some counties
  //have missing rows i.e. info on that day itself is missing. Which can only be found if we check that for each county all 366 unique days are present

sort county_code datevar gender
bys county_code: egen missmonths = nvals(datevar)
unique county_code if missmonths<12

*QUES 7: Max wages by gender (use of locals)
* Calculate maximum wages by gender
summarize wage if gender=="Male", meanonly
local male_max = r(max)

summarize wage if gender=="Female", meanonly
local female_max = r(max)

* Display the values
display "Male max wage: `male_max'"
display "Female max wage: `female_max'"

//OUTPUT: Number of unique values of county_code is  1
//So basically one county has one or more months missing 
//But we can tab missmonths to identify that only 1 month's data is missing because
//missmonths = 11. 


******SECTION 2: Visualizing the Data********************************************

*QUES 1: Create a distribution plot of wages by gender. 

twoway (kdensity wage if gender=="Male", lcolor(navy)) ///
       (kdensity wage if gender=="Female", lcolor(maroon) lpattern(dash)), ///
       legend(label(1 "Male") label(2 "Female")) ///
	   title("Wage Distribution by Gender") ///
       xtitle("Hourly Wage") ytitle("Density") ///
	   graphregion(fcolor("white"))
	   
*QUES 2: Create a time series plot showing the average wage for men in any one county (e.g., Los Angeles or Cook County) across 2024.
*Do you observe persistent gaps or convergence?
preserve
keep if gender == "Male"
xtset county_code datevar
twoway (tsline wage if county_code == 2 & month(datevar) == 8) 

restore

	   
	   
*now do women; is there a difference?
*QUES 3: Produce a scatter plot showing the relationship between county average education and the gender wage gap (male mean wage – female mean wage).
*Add a regression line.

//county average education and the gender wage gap

*bys county_code: egen wage_gap =

********SECTION 3: Gender, Education, and Wages******************

*QUES 1: Estimate the model and report the coefficient beta1

