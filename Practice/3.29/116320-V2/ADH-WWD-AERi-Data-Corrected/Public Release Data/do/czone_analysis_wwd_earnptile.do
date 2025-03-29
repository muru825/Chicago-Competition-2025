***********************************************
* Effect of China Import Penetration on 
* Earnings by Percentile of Earnings Distribution
***********************************************

* First version: Oscar Suen, June 15, 2017
* This version: David Dorn, March 28, 2018

* Input file: workfile9014wwd.dta, czone9014_percentiles.dta

* Output file: graph_gap.dta


***********************************************
* Administrative Commands
***********************************************

cap log close
set more off
clear all
set memory 500m
set maxvar 10000

*log using ../log/czone_analysis_wwd_earnptile.log, replace text


***********************************************
* Part I: Gender Gap in Earnings
***********************************************

set obs 99
gen per=_n
save tempres, replace
use ../dta/czone9014_percentiles.dta, clear

merge 1:1 czone yr using ../dta/workfile9014wwd.dta
drop _m


***********************************************
* Treatment and Control Variables
***********************************************

local iv_mainshock (d_impusch_p9=d_impotch_p9_lag)

local cs_controls l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2
local race_controls l_sh_pop_black l_sh_pop_asian l_sh_pop_oth l_sh_pop_hispanic


***********************************************
* Gender Gap in Earnings
***********************************************

foreach p of numlist 1(1)99 {
   gen l_mfgap_inc1839p`p'=l_inc1839m_p`p'-l_inc1839f_p`p'
   gen d_mfgap_inc1839p`p'=d_inc1839m_p`p'-d_inc1839f_p`p'
}

foreach v of numlist 1(1)99 {
   quietly summ d_mfgap_inc1839p`v' [aw=timepwt24]
   if r(max)==0 {
      disp "*** outcome `v' === 0 ***"
      global mn = `v'+1
   }
   else {
   quietly ivregress 2sls d_mfgap_inc1839p`v' (d_impusch_p9=d_impotch_p9_lag) `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
   estimates store main`v'
   }
}

save results, replace

estimates table main*, keep(d_impusch_p9) se
matrix mat = r(coef)
svmat double mat
save temp, replace

do percentiles_help.do
save t.dta, replace

foreach v in t {
  use `v'.dta, clear
  foreach var in b v se ci_* {
    rename `var' dcip`v'_mfgap_inc_100_`var'
  }
  save `v'.dta, replace
  use tempres, clear
  merge 1:1 per using `v', nogenerate
  save tempres, replace
  erase `v'.dta
}
  
use results, clear
estimates clear
* earnings gap in percent of initial male earnings
foreach p of numlist 1(1)33 {
  by t2, sort: summ l_inc1839m_p`p' [aw=timepwt24], detail
  gen l_inc1839m_p`p'win=r(p5)
  replace l_inc1839m_p`p'win=l_inc1839m_p`p' if l_inc1839m_p`p'>l_inc1839m_p`p'win
}

foreach p of numlist 1(1)33 {
   gen d_mfrel2_inc1839p`p'=100*(d_mfgap_inc1839p`p'/l_inc1839m_p`p'win)
}
foreach p of numlist 34(1)99 {
   gen d_mfrel2_inc1839p`p'=100*(d_mfgap_inc1839p`p'/l_inc1839m_p`p')
}

