***********************************************
* Regression Analysis for Project
* 'When Work Disappears'
***********************************************

* David Dorn
* First version: April 23, 2013
* This version: October 17, 2018

* Input file: workfile9014wwd.dta


cap log close
set more off
clear all
set memory 500m


log using ../log/czone_analysis_wwd.log, replace text

use ../dta/workfile9014wwd.dta, clear


***********************************************
* Treatment and Control Variables
***********************************************

local iv_mainshock (d_impusch_p9=d_impotch_p9_lag)
local iv_gendershock (d_impuschm_p9cen d_impuschf_p9cen=d_impotchm_p9cen_lag d_impotchf_p9cen_lag)

local cs_controls l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2
local race_controls l_sh_pop_black l_sh_pop_asian l_sh_pop_oth l_sh_pop_hispanic


***********************************************
* Table 1A: Mfg Employment by Gender
***********************************************

foreach v in sh_empl_mfg_age1839 sh_empl_mfg_age1839m sh_empl_mfg_age1839f {
   disp "*** descriptives `v' ***"
   summ l_`v' d_`v' [aw=timepwt24]
   summ l_`v' d_`v' [aw=timepwt24] if yr==1990
   summ l_`v' d_`v' [aw=timepwt24] if yr==2000
   disp "*** outcome `v', overall trade shock ***"
   ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
   disp "*** outcome `v', male vs female industry shock ***"
   ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}


***********************************************
* TABLE 1B: Employment Status Gap
***********************************************

foreach v in gender_gap_emp_1839 gender_gap_unemp_1839 gender_gap_nonemp_1839 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}


***********************************************
* Table 1C: Earnings Gap
***********************************************

foreach v in gender_gap_inc1839p25 gender_gap_inc1839p50 gender_gap_inc1839p75 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}


***********************************************
* TABLE 1D: Idleness
***********************************************

foreach v in gender_gap_emp_1825 gender_gap_edunoemp_1825 gender_gap_noedunoemp_1825 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
 }
 
 * alternative definition of idleness w/o unemployment
 foreach v in gender_gap_noedunoempnoue_1825 {
     disp "*** descriptives `v' ***"
     summ l_`v' d_`v' [aw=timepwt24]
     summ l_`v' d_`v' [aw=timepwt24] if yr==1990
     summ l_`v' d_`v' [aw=timepwt24] if yr==2000
     disp "*** outcome `v', overall trade shock ***"
     ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
     disp "*** outcome `v', male vs female industry shock ***"
     ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
  }
 
 
***********************************************
* TABLE 2A: Male Share among Residents
***********************************************
 
foreach v in sh_male1839 sh_male1825 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
 }


***********************************************
* TABLE 2B: Cumulative Mortality Gap, 1990-2015
***********************************************

foreach v in total poisoning hiv homicide suicide accident rest {
	disp "*** descriptives `v' ***"
    summ cum_mortmfgap_`v' cum_mortm_`v' cum_mortf_`v' [aw=timepwt24]
    summ cum_mortmfgap_`v' [aw=timepwt24] if yr==1990
    summ cum_mortmfgap_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls cum_mortmfgap_`v' `iv_mainshock' `race_controls' `cs_controls' cum_mortmfgap_total_lag [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls cum_mortmfgap_`v' `iv_gendershock' `race_controls' `cs_controls' cum_mortmfgap_total_lag [aw=timepwt24], cluster(statefip) noheader
 }


***********************************************
* TABLE 3A: Women's Marital Status
***********************************************
  
foreach v in sh_fem1839_marrexsep sh_fem1839_widdivsep sh_fem1839_single {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}


***********************************************
* TABLE 3B: Birth Rate, 1990-2016
***********************************************

foreach v in birthrate2039 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}


***********************************************
* TABLE 3B: Women w/ Children, Unmarried Mothers
***********************************************

foreach v in sh_fem1839_child sh_mom1839_nomarr {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}


***********************************************
* TABLE 3C: Children's Poverty Status
***********************************************
 
