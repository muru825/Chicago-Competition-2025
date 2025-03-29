use temp, clear
keep mat*
foreach n of numlist $mn(1)99 {
  local x = `n'*2-($mn*2-1)
  local y = `x'+1
  quietly gen b`n' = mat`x'
  quietly gen v`n' = mat`y'
}
drop mat*
drop if b99==.
save temp, replace
drop v*
xpose, clear
rename v1 b
gen per = _n+$mn-1
save b, replace
use temp, clear
drop b*
xpose, clear
rename v1 v
gen per = _n+$mn-1
save v, replace
merge 1:1 per using b, nogenerate
sort per
gen se = sqrt(v)
gen ci_lo = b-1.96*se
gen ci_hi = b+1.96*se