foreach v of numlist 1(1)99 {
   quietly summ d_mfrel2_inc1839p`v' [aw=timepwt24]
   if r(N)<=25 | (r(max)==0 & r(min)==r(max)) {
     disp "*** outcome d_mfrel2_inc1839p`v' === 0 ***"
     global mn=`v'+1
   }
   else {
   quietly ivregress 2sls d_mfrel2_inc1839p`v' (d_impusch_p9=d_impotch_p9_lag) `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
   estimates store per`v'
   }
}

save results, replace

estimates table per*, keep(d_impusch_p9) se
matrix mat = r(coef)
svmat double mat
save temp, replace

do percentiles_help.do
save t.dta, replace

erase temp.dta
erase b.dta
erase v.dta

foreach v in t {
  use `v'.dta, clear
  foreach var in b v se ci_* {
    rename `var' dcip`v'_mfgap_per_100_`var'
  }
  save `v'.dta, replace
  use tempres, clear
  merge 1:1 per using `v', nogenerate
  save tempres, replace
  erase `v'.dta
}
 
erase results.dta
save ../dta/graph_gap.dta, replace
erase tempres.dta


***********************************************
* Part II: Male Earnings
***********************************************

clear all
set memory 500m
set maxvar 10000
set obs 99
gen per=_n
save tempres, replace
use ../dta/czone9014_percentiles.dta, clear

merge 1:1 czone yr using ../dta/workfile9014wwd.dta
drop _m


***********************************************
* Treatment and Control Variables
***********************************************

local iv_mainshock (d_impusch_p9=d_impotch_p9_lag)

local cs_controls l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2
local race_controls l_sh_pop_black l_sh_pop_asian l_sh_pop_oth l_sh_pop_hispanic


***********************************************
* Male Earnings
***********************************************

foreach v of numlist 1(1)99 {
   quietly summ d_inc1839m_p`v' [aw=timepwt24]
   if r(max)==0 {
      disp "*** outcome `v' === 0 ***"
      global mn = `v'+1
   }
   else {
   quietly ivregress 2sls d_inc1839m_p`v' (d_impusch_p9=d_impotch_p9_lag) `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
   estimates store main`v'
   }
}

save results, replace

estimates table main*, keep(d_impusch_p9) se
matrix mat = r(coef)
svmat double mat
save temp, replace

do percentiles_help.do
save t.dta, replace

foreach v in t {
  use `v'.dta, clear
  foreach var in b v se ci_* {
    rename `var' dcip`v'_dmlev_inc_100_`var'
  }
  save `v'.dta, replace
  use tempres, clear
  merge 1:1 per using `v', nogenerate
  save tempres, replace
  erase `v'.dta
}
  
erase results.dta
save ../dta/graph_male.dta, replace
erase tempres.dta


***********************************************
* Part III: Female Earnings
***********************************************

clear all
set memory 500m
set maxvar 10000
set obs 99
gen per=_n
save tempres, replace
use ../dta/czone9014_percentiles.dta, clear

merge 1:1 czone yr using ../dta/workfile9014wwd.dta
drop _m


***********************************************
* Treatment and Control Variables
***********************************************

local iv_mainshock (d_impusch_p9=d_impotch_p9_lag)

local cs_controls l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2
local race_controls l_sh_pop_black l_sh_pop_asian l_sh_pop_oth l_sh_pop_hispanic


***********************************************
* Female Earnings
***********************************************

foreach v of numlist 1(1)99 {
   quietly summ d_inc1839f_p`v' [aw=timepwt24]
   if r(max)==0 {
      disp "*** outcome `v' === 0 ***"
      global mn = `v'+1
   }
   else {
   quietly ivregress 2sls d_inc1839f_p`v' (d_impusch_p9=d_impotch_p9_lag) `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
   estimates store main`v'
   }
}

save results, replace

estimates table main*, keep(d_impusch_p9) se
matrix mat = r(coef)
svmat double mat
save temp, replace

do percentiles_help.do
save t.dta, replace

foreach v in t {
  use `v'.dta, clear
  foreach var in b v se ci_* {
    rename `var' dcip`v'_dflev_inc_100_`var'
  }
  save `v'.dta, replace
  use tempres, clear
  merge 1:1 per using `v', nogenerate
  save tempres, replace
  erase `v'.dta
}
  
erase results.dta
save ../dta/graph_female.dta, replace
erase tempres.dta
erase temp.dta
erase v.dta
erase b.dta


***********************************************
* Merge Files for Male and Female Earnings
***********************************************

use ../dta/graph_male.dta, clear
merge 1:1 per using ../dta/graph_female.dta
drop _m
save ../dta/graph_bygender.dta, replace
erase ../dta/graph_male.dta
erase ../dta/graph_female.dta



*log close



