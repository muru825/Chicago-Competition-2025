***********************************************
* Graphs for Project
* 'When Work Disappears'
***********************************************

* David Dorn
* This version: March 28, 2018

* Input files: graph_bygender.dta, graph_gap.dta

cap log close
set more off
clear all

* Figure 1A: Impact of Import Competition on Male and Female Earnings by Earnings Percentile (in $2015)

use ../dta/graph_bygender.dta, clear

gen top_inc=dcipt_dmlev_inc_100_ci_hi if dcipt_dmlev_inc_100_ci_hi>dcipt_dflev_inc_100_ci_lo
replace top_inc=dcipt_dflev_inc_100_ci_hi if dcipt_dmlev_inc_100_ci_hi>dcipt_dflev_inc_100_ci_hi
gen bot_inc=dcipt_dflev_inc_100_ci_lo if dcipt_dmlev_inc_100_ci_hi>dcipt_dflev_inc_100_ci_lo
replace bot_inc=dcipt_dmlev_inc_100_ci_lo if dcipt_dmlev_inc_100_ci_lo>dcipt_dflev_inc_100_ci_lo
twoway (rarea dcipt_dmlev_inc_100_ci* per, pstyle(ci) color(blue*.05)) (rarea dcipt_dflev_inc_100_ci* per, pstyle(ci) color(red*.05)) (rarea top_inc bot_inc per, cmissing(n) pstyle(ci) color(purple*.1)) (connected dcipt_dmlev_inc_100_b per, msize(vsmall) color(blue)) (connected dcipt_dflev_inc_100_b per, msize(vsmall) color(red)) if per<=95, xtitle("Percentile of Income Distribution") ytitle("Dollars (2015)") legend(order(4 5) label(4 "Male Earnings") label(5 "Female Earnings") size(small)) ylabel(-6000(1000)0, labsize(small)) xlabel(0(10)100, labsize(small)) xscale(r(0))
graph save ../gph/Fig1A-OverallShock-9014-GenderEarnings-Dollars-0095-Noheading.gph, replace
graph export ../gph/Fig1A-OverallShock-9014-GenderEarnings-Dollars-0095-Noheading.eps, replace

* Figure 1B: Impact of Import Competition on Male-Female Earnings Gap by Earnings Percentile (in Percentage of Initial Male Earnings Level)

use ../dta/graph_gap.dta, clear

twoway (rarea dcipt_mfgap_per_100_ci* per, pstyle(ci) color(maroon*.05)) (connected dcipt_mfgap_per_100_b per, msize(small) color(maroon)) if per>=20 & per<=95, xtitle("Percentile of Income Distribution") ytitle("Percentage of Male Earnings") legend(off) xlabel(0(10)100, labsize(small)) ylabel(-14(2)0, labsize(small))
graph save ../gph/Fig1B-OverallShock-9014-EarningsGap-Percentage-2095-Noheading.gph, replace
graph export ../gph/Fig1B-OverallShock-9014-EarningsGap-Percentage-2095-Noheading.eps, replace