foreach v in sh_kids0017_hh_poor {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}
 

***********************************************
* TABLE 3D: Women's Household Type
***********************************************

foreach v in sh_fem1839_hhspouse sh_fem1839_hhpartner sh_fem1839_noidentpartner {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}
  
  
***********************************************
* TABLE 3E: Children's Household Type
***********************************************
 
foreach v in sh_kids0017_hhhparent_spouse sh_kids0017_hhhparent_partner sh_kids0017_hhhparent_single sh_kids0017_hhhgpother {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}
 
* additional statistic: share of children in HH type and poor, 1990 (division by total share of children in HH type yields poverty rate)
foreach v in sh_kids0017_hhspouse_poor sh_kids0017_hhpartner_poor sh_kids0017_hhsingle_poor sh_kids0017_hhgpoth_poor {
   summ l_`v' [aw=timepwt24] if yr==1990
}


***********************************************
* APPENDIX TABLE 1: Summary of Import Shock
***********************************************

summ d_impusch_p9 d_impuschm_p9cen d_impuschf_p9cen [aw=timepwt24], detail
by yr, sort: summ d_impusch_p9 d_impuschm_p9cen d_impuschf_p9cen [aw=timepwt24], detail

* additional statistics: correlation overall trade shock with gender-specific shocks 
pwcorr d_impusch_p9 d_impuschm_p9cen d_impuschf_p9cen [aw=timepwt24]
by yr, sort: pwcorr d_impusch_p9 d_impuschm_p9cen d_impuschf_p9cen [aw=timepwt24]

* additional statistics: descriptives control variables
summ `cs_controls' `race_controls' [aw=timepwt24]
 
 
***********************************************
* APPENDIX TABLE 2: Manufacturing Employment Share
***********************************************

* OLS and 2SLS analyses for 1990s and 2000s
foreach v in sh_empl_mfg_age1839 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', IPR shock, 1990s ***"
    reg d_`v' d_impusch_p9 [aw=timepwt24] if yr==1990, cluster(statefip) 
    ivregress 2sls d_`v' `iv_mainshock' [aw=timepwt24] if yr==1990, cluster(statefip) first 
    disp "*** outcome `v', IPR shock, 2000s ***"
    reg d_`v' d_impusch_p9 [aw=timepwt24] if yr==2000, cluster(statefip) 
    ivregress 2sls d_`v' `iv_mainshock' [aw=timepwt24] if yr==2000, cluster(statefip) first 
    disp "*** outcome `v', IPR shock, stacked with controls ***"
    ivregress 2sls d_`v' `iv_mainshock' reg* t2 [aw=timepwt24], cluster(statefip) first
    ivregress 2sls d_`v' `iv_mainshock' l_shind_manuf_cbp reg* t2 [aw=timepwt24], cluster(statefip) first
    ivregress 2sls d_`v' `iv_mainshock' l_shind_manuf_cbp reg* l_sh_routine33 l_task_outsource t2 [aw=timepwt24], cluster(statefip) first
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) first
 }   

* reduced-form OLS analyses for 1970s and 1980s
use ../dta/workfile7090wwd.dta, clear

