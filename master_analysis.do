*********************************************************************************
*MASTER DO-FILE
*********************************************************************************

***PURPOSE:

*I built this dataset and documentation as part of a project to simulate real-world economic data tasks like those used 
*in PREDOC and research assistant applications and data analysis training. It’s meant to demonstrate my experience working with data
* cleaning, visualization and analysis.

***TABLE OF CONTENTS:

 *Section 1: Data Processing and Summarizing
 *Section 2: Visualizing the Data
 *Section 3: Analysis - Gender, Education, and Wages

***INPUTS:

 *.csv Files - county_wages_2024.csv and county_wages_2024.csv
 
***OUTPUTS:

 *.dta Files  - county_wa.dta, county_edu.dta
 *.xlsx Files - merged.xlsx
 *.png Files  - WageDistribution.png, AverageWageWomen.png



***Technical Information

********************************************************************************


***Notes:

// used as in-line comments and answers to tasks
* used as section dividers and headers

*Installing necessary packages

*ssc install egenmore
*ssc install unique
*ssc install reghdfe
*ssc install ftools

clear
set more off
cd "Your Path" //Add your directory


import delimited "county_education_2024.csv", clear
save "county_edu.dta",replace

import delimited "county_wages_2024.csv", clear
save "county_wa.dta", replace


******SECTION 1: Data Processing and Summarizing *******************************

******QUES 1: Merge the two datasets using county_code as the key. 

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

//Merging
merge m:1 county_code using "county_edu.dta", assert(match) 
 //The assert here is KEY because it ensures that each observation in the master dataset matches with the counterpart in the using dataset
 //If not the code is broken 
 
drop date _merge //Cleaning at every step

export excel using "merged", firstrow(variables) replace

*QUES  2. Produce a table with the mean, median, min, max, and standard deviation for:Wage, Hours worked and Employment rate

tabstat wage hours employment_rate, columns(statistics) statistics(me med mi max sd ) // mean, median, minimum, maximum, and standard deviation

*QUES 3. Produce a table with the same statistics for wages, but split by gender. Include the number of observations in each group.

tabstat wage, statistics(mi me max sd med N) by( gender)

*QUES 4: Aggregate the data to a county-date level, where each observation represents the average wage and employment for that day (or month) across genders.
*Describe how you aggregated the data and handled differences in reporting frequency.

collapse (mean) wage employment_rate, by(county_name county_code datevar gender hours education_avg college_share median_income)

*QUES 5: How many counties are missing months?

sort county_code datevar gender
bys county_code: egen missmonths = nvals(datevar)
levelsof county_code if  missmonths<366, local(missingcounties)
di "County with a missing month of data: County " `missingcounties'

  //So one county is missing data for a month.
  
******SECTION 2: Visualizing the Data********************************************

*QUES 1: Create a distribution plot of wages by gender. 

twoway (kdensity wage if gender=="Male", lcolor(navy)) ///
       (kdensity wage if gender=="Female", lcolor(maroon) lpattern(dash)), ///
       legend(label(1 "Male") label(2 "Female")) ///
	   title("Wage Distribution by Gender") ///
       xtitle("Hourly Wage") ytitle("Density") ///
	   graphregion(fcolor("white"))
graph export "WageDistribution.png", replace
	   
*QUES 2: Create a time series plot showing the average wage for women in any one county across 2024.

preserve

keep if gender == "Female"
tsset county_code datevar, daily
twoway(tsline wage if county_code == 2), ///
       title("Average Wage for Women across 2024") ///
       ytitle("{bf}Hourly Wage") xtitle("{bf}Time") ///
	   graphregion(fcolor("white")) ///
       xlabel(#12, format(%tmMon))
graph export "AverageWageWomen.png", replace
	   
restore
	   

********SECTION 3: Analysis - Gender, Education, and Wages******************

*QUES 1: Estimate the association between wages and gender by running the following regression:
* Wagesit = ß0 + ß1Genderit +ai +at
*where ai and at are fixed effects for county i and time t. Report and interpret ß1.

//Destringing gender variable
gen gencode = (gender == "Male")
reghdfe wage gencode, absorb(county_code datevar)

// ß1 = 3.025 and significant