foreach v in sh_empl_mfg_age1839 {
    disp "*** descriptives `v' ***"
    summ d_imp23otch_p9_lag [aw=timepwt20] if yr==1970
    summ l_`v' d_`v' [aw=timepwt20] if yr==1970
    summ l_`v' d_`v' [aw=timepwt20] if yr==1980
    disp "*** outcome `v', IPR shock, 1970s ***"
    reg d_`v' d_imp23otch_p9_lag l_shhrs_manuf_cen [aw=timepwt20] if yr==1970, cluster(statefip) 
    disp "*** outcome `v', IPR shock, 1980s ***"
    reg d_`v' d_imp23otch_p9_lag l_shhrs_manuf_cen [aw=timepwt20] if yr==1980, cluster(statefip)    
}  

* reduced-form OLS analyses for 1990s and 2000s
keep if yr==1980
keep czone d_imp23otch_p9_lag
sort czone 
save temp.dta, replace
use ../dta/workfile9014wwd.dta, clear
sort czone
merge czone using temp.dta
assert _merge==3
drop _merge
erase temp.dta

foreach v in sh_empl_mfg_age1839 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', IPR shock, 1990s ***"
    reg d_`v' d_imp23otch_p9_lag l_shhrs_manuf_cen [aw=timepwt24] if yr==1990, cluster(statefip) 
    disp "*** outcome `v', IPR shock, 2000s ***"
    reg d_`v' d_imp23otch_p9_lag l_shhrs_manuf_cen [aw=timepwt24] if yr==2000, cluster(statefip)    
}  


***********************************************
* APPENDIX TABLE 3: Employment, Earnings and Idleness by Gender
***********************************************
 
foreach v in sh_emp_age1839m sh_unemp_age1839m sh_nonemp_age1839m sh_emp_age1839f sh_unemp_age1839f sh_nonemp_age1839f {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}
	
foreach v in inc1839m_p25 inc1839m_p50 inc1839m_p75 inc1839f_p25 inc1839f_p50 inc1839f_p75 {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}
 
foreach v in sh_emp_age1825m sh_edunoemp_age1825m sh_noedunoemp_age1825m sh_emp_age1825f sh_edunoemp_age1825f sh_noedunoemp_age1825f {
    disp "*** descriptives `v' ***"
    summ l_`v' d_`v' [aw=timepwt24]
    summ l_`v' d_`v' [aw=timepwt24] if yr==1990
    summ l_`v' d_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
}


***********************************************
* APPENDIX TABLE 4: Cumulative Mortality by Gender, 1990-2015
***********************************************

foreach v in total poisoning hiv homicide suicide accident rest {
	disp "*** descriptives `v' ***"
    summ cum_mortm_`v' cum_mortf_`v' [aw=timepwt24]
    summ cum_mortm_`v' cum_mortf_`v' [aw=timepwt24] if yr==1990
    summ cum_mortm_`v' cum_mortf_`v' [aw=timepwt24] if yr==2000
    disp "*** outcome `v', overall trade shock ***"
    ivregress 2sls cum_mortm_`v' `iv_mainshock' `race_controls' `cs_controls' cum_mortmfgap_total_lag [aw=timepwt24], cluster(statefip) noheader
	ivregress 2sls cum_mortf_`v' `iv_mainshock' `race_controls' `cs_controls' cum_mortmfgap_total_lag [aw=timepwt24], cluster(statefip) noheader
    disp "*** outcome `v', male vs female industry shock ***"
    ivregress 2sls cum_mortm_`v' `iv_gendershock' `race_controls' `cs_controls' cum_mortmfgap_total_lag [aw=timepwt24], cluster(statefip) noheader
	ivregress 2sls cum_mortf_`v' `iv_gendershock' `race_controls' `cs_controls' cum_mortmfgap_total_lag [aw=timepwt24], cluster(statefip) noheader
 }

 
 ***********************************************
 * APPENDIX TABLE 5: Outcomes for non-Hispanic whites
 *********************************************** 

 foreach v in gender_gap_wt_emp_1839 *gender_gap_wt_inc1839p50 sh_fem1839wt_marrexsep sh_mom1839wt_nomarr sh_kids0017wt_hh_poor sh_kids0017wt_hhhparent_single {
     disp "*** descriptives `v' ***"
     summ l_`v' d_`v' [aw=timepwt24]
     summ l_`v' d_`v' [aw=timepwt24] if yr==1990
     summ l_`v' d_`v' [aw=timepwt24] if yr==2000
     disp "*** outcome `v', overall trade shock ***"
     ivregress 2sls d_`v' `iv_mainshock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
     disp "*** outcome `v', male vs female industry shock ***"
     ivregress 2sls d_`v' `iv_gendershock' `race_controls' `cs_controls' [aw=timepwt24], cluster(statefip) noheader
 }

log close
