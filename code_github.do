///Final cleaning/ data preparation


use "...\cleaned.dta", clear


gen weight_p_b = 100
gen weight_p_26 = (weight_26) / weight_b *100
gen weight_p_12 = (weight_12) / weight_b *100


gen pa_intervention = 1 if pa_ref ==1 & treatment_allocation==1
replace pa_intervention = 2 if pa_ref ==0 & treatment_allocation==1
replace pa_intervention = 3 if treatment_allocation==2
label define pa_int 1 "M3 with referral" 2 "M3 no referral" 3 "Standard care"
label values pa_intervention pa_int


*******************
///Missing data description
*******************

gen __b = .
label var __b "Baseline"
gen _26 =.
label var _26 "6-month"
gen _12 =.
label var _12 "12-month"

count
drop if missing(treatment_allocation)
count

count if treatment_allocation==1
count if treatment_allocation==2

local outfile "...\Missing.xlsx"

putexcel set "`outfile'", sheet("Baseline", replace) modify

local num = 2

putexcel A1 = "Variable"
putexcel B1 = "Visit"
putexcel C1 = "Total missing"
putexcel D1 = "% Total"
putexcel E1 = "M3 missing"
putexcel F1 = "% M3"
putexcel G1 = "Control missing"
putexcel H1 = "% Control"

foreach var in treatment_allocation age sex eths trial_site {
mdesc `var' 

putexcel A`num'= "`var'"
putexcel B`num'= "Baseline"
putexcel C`num'= (r(miss))
putexcel D`num'= (round(r(percent),0.1))
mdesc `var' if treatment_allocation==1
putexcel E`num'= (r(miss))
putexcel F`num'= (round(r(percent),0.1))
mdesc `var'  if treatment_allocation==2
putexcel G`num'= (r(miss))
putexcel H`num'= (round(r(percent),0.1))
local num = `num'+1
	
}
*/
drop if missing(age)
count
count if treatment_allocation==1
count if treatment_allocation==2

//missing any follow up data

egen n_nonmiss = rownonmiss( ///
    weight_26 height_26 ffm_26 fm_26 bmi_26 fat_p_26 fm_ratio_26 ///
    hba1c_26 hdl_26 tc_26 ldl_26 tg_26 sbp_26 dbp_26 enmo_26 ///
    t_sleep_26 SED_26 a_sleep_26 Nvalid_days_26 steps_26 MVPA_26 ///
    MVPA_g_26 season_26 weight_p_26 ///
    weight_12 height_12 ffm_12 fm_12 bmi_12 fat_p_12 fm_ratio_12 ///
    hba1c_12 hdl_12 tc_12 ldl_12 tg_12 sbp_12 dbp_12 enmo_12 ///
    t_sleep_12 SED_12 a_sleep_12 Nvalid_days_12 steps_12 MVPA_12 ///
    MVPA_g_12 season_12 WASO_12 weight_p_12 ///
)

drop if n_nonmiss == 0
drop n_nonmiss
count
count if treatment_allocation==1
count if treatment_allocation==2

local outfile "...\Missing.xlsx"
putexcel set "`outfile'", sheet("Adip_move", replace) modify

local num = 2

putexcel A1 = "Variable"
putexcel B1 = "Visit"
putexcel C1 = "Total missing"
putexcel D1 = "% Total"
putexcel E1 = "M3 missing"
putexcel F1 = "% M3"
putexcel G1 = "Control missing"
putexcel H1 = "% Control"


foreach var in weight_b weight_26 weight_12 bmi_b bmi_26 bmi_12 fm_b fm_26 fm_12 ffm_b ffm_26 ffm_12  fat_p_b fat_p_26 fat_p_12 fm_ratio_b fm_ratio_26 fm_ratio_12 enmo_b enmo_26 enmo_12 t_sleep_b t_sleep_26 t_sleep_12 SED_b SED_26 SED_12 a_sleep_b a_sleep_26 a_sleep_12 steps_b steps_26 steps_12 MVPA_b MVPA_26 MVPA_12 WASO_b WASO_26 WASO_12  {
mdesc `var' 

local vlab : variable label `var'
local suffix = substr("`var'", -2, 2)
local vlab : variable label _`suffix'
putexcel A`num'= "`var'"
putexcel B`num'= "`vlab'"
putexcel C`num'= (r(miss))
putexcel D`num'= (round(r(percent),0.1))
mdesc `var' if treatment_allocation==1
putexcel E`num'= (r(miss))
putexcel F`num'= (round(r(percent),0.1))
mdesc `var'  if treatment_allocation==2
putexcel G`num'= (r(miss))
putexcel H`num'= (round(r(percent),0.1))
local num = `num'+1
}

foreach var in MVPA SED steps enmo t_sleep a_sleep WASO {
	foreach thing in _b _26 _12 {
			preserve
			drop if missing(`var'`thing')
			mdesc season`thing' Nvalid_days`thing'
			restore
	}
} 


//missing cardiometabolic data

putexcel set "`outfile'", sheet("Cardiometabolic", replace) modify 

local num = 2

putexcel A1 = "Variable"
putexcel B1 = "Visit"
putexcel C1 = "Total missing"
putexcel D1 = "% Total"
putexcel E1 = "M3 missing"
putexcel F1 = "% M3"
putexcel G1 = "Control missing"
putexcel H1 = "% Control"


foreach var in hba1c_b hba1c_26 hba1c_12 hdl_b hdl_26 hdl_12 tc_b tc_26 tc_12 ldl_b ldl_26 ldl_12 tg_b tg_26 tg_12 sbp_b sbp_26 sbp_12 dbp_b dbp_26 dbp_12 {
mdesc `var' 

local vlab : variable label `var'
local suffix = substr("`var'", -2, 2)
local vlab : variable label _`suffix'
putexcel A`num'= "`var'"
putexcel B`num'= "`vlab'"
putexcel C`num'= (r(miss))
putexcel D`num'= (round(r(percent),0.1))
mdesc `var' if treatment_allocation==1
putexcel E`num'= (r(miss))
putexcel F`num'= (round(r(percent),0.1))
mdesc `var'  if treatment_allocation==2
putexcel G`num'= (r(miss))
putexcel H`num'= (round(r(percent),0.1))
local num = `num'+1
	
}

drop __b _12 _26




******************
//////Baseline table
*******************



baselinetable   																/*
*/	age(cts tab("p50 (p25, p75)"))										/*
*/	sex(cat countformat(%15.0fc))  /*
*/	eths(cat countformat(%15.0fc))												/*
*/	imd(cat countformat(%15.0fc))												/*
*/	t2d_duration(cts tab("p50 (p25, p75)") medianformat(%5.0f))												/*
*/	bmi_b(cts tab("p50 (p25, p75)"))												/*
*/	weight_b(cts tab("p50 (p25, p75)"))												/*
*/	fm_b(cts tab("p50 (p25, p75)"))											/*
*/	ffm_b(cts tab("p50 (p25, p75)"))											/*
*/	fm_ratio_b(cts tab("p50 (p25, p75)") medianformat(%5.2f) minmaxformat(%5.2f))	/*
*/	fat_p_b(cts tab("p50 (p25, p75)") 	medianformat(%5.0f) minmaxformat(%5.0f))		/*
*/	sbp_b(cts tab("p50 (p25, p75)") medianformat(%5.0f) minmaxformat(%5.0f))		/*
*/	dbp_b(cts tab("p50 (p25, p75)") medianformat(%5.0f) minmaxformat(%5.0f))		/*
*/	hba1c_b(cts tab("p50 (p25, p75)")) 											/*
*/	tc_b(cts tab("p50 (p25, p75)")) 											/*
*/	ldl_b(cts tab("p50 (p25, p75)")) 											/*
*/	hdl_b(cts tab("p50 (p25, p75)"))											/*
*/	tg_b(cts tab("p50 (p25, p75)"))											/*
*/	MVPA_b(cts tab("p50 (p25, p75)"))											/*
*/	steps_b(cts tab("p50 (p25, p75)") medianformat(%5.0f) minmaxformat(%5.0f))	/*
*/	enmo_b(cts tab("p50 (p25, p75)"))	/*
*/	SED_b(cts tab("p50 (p25, p75)"))											/*
*/	t_sleep_b(cts tab("p50 (p25, p75)"))											/*
*/	a_sleep_b(cts tab("p50 (p25, p75)"))												/*
*/	WASO_b(cts tab("p50 (p25, p75)"))											/*
*/	dpp4i_b(cat countformat(%15.0fc))											/*
*/	sulfonylurea_b(cat countformat(%15.0fc))												/*
*/	any_glpbased_b(cat countformat(%15.0fc))												/*
*/	semaglutide_sc_b(cat countformat(%15.0fc))											/*
*/	tirzepatide_b(cat countformat(%15.0fc))												/*
*/	glp1ra_b(cat countformat(%15.0fc))												/*
*/	insulin_b(cat countformat(%15.0fc))												/*
*/	metformin_b(cat countformat(%15.0fc))											/*
*/	sglt2_b(cat countformat(%15.0fc))												/*
*/	pioglitazone_b(cat countformat(%15.0fc))												/*
*/	antihyp_b(cat countformat(%15.0fc))												/*
*/	lipidlower_b(cat countformat(%15.0fc))												/*
*/	trial_site(cat countformat(%15.0fc))												/*
*/	, by(treatment_allocation, totalcolum) catvartab("# (%)")  exportexcel("...\Baseline", replace)


/// Table intervention components recieved


preserve

keep if treatment_allocation ==1

baselinetable   /*
*/	wl_i(cat countformat(%15.0fc))												/*
*/	pa_ref(cat countformat(%15.0fc))												/*
*/	diet_ref(cat countformat(%15.0fc))	/*
*/	psych_ref(cat countformat(%15.0fc))	/*	
*/	cgm_ref(cat countformat(%15.0fc))	/*	
*/	,catvartab("# (%)")  exportexcel("...\Components", replace)
restore

count if treatment_allocation ==2 & wl_i ==0 // footnote of table









*********************************************************
///Objective 1 change in adiposity/PA with intervention
*********************************************************

//weight  - waterfall plot

foreach var in weight_p bmi {
	gen `var'_c = `var'_12 - `var'_b
}
bysort treatment_allocation: sum weight_p_c bmi_c

bysort treatment_allocation (weight_p_c): gen num = _N -_n
replace num = . if missing(weight_p_c)

twoway bar weight_p_c num if treatment_allocation ==1, color(blue*0.5)  /*
*/ xlabel("") xtitle("") xscale(noline) title("The M3 intervention") name("C",replace) yline(0, lpattern(solid)) ytitle("Change in weight (%)", size(*1.2)) note("C", pos(10) size(*1.5))

twoway bar weight_p_c num if treatment_allocation ==2, color(red*0.5) /*
*/  xtitle("") xscale(off) xlabel("") title("Standard care") name("D",replace) yline(0, lpattern(solid)) ytitle("Change in weight (%)", size(*1.2)) note("D", pos(10) size(*1.5))

graph combine C D, rows(1) imargins(0) ycommon altshrink name("Weight_waterfall",replace)
drop num 

//bmi - waterfall plot

bysort treatment_allocation (bmi_c): gen num = _N -_n
replace num = . if missing(bmi_c)


twoway bar bmi_c num if treatment_allocation ==1, color(blue*0.5)  /*
*/ xlabel("") xtitle("") xscale(noline) title("The M3 intervention") name("A",replace) yline(0, lpattern(solid)) ytitle("Change in BMI (kg/m{superscript:2})", size(*1.2)) note("A", pos(10) size(*1.5))

twoway bar bmi_c num if treatment_allocation ==2, color(red*0.5) /*
*/  xtitle("") xscale(off) xlabel("") title("Standard care") name("B",replace) yline(0, lpattern(solid)) ytitle("Change in BMI (kg/m{superscript:2})", size(*1.2)) note("B", pos(10) size(*1.5))

graph combine A B, rows(1) imargins(0) ycommon altshrink name("BMI_waterfall",replace)
drop num 

graph combine BMI_waterfall Weight_waterfall , rows(2) imargins(0) altshrink name("adipos_waterfall",replace)

graph export "...\adipos_waterfall.png", as(png) name("adipos_waterfall") replace

drop weight_c bmi_c


//MVPA  - waterfall plot

foreach var in MVPA {
	gen `var'_c = `var'_12 - `var'_b
}

bysort treatment_allocation: sum MVPA_c

bysort treatment_allocation (MVPA_c): gen num = _N -_n
replace num = . if missing(MVPA_c)

twoway bar MVPA_c num if treatment_allocation ==1, color(blue*0.5)  /*
*/ xlabel("") xtitle("") xscale(noline) title("The M3 intervention") name("E",replace) yline(0, lpattern(solid)) ytitle("Change in MVPA (min/day)", size(*1.2)) note("A", pos(10) size(*1.5)) xscale(reverse)

twoway bar MVPA_c num if treatment_allocation ==2, color(red*0.5) /*
*/  xtitle("") xscale(off) xlabel("") title("Standard care") name("F",replace) yline(0, lpattern(solid)) ytitle("Change in MVPA (min/day)", size(*1.2)) note("B", pos(10) size(*1.5)) xscale(reverse)

graph combine E F, rows(1) imargins(0) ycommon altshrink name("MVPA_waterfall",replace)
drop num 

graph export "...\MVPA_waterfall.png", as(png) name("MVPA_waterfall") replace

drop MVPA_c



//prepare data for MMRM models - convert to long format

foreach var in weight_ height_ bmi_ ffm_ fm_ratio_ fm_ fat_p_ hba1c_ tc_ hdl_ ldl_ tg_ sbp_ dbp_ WASO_ weight_p_ enmo_ t_sleep_ SED_ a_sleep_ Nvalid_days_ steps_ MVPA_ MVPA_g_ season_ {
	gen `var'1 = `var'b
}

reshape long weight_ height_ bmi_ ffm_ fm_ratio_ fm_ fat_p_ hba1c_ tc_ hdl_ ldl_ tg_ sbp_ dbp_ WASO_ weight_p_ enmo_ t_sleep_ SED_ a_sleep_ Nvalid_days_ steps_ MVPA_ MVPA_g_ season_ , i(record_id) j(visit)
replace visit = 2 if visit ==26
replace visit = 3 if visit ==12
tab visit
drop if visit==1

foreach var in weight_ height_ bmi_ ffm_ fm_ratio_ fm_ fat_p_ hba1c_ tc_ hdl_ ldl_ tg_ sbp_ dbp_ WASO_ weight_p_ enmo_ t_sleep_ SED_ a_sleep_  steps_ MVPA_ MVPA_g_  {
	gen `var'c =  `var' - `var'b
}

rename season_ season_fu
rename Nvalid_days_ Nvalid_days_fu

replace weight_p_b = weight_b // to ensure that baseline val captures variation in absolute measure.



//explore AIC to determine best correlation structure


preserve
clear 
tempfile aic
save `aic', emptyok
restore

foreach outcome in weight bmi ffm fm_ratio fm fat_p weight_p {

	foreach structure in ind exc ar ma unstructured banded to exp {
		cap qui mixed `outcome'_c i.treatment_allocation##i.visit c.`outcome'_b##i.visit age i.sex i.eths i.trial_site c.hba1c_b || record_id:, noconstant residuals(`structure', t(visit)) reml

	if e(converged) ==1 {
		qui estat ic 
		local AIC_weight_`structure' = r(S)[1,5]
		}
	else {
		local AIC_weight_`structure' =0
	}
	preserve
	clear
	set obs 1 
	gen outcome = "`outcome'"
	gen structure = "`structure'"
	gen aic = `AIC_weight_`structure''
	append using `aic'
	save `aic', replace
	restore
	}
}

//separate to adjust for season and nvalid days 
foreach outcome in MVPA SED steps enmo t_sleep a_sleep WASO {

	foreach structure in ind exc ar ma unstructured banded to exp {
		cap qui mixed `outcome'_c i.treatment_allocation##i.visit c.`outcome'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site i.season_b i.season_fu c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(`structure', t(visit)) reml

	if e(converged) ==1 {
		qui estat ic 
		local AIC_weight_`structure' = r(S)[1,5]
		}
	else {
		local AIC_weight_`structure' =0
	}
	preserve
	clear
	set obs 1 
	gen outcome = "`outcome'"
	gen structure = "`structure'"
	gen aic = `AIC_weight_`structure''
	append using `aic'
	save `aic', replace
	restore
	}
}


preserve
use `aic', clear
replace aic = 99999999999999999 if aic ==0
bysort outcome (aic): gen lowest =1 if _n==1
replace aic =0  if aic >100000000
list if lowest==1
export excel using "...\AIC_obesity.xlsx", firstrow(variables) replace
restore


preserve
clear
tempfile covar_structure
save `covar_structure',emptyok
restore


foreach outcome in weight weight_p bmi ffm fm_ratio fm fat_p MVPA SED steps enmo t_sleep a_sleep WASO {
	preserve
	qui import excel "...\AIC_obesity.xlsx", clear firstrow
	qui keep if outcome == "`var'" 
	sort structure //unstructured is last 
	local aic_unstruc = aic[_N] 
	if `aic_unstruc' !=0 {
		qui keep if structure == "unstructured"
		local `outcome'_corr = structure[1]
	}
	else {
		qui keep if lowest ==1
		local `outcome'_corr = structure[1]
	}
	clear 
	set obs 1
	gen outcome = "`outcome'"
	gen structure = "``outcome'_corr'"
	append using `covar_structure'
	save `covar_structure', replace
	restore
}
preserve
use `covar_structure', clear
save "...\covar_structure.dta", replace
restore



**********************************
////MAIN ANALYSIS ADIPOSITY/////
***********************************

bysort treatment_allocation: distinct record_id if !missing(bmi_c)  & visit==3
bysort treatment_allocation: distinct record_id if !missing(weight_c)  & visit==3

preserve
clear
tempfile adiposity 
save `adiposity', emptyok
restore

local num = 0
foreach var in bmi weight weight_p fm ffm fm_ratio fat_p {
	
		forval i = 1/2 {
		preserve
		keep if treatment_allocation== `i'
		bysort record_id: keep if _n ==1 
		sum `var'_b, detail
		local `var'_b`i' = `r(mean)'
		restore
	}
	preserve 
	drop if missing(`var'_c)
	local `var'_obs = _N
	bysort record_id: keep if _n ==1 
	local `var'_partic = _N
	restore
	
	
	preserve 
	use "...\covar_structure.dta", clear
	keep if outcome == "`var'"
	local structure = structure[1]
	restore
	
	
	mixed `var'_c i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site || record_id:, noconstant residuals(unstructured, t(visit)) reml


	margins, dydx(treatment_allocation) at(visit=3)

		local `var'_beta = -r(table)[1,2]
		local `var'_beta_uci = -r(table)[5,2]
		local `var'_beta_lci = -r(table)[6,2]
		local `var'_beta_p = r(table)[4,2]
		
	margins treatment_allocation, at(visit=3)

		local `var'_m3 = r(table)[1,1]
		local `var'_m3_uci = r(table)[6,1]
		local `var'_m3_lci = r(table)[5,1]
		local `var'_con = r(table)[1,2]
		local `var'_con_uci = r(table)[6,2]
		local `var'_con_lci = r(table)[5,2]

	preserve
	clear
	set obs 1 
	local num = `num' +1
	gen order = `num'
	gen outcome = "`var'"
	gen m3_baseline = string(``var'_b1', "%9.2f") 
	gen m3_change = string(``var'_m3', "%9.2f") + " (" + string(``var'_m3_lci', "%9.2f") + ", " + string(``var'_m3_uci', "%9.2f") + ")"
	gen con_baseline = string(``var'_b2', "%9.2f") 
	gen con_change = string(``var'_con', "%9.2f") + " (" + string(``var'_con_lci', "%9.2f") + ", " + string(``var'_con_uci', "%9.2f") + ")"
	gen diff = string(``var'_beta', "%9.2f") + " (" + string(``var'_beta_lci', "%9.2f") + ", " + string(``var'_beta_uci', "%9.2f") + ")"
	gen diff_p = string(``var'_beta_p', "%9.3f")
	append using `adiposity'
	save `adiposity',replace
	restore
}


preserve
use `adiposity', clear
gen note = ""
replace note = "Weight (kg): `weight_partic' participants `weight_obs' observations; Weight (%): `weight_p_partic' participants `weight_p_obs' observations; BMI: `bmi_partic' participants `bmi_obs' observations; Fat mass: `fm_partic' participants `fm_obs' observations; Fat-free mass: `ffm_partic' participants `ffm_obs' observations; Fat mass:Fat-free mass ratio: `fm_ratio_partic' participants `fm_ratio_obs' observations; Percentage body fat: `fat_p_partic' participants `fat_p_obs' observations" in 1

sort order
drop order
replace m3_baseline = "100" if outcome == "weight_p"
replace con_baseline = "100" if outcome == "weight_p"
export excel using "...\Adiposity_outcomes.xlsx", firstrow(variables) replace
restore


////Change in adiposity subgroup

bysort treatment_allocation: distinct record_id
bysort treatment_allocation: distinct record_id if tirzepatide_b==1 | semaglutide_sc_b==1
bysort treatment_allocation: distinct record_id if tirzepatide_b==0 & semaglutide_sc_b==0


preserve
clear
tempfile adiposity_sg 
save `adiposity_sg', emptyok
restore


local num = 0

foreach var in bmi weight weight_p fm ffm fm_ratio fat_p {
	
		forval i = 1/2 {
			preserve
			drop if tirzepatide_b==1 | semaglutide_sc_b==1
			drop if missing(`var'_c)
			drop if missing(wl_i)
			keep if treatment_allocation== `i' & wl_i == 0
			bysort record_id: keep if _n ==1 
			sum `var'_b, detail
			local `var'no_wl_b_`i' = `r(mean)'
			local `var'no_wl_n_`i' = _N
			restore
			
			preserve
			drop if tirzepatide_b==1 | semaglutide_sc_b==1
			drop if missing(`var'_c)
			drop if missing(wl_i)
			keep if treatment_allocation== `i' & wl_i == 1
			bysort record_id: keep if _n ==1 
			sum `var'_b, detail
			local `var'wl_b_`i' = `r(mean)'
			local `var'wl_n_`i' = _N
			restore
		}
	
	local num = `num' +1
	
	preserve 
	drop if tirzepatide_b==1 | semaglutide_sc_b==1
	drop if missing(`var'_c)
	drop if missing(wl_i)
	local `var'_obs = _N
	bysort record_id: keep if _n ==1 
	local `var'_partic = _N
	restore
	
	mixed `var'_c i.treatment_allocation##i.visit##i.wl_i c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site || record_id:, noconstant residuals(`structure', t(visit)) reml
	
	margins treatment_allocation#wl_i, at(visit=3) contrast(wald)
	local int = r(table)[4,1]
		
	margins treatment_allocation, at(wl_i=0 visit=3)
	forval i = 1/2 {
	local `var'no_wl_`i' = r(table)[1,`i']
	local `var'no_wl_`i'_lci = r(table)[5,`i']
	local `var'no_wl_`i'_uci = r(table)[6,`i']
	}
	

	margins treatment_allocation, at(wl_i=1 visit=3)
	forval i = 1/2 {
	local `var'wl_`i' = r(table)[1,`i']
	local `var'wl_`i'_lci = r(table)[5,`i']
	local `var'wl_`i'_uci = r(table)[6,`i']
	}

	forval i = 1/2 {
		margins, dydx(wl_i) at(treatment_allocation=`i' visit=3)
		local `var'_beta`i' = -r(table)[1,2]
		local `var'_beta`i'_uci = -r(table)[6,2]
		local `var'_beta`i'_lci = -r(table)[5,2]
		local `var'_beta`i'_p = r(table)[4,2]
	}
		
	preserve
	clear
	set obs 2
	local num = `num' +1
	gen order = `num'
	gen outcome = "`var'"
	gen group = .
	gen number_wl = ""
	gen baseline_wl = "" 
	gen change_wl = ""
	gen number_no_wl = ""
	gen baseline_no_wl = "" 
	gen change_no_wl = ""
	gen diff_change = ""
	gen p_diff_change = ""
	gen interaction_p = string(`int', "%9.3f") in 1
	forval i = 1/2 {
		replace group = `i' in `i'
		
		replace number_wl = string(``var'wl_n_`i'', "%9.0f") in `i'
		replace baseline_wl = string(``var'wl_b_`i'', "%9.2f") in `i'
		replace change_wl = string(``var'wl_`i'', "%9.2f") + " (" + string(``var'wl_`i'_lci', "%9.2f") + ", " + string(``var'wl_`i'_uci', "%9.2f") + ")" in `i'
		
		replace number_no_wl = string(``var'no_wl_n_`i'', "%9.0f") in `i'
		replace baseline_no_wl = string(``var'no_wl_b_`i'', "%9.2f") in `i'
		replace change_no_wl = string(``var'no_wl_`i'', "%9.2f") + " (" + string(``var'no_wl_`i'_lci', "%9.2f") + ", " + string(``var'no_wl_`i'_uci', "%9.2f") + ")" in `i'
		replace diff_change= string(-``var'_beta`i'', "%9.2f") + " (" + string(-``var'_beta`i'_lci', "%9.2f") + ", " + string(-``var'_beta`i'_uci', "%9.2f") + ")" in `i'
		replace p_diff_change= string(``var'_beta`i'_p', "%9.3f") in `i' 
	}	
	
	append using `adiposity_sg'
	save `adiposity_sg',replace
	restore

}

preserve
use `adiposity_sg', clear
gen note = ""
replace note = "Weight (kg): `weight_partic' participants `weight_obs' observations; Weight (%): `weight_p_partic' participants `weight_p_obs' observations; BMI: `bmi_partic' participants `bmi_obs' observations; Fat mass: `fm_partic' participants `fm_obs' observations; Fat-free mass: `ffm_partic' participants `ffm_obs' observations; Fat mass:Fat-free mass ratio: `fm_ratio_partic' participants `fm_ratio_obs' observations; Percentage body fat: `fat_p_partic' participants `fat_p_obs' observations" in 1
sort order group
drop order
label define m3 1 "The M3 Intervention" 2 "Standard Care"
label values group m3
export excel using "...\Adiposity_outcomes_sg.xlsx", firstrow(variables) replace
restore




**********************************
////MAIN ANALYSIS PHYSICAL BEHAVIOUR/////
***********************************

bysort treatment_allocation: distinct record_id if !missing(MVPA_c) & visit==3

preserve
clear
tempfile adiposity 
save `adiposity', emptyok
restore

local num = 0
foreach var in MVPA SED steps enmo t_sleep a_sleep WASO  {
	
		forval i = 1/2 {
		preserve
		keep if treatment_allocation== `i'
		bysort record_id: keep if _n ==1 
		sum `var'_b, detail
		local `var'_b`i' = `r(mean)'
		restore
	}
	
	preserve 
	drop if missing(`var'_c) 
	drop if missing(season_b) | missing(season_fu) | missing(Nvalid_days_b) | missing(Nvalid_days_fu)
	local `var'_obs = _N
	bysort record_id: keep if _n ==1 
	local `var'_partic = _N
	restore
	
	preserve 
	use "...\covar_structure.dta", clear
	keep if outcome == "`var'"
	local structure = structure[1]
	restore
	
	mixed `var'_c i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site i.season_b i.season_fu c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(`structure', t(visit)) reml


	margins, dydx(treatment_allocation) at(visit=3)

		local `var'_beta = -r(table)[1,2]
		local `var'_beta_uci = -r(table)[5,2]
		local `var'_beta_lci = -r(table)[6,2]
		local `var'_beta_p = r(table)[4,2]
		
	margins treatment_allocation, at(visit=3)

		local `var'_m3 = r(table)[1,1]
		local `var'_m3_uci = r(table)[6,1]
		local `var'_m3_lci = r(table)[5,1]
		local `var'_con = r(table)[1,2]
		local `var'_con_uci = r(table)[6,2]
		local `var'_con_lci = r(table)[5,2]

	preserve
	clear
	set obs 1 
	local num = `num' +1
	gen order = `num'
	gen outcome = "`var'"
	gen m3_baseline = string(``var'_b1', "%9.2f") 
	gen m3_change = string(``var'_m3', "%9.2f") + " (" + string(``var'_m3_lci', "%9.2f") + ", " + string(``var'_m3_uci', "%9.2f") + ")"
	gen con_baseline = string(``var'_b2', "%9.2f") 
	gen con_change = string(``var'_con', "%9.2f") + " (" + string(``var'_con_lci', "%9.2f") + ", " + string(``var'_con_uci', "%9.2f") + ")"
	gen diff = string(``var'_beta', "%9.2f") + " (" + string(``var'_beta_lci', "%9.2f") + ", " + string(``var'_beta_uci', "%9.2f") + ")"
	gen diff_p = string(``var'_beta_p', "%9.3f")
	append using `adiposity'
	save `adiposity',replace
	restore
}


preserve
use `adiposity', clear
gen note = ""
replace note = "MVPA: `MVPA_partic' participants `MVPA_obs' observations; Sedentary behaviour: `SED_partic' participants `SED_obs' observations; Daily steps: `steps_partic' participants `steps_obs' observations; Total PA: `enmo_partic' participants `enmo_obs' observations; Sleep window: `t_sleep_partic' participants `t_sleep_obs' observations; Actual sleep: `a_sleep_partic' participants `a_sleep_obs' observations; WASO: `WASO_partic' participants `WASO_obs' observations" in 1
sort order
drop order
export excel using "...\Accelerometer_outcomes.xlsx", firstrow(variables) replace
restore

////Change in movement subgroup across pa referral

preserve
clear
tempfile movement_sg 
save `movement_sg', emptyok
restore

local num = 0



foreach var in MVPA SED steps enmo t_sleep a_sleep WASO {
	
		forval i = 1/3 {
			preserve
			keep if pa_intervention== `i'
			drop if missing(`var'_c)
			drop if missing(pa_intervention)
			drop if missing(season_b) | missing(season_fu) | missing(Nvalid_days_b) | missing(Nvalid_days_fu)
			bysort record_id: keep if _n ==1 
			sum `var'_b, detail
			local `var'_b`i' = `r(mean)'
			local `var'_n_`i' = _N
			restore
		}
	
	preserve 
	drop if missing(`var'_c)
	drop if missing(pa_intervention)
	drop if missing(season_b) | missing(season_fu) | missing(Nvalid_days_b) | missing(Nvalid_days_fu)
	local `var'_obs = _N
	bysort record_id: keep if _n ==1 
	local `var'_partic = _N
	restore
	
	preserve 
	use "...\covar_structure.dta", clear
	keep if outcome == "`var'"
	local structure = structure[1]
	restore
	
	mixed `var'_c i.pa_intervention##i.visit c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site i.season_b i.season_fu c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(`structure', t(visit)) reml
	
	margins pa_intervention, at(visit=3)
	forval i = 1/3 {
		local `var'pa_int_`i' = r(table)[1,`i']
		local `var'pa_int_`i'_lci = r(table)[5,`i']
		local `var'pa_int_`i'_uci = r(table)[6,`i']
	}
	
	mixed `var'_c ib3.pa_intervention##i.visit c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site i.season_b i.season_fu c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(`structure', t(visit)) reml
	
	margins, dydx(pa_intervention) at(visit=3)
	forval i = 1/2 {
		local `var'pa_dydx_`i' = r(table)[1,`i']
		local `var'pa_dydx_`i'_lci = r(table)[5,`i']
		local `var'pa_dydx_`i'_uci = r(table)[6,`i']
		local `var'pa_dydx_`i'_p = r(table)[4,`i']
		di ``var'pa_int_dydx_`i''
		
	}
	preserve
	clear
	set obs 3
	local num = `num' +1
	gen order = `num'
	gen outcome = "`var'"
	gen group = .
	gen number = ""
	gen baseline = "" 
	gen change = ""
	gen diff_v_control = ""
	gen diff_p = ""
	forval i = 1/3 {
		replace group = `i' in `i'
		replace number = string(``var'_n_`i'', "%9.0f") in `i'
		replace baseline = string(``var'_b`i'', "%9.2f") in `i'
		replace change = string(``var'pa_int_`i'', "%9.2f") + " (" + string(``var'pa_int_`i'_lci', "%9.2f") + ", " + string(``var'pa_int_`i'_uci', "%9.2f") + ")" in `i'
		cap replace diff_v_control = string(``var'pa_dydx_`i'', "%9.2f")  + " (" + string(``var'pa_dydx_`i'_lci', "%9.2f") + ", " + string(``var'pa_dydx_`i'_uci', "%9.2f") + ")" in `i'
		cap replace diff_p = string(``var'pa_dydx_`i'_p', "%9.3f") in `i'
	}
	append using `movement_sg'
	save `movement_sg',replace
	restore
}

//preserve
preserve
use `movement_sg', clear
gen note = ""
replace note = "MVPA: `MVPA_partic' participants `MVPA_obs' observations; Sedentary behaviour: `SED_partic' participants `SED_obs' observations; Daily steps: `steps_partic' participants `steps_obs' observations; Total PA: `enmo_partic' participants `enmo_obs' observations; Sleep window: `t_sleep_partic' participants `t_sleep_obs' observations; Actual sleep: `a_sleep_partic' participants `a_sleep_obs' observations; WASO: `WASO_partic' participants `WASO_obs' observations" in 1
gsort +order +group
drop order
label define pa_int 1 "M3 with referral" 2 "M3 no referral" 3 "Standard care"
label values group pa_int
export excel using "...\Movement_outcomes_sg.xlsx", firstrow(variables) replace
restore





**********************************************
///OBJECTIVE 2 CHANGE CHANGE ANALYSIS
**********************************************

gen MVPA_10_c = MVPA_c /10
gen MVPA_10_b = MVPA_b /10

preserve
clear
tempfile changes 
save `changes', emptyok
restore
local num = 0

foreach var in hba1c tc ldl hdl tg sbp dbp {
	
	preserve 
	drop if missing(`var'_c) | missing(bmi_c)
	local `var'_obs = _N
	bysort record_id: keep if _n ==1 
	local `var'_partic = _N
	restore
	
	local num = `num' +1	
	mixed `var'_c c.bmi_b##i.visit c.bmi_c##i.visit i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths i.trial_site || record_id:, noconstant residuals(unstructured, t(visit)) reml
	margins, dydx(bmi_c) at(visit=3)
	preserve
	clear 
	set obs 1 
	gen order = `num'
	gen exp = "BMI (per 1 kg/m2 decrease)"
	gen outcome = "`var'"
	gen change = string((-r(table)[1,1]), "%9.2f") + " (" + string((-r(table)[6,1]), "%9.2f") + ", " + string((-r(table)[5,1]), "%9.2f") + ")"
	gen p_change = string((r(table)[4,1]), "%9.3f")
	append using `changes'
	save `changes',replace
	restore
}



foreach var in hba1c tc ldl hdl tg sbp dbp bmi weight fm ffm fm_ratio fat_p {
	
	preserve 
	drop if missing(`var'_c) | missing(MVPA_10_c)
	local `var'_obs_MVPA = _N
	bysort record_id: keep if _n ==1 
	local `var'_partic_MVPA = _N
	restore
	
	local num = `num' +1	
	mixed `var'_c c.MVPA_10_b##i.visit c.MVPA_10_c##i.visit i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths i.trial_site || record_id:, noconstant residuals(unstructured, t(visit)) reml
	margins, dydx(MVPA_10_c) at(visit=3)
	preserve
	clear 
	set obs 1 
	gen order = `num'
	gen exp = "MVPA (per 10 min/day change)"
	gen outcome = "`var'"
	gen change = string((-r(table)[1,1]), "%9.2f") + " (" + string((-r(table)[6,1]), "%9.2f") + ", " + string((-r(table)[5,1]), "%9.2f") + ")"
	gen p_change = string((r(table)[4,1]), "%9.3f")
	append using `changes'
	save `changes',replace
	restore
}

preserve
use `changes',replace
gen note = ""
replace note = "BMI analysis: HbA1c: `hba1c_partic' participants `hba1c_obs' observations; Total cholesterol: `tc_partic' participants `tc_obs' observations; LDL cholesterol: `ldl_partic' participants `ldl_obs' observations; HDL cholesterol: `hdl_partic' participants `hdl_obs' observations; Triglycerides: `tg_partic' participants `tg_obs' observations; Systolic blood pressure: `sbp_partic' participants `sbp_obs' observations; Diastolic blood pressure: `dbp_partic' participants `dbp_obs' observations" in 1
replace note = "MVPA analysis HbA1c: `hba1c_partic_MVPA' participants `hba1c_obs_MVPA' observations; Total cholesterol: `tc_partic_MVPA' participants `tc_obs_MVPA' observations; LDL cholesterol: `ldl_partic_MVPA' participants `ldl_obs_MVPA' observations; HDL cholesterol: `hdl_partic_MVPA' participants `hdl_obs_MVPA' observations; Triglycerides: `tg_partic_MVPA' participants `tg_obs_MVPA' observations; Systolic blood pressure: `sbp_partic_MVPA' participants `sbp_obs_MVPA' observations; Diastolic blood pressure: `dbp_partic_MVPA' participants `dbp_obs_MVPA' observation; Weight (kg): `weight_partic' participants `weight_obs' observations; Weight (%): `weight_p_partic' participants `weight_p_obs' observations; BMI: `bmi_partic' participants `bmi_obs' observations; Fat mass: `fm_partic' participants `fm_obs' observations; Fat-free mass: `ffm_partic' participants `ffm_obs' observations; Fat mass:Fat-free mass ratio: `fm_ratio_partic' participants `fm_ratio_obs' observations; Percentage body fat: `fat_p_partic' participants `fat_p_obs' observations" in 2
sort order
drop order
export excel using "...\Changes.xlsx", firstrow(variables) replace
restore






























********************
**# MI setup
********************



///Analysis


use "...\cleaned.dta", clear


gen weight_p_b = 100
gen weight_p_26 = (weight_26) / weight_b *100
gen weight_p_12 = (weight_12) / weight_b *100


gen pa_intervention = 1 if pa_ref ==1 & treatment_allocation==1
replace pa_intervention = 2 if pa_ref ==0 & treatment_allocation==1
replace pa_intervention = 3 if treatment_allocation==2
label define pa_int 1 "M3 with referral" 2 "M3 no referral" 3 "Standard care"
label values pa_intervention pa_int

//missing treatment allocation
count
drop if missing(treatment_allocation)
count

count if treatment_allocation==1
count if treatment_allocation==2


mi set flong	

egen height = rowmean(height_b height_26 height_12)

drop height_b height_26 height_12

foreach var in age weight_b ffm_b fm_b fat_p_b hba1c_b tc_b hdl_b ldl_b tg_b sbp_b dbp_b weight_26  ffm_26 fm_26 fat_p_26 hba1c_26 hdl_26 tc_26 ldl_26 tg_26 sbp_26 dbp_26 weight_12  ffm_12 fm_12  fat_p_12  hba1c_12 hdl_12 tc_12 ldl_12 tg_12 sbp_12 dbp_12  enmo_b t_sleep_b SED_b a_sleep_b Nvalid_days_b steps_b MVPA_b enmo_26 t_sleep_26 SED_26 a_sleep_26 Nvalid_days_26 steps_26 MVPA_26 enmo_12 t_sleep_12 SED_12 a_sleep_12 Nvalid_days_12 steps_12 MVPA_12 imd sema_i tirz_i semaglutide_sc_b tirzepatide_b season_b{
	gen m_`var' = missing(`var')
}

//vars with missing to be imputed
mi register imputed age imd weight_b  ffm_b fm_b fat_p_b hba1c_b tc_b hdl_b ldl_b tg_b sbp_b dbp_b weight_26  ffm_26 fm_26 fat_p_26 hba1c_26 hdl_26 tc_26 ldl_26 tg_26 sbp_26 dbp_26 weight_12  ffm_12 fm_12  fat_p_12  hba1c_12 hdl_12 tc_12 ldl_12 tg_12 sbp_12 dbp_12 enmo_b t_sleep_b SED_b a_sleep_b Nvalid_days_b steps_b MVPA_b  season_b enmo_26 t_sleep_26 SED_26 a_sleep_26 Nvalid_days_26 steps_26 MVPA_26  season_26 enmo_12 t_sleep_12 SED_12 a_sleep_12 Nvalid_days_12 steps_12 MVPA_12  season_12  

//complete vars
mi register regular record_id trial_site treatment_allocation sex eths t2d_duration weight_p_b any_glp1_b PA_referral dietary_referral pscyhology_referral cgm_referral dsm_referral social_p_referral led_referral  pa_intervention  height sulfonylurea_b glp1ra_b semaglutide_sc_b insulin_b metformin_b sglt2_b tirzepatide_b antihyp_b lipidlower_b dpp4i_b pioglitazone_b 

//vars that are calculated from other vars and so have missing but dont need direct imputation
mi register passive  fm_ratio_12 fm_ratio_26 fm_ratio_b age_diag bmi_b bmi_26 bmi_12 weight_p_26 weight_p_12 any_glpbased_b WASO_b WASO_12 WASO_26 wl_i sema_i tirz_i 

tab trial_site, gen(trial_site_)

tab eths, gen(eths_)

tab imd, gen(imd_)


*****************************************************
///////////////////////////////////12 month will also need to include pa_i when actual var

mi impute chained ///
	/*season_b*/ (mlogit, noimputed include(enmo_b t_sleep_b SED_b a_sleep_b Nvalid_days_b steps_b MVPA_b trial_site))  season_b ///
	/*imd*/ (ologit, noimputed include(age sex eths_* t2d_duration weight_b hba1c_b )) imd ///
	/*cont vars*/ (pmm, knn(5)) age weight_b ffm_b fm_b fat_p_b hba1c_b tc_b hdl_b ldl_b tg_b sbp_b dbp_b enmo_b t_sleep_b SED_b a_sleep_b Nvalid_days_b steps_b MVPA_b   weight_26  ffm_26 fm_26 fat_p_26 hba1c_26 hdl_26 tc_26 ldl_26 tg_26 sbp_26 dbp_26 weight_12  ffm_12 fm_12  fat_p_12  hba1c_12 hdl_12 tc_12 ldl_12 tg_12 sbp_12 dbp_12  enmo_26 t_sleep_26 SED_26 a_sleep_26 Nvalid_days_26 steps_26 MVPA_26 enmo_12 t_sleep_12 SED_12 a_sleep_12 Nvalid_days_12 steps_12 MVPA_12 ///
	= treatment_allocation sex height t2d_duration trial_site_* eths_*, add(20) rseed(5000000) 


	
///recalculate calualated vars

replace weight_p_b = 100
replace weight_p_26 = (weight_26) / weight_b *100
replace weight_p_12 = (weight_12) / weight_b *100


foreach var in _b _12 _26 {
	replace fm_ratio`var' = fm`var' / ffm`var'
}

replace age_diag = age - t2d_duration

foreach var in _b _12 _26 {
	replace bmi`var' = round((weight`var' / ((height/100)^2)),0.1)
	replace WASO`var' = t_sleep`var' - a_sleep`var'
}

replace wl_i =1 if sema_i ==1 | tirz_i ==1
replace wl_i = 0 if missing(wl_i)
mdesc if _mi_m ==1

save "...\afterMItest.dta", replace



////imputation table comnparison
preserve
clear
tempfile imputation
save `imputation', emptyok 
restore

local order = 0

foreach var in age weight_b ffm_b fm_b fat_p_b hba1c_b tc_b hdl_b ldl_b tg_b sbp_b dbp_b enmo_b t_sleep_b SED_b a_sleep_b Nvalid_days_b steps_b MVPA_b  weight_26  ffm_26 fm_26 fat_p_26 hba1c_26 hdl_26 tc_26 ldl_26 tg_26 sbp_26 dbp_26 enmo_26 t_sleep_26 SED_26 a_sleep_26 Nvalid_days_26 steps_26 MVPA_26 weight_12  ffm_12 fm_12  fat_p_12  hba1c_12 hdl_12 tc_12 ldl_12 tg_12 sbp_12 dbp_12   enmo_12 t_sleep_12 SED_12 a_sleep_12 Nvalid_days_12 steps_12 MVPA_12 {
	sum `var' if m_`var' == 1, detail
	local missing_median = `r(p50)'
	local missing_25 = `r(p25)'
	local missing_75 = `r(p75)'
	local missing_min = `r(min)'
	local missing_max = `r(max)'
	sum `var' if m_`var' == 0, detail
	local nmissing_median = `r(p50)'
	local nmissing_25 = `r(p25)'
	local nmissing_75 = `r(p75)'
	local nmissing_min = `r(min)'
	local nmissing_max = `r(max)'
	count if m_`var' == 1 & _mi_m == 0
	local n_imp = r(N)
	count if m_`var' == 0 & _mi_m == 0
	local n_obs = r(N)
	local order = `order'+1
	
	preserve
	clear all
	set obs 1
	gen order = `order'
	gen outcome = "`var'"
	gen nonmissing_n = `n_obs'
	gen nonmissing = ///
		string(`nmissing_median', "%9.1f") + " (" + ///
		string(`nmissing_25', "%9.1f") + ", " + ///
		string(`nmissing_75', "%9.1f") + ")"
	gen nonmissing_range = ///
		string(`nmissing_min', "%9.1f") + ", " + ///
		string(`nmissing_max', "%9.1f")
	gen missing_n = `n_imp'
	gen missing = ///
		string(`missing_median', "%9.1f") + " (" + ///
		string(`missing_25', "%9.1f") + ", " + ///
		string(`missing_75', "%9.1f") + ")"
	gen missing_range = ///
		string(`missing_min', "%9.1f") + ", " + ///
		string(`missing_max', "%9.1f")
	append using `imputation'
	save `imputation', replace
	restore
}
preserve
use `imputation' , clear 
sort order
drop order 
export excel using "...\imputation_cont_vars.xlsx", firstrow(variables) replace
restore

//cat vars 

label define sema 1 "Initiaing SC semaglutide" 0 "Not initiating SC semaglutide"
label values sema_i sema

label define tirz 1 "Initiaing tirzepatide" 0 "Not initiating tirzepatide"
label values tirz_i tirz

label define season 1 "Spring" 2 "Summer" 3 "Autumn" 4 "Winter"
label values season_b season 

preserve
clear
tempfile tempflong
save `tempflong', emptyok 
restore


foreach var in season_b imd {
	preserve
	mi unset
	count if m_`var' == 1 & mi_m == 0
		local n_imp = r(N)
	count if m_`var' == 0 & mi_m == 0
		local n_obs = r(N)
	contract m_`var' `var'
	drop if `var'==.
	bysort m_`var': egen total = total(_freq)
	gen pct = 100 * _freq / total
	gen cell = string(pct,"%4.1f") + "%"
	keep `var' m_`var'  cell
	reshape wide cell, i(`var') j(m_`var')
	rename cell0 Observed
	rename cell1 Imputed
	local n = _N+1
	set obs `n'
	decode `var', gen(`var'2)
	drop `var'
	rename `var'2 `var'
	replace `var' = "Total count" if missing(`var')
	replace Observed = "`n_obs'" if `var'== "Total count"
	replace Imputed = "`n_imp'" if `var'== "Total count"
	gen var = "`var'"
	order var `var'
	rename `var' category
	append using `tempflong'
	save `tempflong', replace
	restore
}

preserve
use `tempflong', clear
gen order = _n
gsort -order
drop order
export excel using "...\imputation_cat_vars.xlsx", firstrow(variables) replace
restore



*******************************************************************
**# MI ANALYSIS   analysis
*******************************************************************


***
use "...\afterMItest.dta", clear

sum weight_b if wl_i==0 & m_weight_12==0
sum weight_b if wl_i==0 & m_weight_12==1
sum weight_b if wl_i==1 & m_weight_12==0
sum weight_b if wl_i==1 & m_weight_12==1



//prepare

foreach var in weight_ bmi_ ffm_ fm_ratio_ fm_ fat_p_ hba1c_ tc_ hdl_ ldl_ tg_ sbp_ dbp_ WASO_ weight_p_ enmo_ t_sleep_ SED_ a_sleep_ Nvalid_days_ steps_ MVPA_ MVPA_g_ season_ {
	gen `var'1 = `var'b
}

mi reshape long weight_ bmi_ ffm_ fm_ratio_ fm_ fat_p_ hba1c_ tc_ hdl_ ldl_ tg_ sbp_ dbp_ WASO_ weight_p_ enmo_ t_sleep_ SED_ a_sleep_ Nvalid_days_ steps_ MVPA_ MVPA_g_ season_ , i(record_id) j(visit)
replace visit = 2 if visit ==26
replace visit = 3 if visit ==12
tab visit
drop if visit==1

foreach var in weight_ bmi_ ffm_ fm_ratio_ fm_ fat_p_ hba1c_ tc_ hdl_ ldl_ tg_ sbp_ dbp_ WASO_ weight_p_ enmo_ t_sleep_ SED_ a_sleep_  steps_ MVPA_ MVPA_g_  {
	gen `var'c =  `var' - `var'b
}

rename season_ season_fu
rename Nvalid_days_ Nvalid_days_fu

replace weight_p_b = weight_b // to ensure that baseline val captures variation in absolute measure.

sum weight_c if wl_i==0 & m_weight_12==0
sum weight_c if wl_i==0 & m_weight_12==1
sum weight_c if wl_i==1 & m_weight_12==0
sum weight_c if wl_i==1 & m_weight_12==1



**********************************
////MI- MAIN ANALYSIS ADIPOSITY/////
***********************************

////////////////////////
local imputations = 20
/////////////////////////////

preserve
clear
tempfile adiposity 
save `adiposity', emptyok
restore

local num = 0
foreach var in bmi weight weight_p  fm ffm fm_ratio fat_p {
	
	forvalues m=1/`imputations' {

		forval i = 1/2 {
			preserve
			mi extract `m', clear
			keep if treatment_allocation== `i'
			bysort record_id: keep if _n ==1 
			sum `var'_b, detail
			local `var'_b`i' = `r(mean)'
			restore
		}
		preserve 
		use "...\covar_structure.dta", clear
		keep if outcome == "`var'"
		local structure = structure[1]
		restore

		///manual calculation of marginal means

		preserve
		mi extract `m', clear
		mixed `var'_c i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site || record_id:, noconstant residuals(`structure', t(visit)) reml
				
		margins, dydx(treatment_allocation) at(visit=3) 

			local `var'_beta = r(table)[1,2]
			local `var'_beta_se = r(table)[2,2]
			
		margins treatment_allocation, at(visit=3)
			local `var'_m3 = r(table)[1,1]
			local `var'_m3_se = r(table)[2,1]
			local `var'_con = r(table)[1,2]
			local `var'_con_se = r(table)[2,2]
		
		clear
		set obs 1 
		local num = `num' +1
		gen order = `num'
		gen outcome = "`var'"
		gen imputation = `m'
		gen m3_baseline = ``var'_b1'
		gen m3_change = ``var'_m3'
		gen m3_change_se = ``var'_m3_se'
		gen con_baseline = ``var'_b2'
		gen con_change = ``var'_con'
		gen con_change_se = ``var'_con_se'
		gen diff = ``var'_beta'
		gen diff_se = ``var'_beta_se'
		append using `adiposity'
		save `adiposity',replace
		restore
	}
}


preserve
use `adiposity', clear


replace m3_baseline = 100 if outcome == "weight_p"
replace con_baseline = 100 if outcome == "weight_p"

replace diff = diff * -1

foreach var in m3_change con_change diff {
	bysort outcome: gen `var'_w = (sum(`var'_se^2) / _N)
	bysort outcome: replace `var'_w = `var'_w[_N]
	bysort outcome: gen `var'_b = 	(sum(`var') / _N)
	bysort outcome: replace `var'_b = `var'_b[_N]
	bysort outcome: replace `var'_b = (`var' - `var'_b)^2
	bysort outcome: replace `var'_b = sum(`var'_b) / (_N-1)
	bysort outcome: replace `var'_b = `var'_b[_N]
	bysort outcome: gen `var'_t = `var'_w + (1 + (1/_N))*`var'_b
	bysort outcome: gen `var'_est = sum(`var') / _N
	bysort outcome: replace `var'_est = `var'_est[_N]
	bysort outcome: gen `var'_r = ((1 + 1/_N)*`var'_b)/`var'_w
	bysort outcome: gen `var'_df = (_N-1)*(1 + 1/`var'_r)^2
	bysort outcome: gen `var'_crit = invttail(`var'_df, 0.025)
	gen `var'_mi = string(`var'_est, "%9.2f") + " (" + string((`var'_est - (`var'_crit* sqrt(`var'_t))),"%9.2f") + ", " + string((`var'_est + (`var'_crit* sqrt(`var'_t))), "%9.2f") + ")"
}

foreach var in diff {
	
	gen `var'_p = string((2*ttail(`var'_df, abs(`var'_est/sqrt(`var'_t)))),"%9.3f")
	
}

foreach var in m3_baseline con_baseline {
	bysort outcome: gen `var'_est = sum(`var') / _N
	bysort outcome: replace `var'_est = `var'_est[_N]
	gen `var'_mi = string(`var'_est, "%9.2f")
}

keep outcome m3_change_mi con_change_mi diff_mi m3_baseline_mi con_baseline_mi diff_p order

foreach var in m3_change con_change diff m3_baseline con_baseline {
	rename `var'_mi `var'
}


order outcome m3_baseline m3_change con_baseline con_change diff diff_p

sort order
drop order

duplicates drop

export excel using "...\Adiposity_outcomes_mi.xlsx", firstrow(variables) replace
restore



////MI-hange in adiposity subgroup

////////////////////////
local imputations = 20
/////////////////////////////

preserve
clear
tempfile adiposity_sg 
save `adiposity_sg', emptyok
restore


local num = 0

foreach var in bmi weight weight_p fm ffm fm_ratio fat_p {
		preserve 
		use "...\covar_structure.dta", clear
		keep if outcome == "`var'"
		local structure = structure[1]
		restore
	forvalues m=1/`imputations' {
			forval i = 1/2 {
				preserve
				mi extract `m', clear
				drop if tirzepatide_b==1 | semaglutide_sc_b==1
				drop if missing(`var'_c)
				drop if missing(wl_i)
				keep if treatment_allocation== `i' & wl_i == 0
				bysort record_id: keep if _n ==1 
				sum `var'_b, detail
				local `var'no_wl_b_`i' = `r(mean)'
				restore
				
				preserve
				mi extract `m', clear
				drop if tirzepatide_b==1 | semaglutide_sc_b==1
				drop if missing(`var'_c)
				drop if missing(wl_i)
				keep if treatment_allocation== `i' & wl_i == 1
				bysort record_id: keep if _n ==1 
				sum `var'_b, detail
				local `var'wl_b_`i' = `r(mean)'
				restore
			}
		
		local num = `num' +1
	
		preserve
		mi extract `m', clear
		drop if tirzepatide_b==1 | semaglutide_sc_b==1

		mixed `var'_c i.treatment_allocation##i.visit##i.wl_i c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site || record_id:, noconstant residuals(`structure', t(visit)) reml
		

			
		margins treatment_allocation, at(wl_i=0 visit=3)
		forval i = 1/2 {
		local `var'no_wl_`i' = r(table)[1,`i']
		local `var'no_wl_`i'_se = r(table)[2,`i']
		}
		

		margins treatment_allocation, at(wl_i=1 visit=3)
		forval i = 1/2 {
		local `var'wl_`i' = r(table)[1,`i']
		local `var'wl_`i'_se = r(table)[2,`i']
		}

		forval i = 1/2 {
			margins, dydx(wl_i) at(treatment_allocation=`i' visit=3)
			local `var'_beta`i' = r(table)[1,2]
			local `var'_beta`i'_se = r(table)[2,2]
		}
		
		margins treatment_allocation#wl_i, at(visit=3) post coeflegend
		lincom (_b[1bn.treatment_allocation#0bn.wl_i] - _b[1bn.treatment_allocation#1.wl_i]) - (_b[2.treatment_allocation#0bn.wl_i] - _b[2.treatment_allocation#1.wl_i])
		local `var'int = r(estimate)
		local `var'int_se = r(se)
			
		clear
		set obs 2
		gen order = .
		gen outcome = "`var'"
		gen imputation = `m'
		gen group = .

		gen baseline_wl = . 
		gen change_wl = .
		gen change_wl_se = .

		gen baseline_no_wl = . 
		gen change_no_wl = .
		gen change_no_wl_se = .
		
		gen diff_change = .
		gen diff_change_se = .
				
		gen interaction = .
		gen interaction_se = .
		forval i = 1/2 {
			local num = `num' +1
			replace order = `num' in `i'
			replace group = `i' in `i'
			replace baseline_wl = ``var'wl_b_`i'' in `i'
			replace change_wl = ``var'wl_`i''  in `i'
			replace change_wl_se = ``var'wl_`i'_se'  in `i'
			
			replace baseline_no_wl = ``var'no_wl_b_`i'' in `i'
			replace change_no_wl = ``var'no_wl_`i'' in `i'
			replace change_no_wl_se = ``var'no_wl_`i'_se' in `i'
			
			replace diff_change= ``var'_beta`i'' in `i'
			replace diff_change_se = ``var'_beta`i'_se' in `i'
		}	
			replace interaction = ``var'int'
			replace interaction_se = ``var'int_se'
		append using `adiposity_sg'
		save `adiposity_sg',replace
		restore

	}
}

preserve
use `adiposity_sg', clear


foreach var in change_wl change_no_wl diff_change interaction  {
	bysort outcome group: gen `var'_w = (sum(`var'_se^2) / _N)
	bysort outcome group: replace `var'_w = `var'_w[_N]
	bysort outcome group: gen `var'_b = (sum(`var') / _N)
	bysort outcome group: replace `var'_b = `var'_b[_N]
	bysort outcome group: replace `var'_b = (`var' - `var'_b)^2
	bysort outcome group: replace `var'_b = sum(`var'_b) / (_N-1)
	bysort outcome group: replace `var'_b = `var'_b[_N]
	bysort outcome group: gen `var'_t = `var'_w + (1 + (1/_N))*`var'_b
	bysort outcome group: gen `var'_est = sum(`var') / _N
	bysort outcome group: replace `var'_est = `var'_est[_N]
	bysort outcome group: gen `var'_r = ((1 + 1/_N)*`var'_b)/`var'_w
	bysort outcome group: gen `var'_df = (_N-1)*(1 + 1/`var'_r)^2
	bysort outcome group: gen `var'_crit = invttail(`var'_df, 0.025)
	gen `var'_mi = string(`var'_est, "%9.2f") + " (" + string((`var'_est - (`var'_crit* sqrt(`var'_t))),"%9.2f") + ", " + string((`var'_est + (`var'_crit* sqrt(`var'_t))), "%9.2f") + ")"
}

foreach var in diff_change interaction {
	
	gen `var'_p = string((2*ttail(`var'_df, abs(`var'_est/sqrt(`var'_t)))),"%9.3f")
	
}

foreach var in baseline_wl baseline_no_wl {
	bysort outcome group: gen `var'_est = sum(`var') / _N
	bysort outcome group: replace `var'_est = `var'_est[_N]
	gen `var'_mi = string(`var'_est, "%9.2f")
}

keep group outcome baseline_wl_mi change_wl_mi baseline_no_wl_mi change_no_wl_mi diff_change_mi diff_change_p interaction_p order

foreach var in baseline_wl change_wl baseline_no_wl change_no_wl diff_change  {
	rename `var'_mi `var'
}


order outcome group baseline_wl change_wl baseline_no_wl change_no_wl diff_change diff_change_p interaction_p

sort order
drop order

duplicates drop

label define m3 1 "The M3 Intervention" 2 "Standard Care"
label values group m3
export excel using "...\Adiposity_outcomes_sg_mi.xlsx", firstrow(variables) replace
restore



**********************************
////MAIN ANALYSIS PHYSICAL BEHAVIOUR/////
***********************************

////////////////////////
local imputations = 20
/////////////////////////////

preserve
clear
tempfile adiposity 
save `adiposity', emptyok
restore

local num = 0
foreach var in MVPA SED steps enmo t_sleep a_sleep WASO  {
	
	forvalues m=1/`imputations' {
	
		forval i = 1/2 {
		preserve
		mi extract `m', clear
		keep if treatment_allocation== `i'
		bysort record_id: keep if _n ==1 
		sum `var'_b, detail
		local `var'_b`i' = `r(mean)'
		restore
	}
	
	preserve 
	use "...\covar_structure.dta", clear
	keep if outcome == "`var'"
	local structure = structure[1]
	restore
	
	preserve
	mi extract `m', clear
	mixed `var'_c i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site i.season_b c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(`structure', t(visit)) reml


	margins, dydx(treatment_allocation) at(visit=3)

			local `var'_beta = r(table)[1,2]
			local `var'_beta_se = r(table)[2,2]
		
	margins treatment_allocation, at(visit=3)

			local `var'_m3 = r(table)[1,1]
			local `var'_m3_se = r(table)[2,1]
			local `var'_con = r(table)[1,2]
			local `var'_con_se = r(table)[2,2]

		clear
		set obs 1 
		local num = `num' +1
		gen order = `num'
		gen outcome = "`var'"
		gen imputation = `m'
		gen m3_baseline = ``var'_b1'
		gen m3_change = ``var'_m3'
		gen m3_change_se = ``var'_m3_se'
		gen con_baseline = ``var'_b2'
		gen con_change = ``var'_con'
		gen con_change_se = ``var'_con_se'
		gen diff = ``var'_beta'
		gen diff_se = ``var'_beta_se'
		append using `adiposity'
		save `adiposity',replace
		restore
}
}

preserve
use `adiposity', clear


replace m3_baseline = 100 if outcome == "weight_p"
replace con_baseline = 100 if outcome == "weight_p"

replace diff = diff * -1

foreach var in m3_change con_change diff {
	bysort outcome: gen `var'_w = (sum(`var'_se^2) / _N)
	bysort outcome: replace `var'_w = `var'_w[_N]
	bysort outcome: gen `var'_b = 	(sum(`var') / _N)
	bysort outcome: replace `var'_b = `var'_b[_N]
	bysort outcome: replace `var'_b = (`var' - `var'_b)^2
	bysort outcome: replace `var'_b = sum(`var'_b) / (_N-1)
	bysort outcome: replace `var'_b = `var'_b[_N]
	bysort outcome: gen `var'_t = `var'_w + (1 + (1/_N))*`var'_b
	bysort outcome: gen `var'_est = sum(`var') / _N
	bysort outcome: replace `var'_est = `var'_est[_N]
	bysort outcome: gen `var'_r = ((1 + 1/_N)*`var'_b)/`var'_w
	bysort outcome: gen `var'_df = (_N-1)*(1 + 1/`var'_r)^2
	bysort outcome: gen `var'_crit = invttail(`var'_df, 0.025)
	gen `var'_mi = string(`var'_est, "%9.2f") + " (" + string((`var'_est - (`var'_crit* sqrt(`var'_t))),"%9.2f") + ", " + string((`var'_est + (`var'_crit* sqrt(`var'_t))), "%9.2f") + ")"
}

foreach var in diff {
	
	gen `var'_p = string((2*ttail(`var'_df, abs(`var'_est/sqrt(`var'_t)))),"%9.3f")
	
}

foreach var in m3_baseline con_baseline {
	bysort outcome: gen `var'_est = sum(`var') / _N
	bysort outcome: replace `var'_est = `var'_est[_N]
	gen `var'_mi = string(`var'_est, "%9.2f")
}

keep outcome m3_change_mi con_change_mi diff_mi m3_baseline_mi con_baseline_mi diff_p order

foreach var in m3_change con_change diff m3_baseline con_baseline {
	rename `var'_mi `var'
}
order outcome m3_baseline m3_change con_baseline con_change diff diff_p
sort order
drop order
duplicates drop
export excel using "...\Accelerometer_outcomes_mi.xlsx", firstrow(variables) replace
restore

////MI-Change in movement subgroup across pa referral

////////////////////////
local imputations = 20
/////////////////////////////

preserve
clear
tempfile movement_sg 
save `movement_sg', emptyok
restore

local num = 0

foreach var in MVPA SED steps enmo t_sleep a_sleep WASO {
	forvalues m=1/`imputations' {
			forval i = 1/3 {
				preserve
				mi extract `m', clear
				keep if pa_intervention== `i'
				drop if missing(`var'_c)
				drop if missing(pa_intervention)
				drop if missing(season_b) | missing(season_fu) | missing(Nvalid_days_b) | missing(Nvalid_days_fu)
				bysort record_id: keep if _n ==1 
				sum `var'_b, detail
				local `var'_b`i' = `r(mean)'
				restore
			}
		
	
		preserve 
		use "...\covar_structure.dta", clear
		keep if outcome == "`var'"
		local structure = structure[1]
		restore
		
		preserve 
		mi extract `m', clear
		
		mixed `var'_c i.pa_intervention##i.visit c.`var'_b##i.visit age i.sex  i.eths c.hba1c_b i.trial_site i.season_b  c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(`structure', t(visit)) reml
		
		margins pa_intervention, at(visit=3)
		forval i = 1/3 {
			local `var'pa_int_`i' = r(table)[1,`i']
			local `var'pa_int_`i'_se = r(table)[2,`i']
		}
		
		mixed `var'_c ib3.pa_intervention##i.visit c.`var'_b##i.visit age i.sex i.eths c.hba1c_b i.trial_site i.season_b c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(`structure', t(visit)) reml
		
		margins, dydx(pa_intervention) at(visit=3)
		forval i = 1/2 {
			local `var'pa_dydx_`i' = r(table)[1,`i']
			local `var'pa_dydx_`i'_se = r(table)[2,`i']
		}
		
		
		clear
		set obs 3

		gen outcome = "`var'"
		gen group = .
		gen baseline = .
		gen change = .
		gen change_se = .
		gen diff_v_control = .
		gen diff_v_control_se = .
		gen order = .
		gen imputation = `m'
		
		forval i = 1/3 {
			
			local num = `num' +1
			replace order = `num' in `i'
			replace group = `i' in `i'
			replace baseline = ``var'_b`i'' in `i'
			replace change = ``var'pa_int_`i'' in `i'
			replace change_se = ``var'pa_int_`i'_se' in `i'
			cap replace diff_v_control = ``var'pa_dydx_`i'' in `i'
			cap replace diff_v_control_se = ``var'pa_dydx_`i'_se' in `i'
		}
		
		append using `movement_sg'
		save `movement_sg',replace
		restore
	}
}



preserve
use `movement_sg', clear

foreach var in change diff_v_control {
	bysort outcome group: gen `var'_w = (sum(`var'_se^2) / _N)
	bysort outcome group: replace `var'_w = `var'_w[_N]
	bysort outcome group: gen `var'_b = (sum(`var') / _N)
	bysort outcome group: replace `var'_b = `var'_b[_N]
	bysort outcome group: replace `var'_b = (`var' - `var'_b)^2
	bysort outcome group: replace `var'_b = sum(`var'_b) / (_N-1)
	bysort outcome group: replace `var'_b = `var'_b[_N]
	bysort outcome group: gen `var'_t = `var'_w + (1 + (1/_N))*`var'_b
	bysort outcome group: gen `var'_est = sum(`var') / _N
	bysort outcome group: replace `var'_est = `var'_est[_N]
	bysort outcome group: gen `var'_r = ((1 + 1/_N)*`var'_b)/`var'_w
	bysort outcome group: gen `var'_df = (_N-1)*(1 + 1/`var'_r)^2
	bysort outcome group: gen `var'_crit = invttail(`var'_df, 0.025)
	gen `var'_mi = string(`var'_est, "%9.2f") + " (" + string((`var'_est - (`var'_crit* sqrt(`var'_t))),"%9.2f") + ", " + string((`var'_est + (`var'_crit* sqrt(`var'_t))), "%9.2f") + ")"
}

foreach var in diff_v_control {
	
	gen `var'_p = string((2*ttail(`var'_df, abs(`var'_est/sqrt(`var'_t)))),"%9.3f")
	
}

foreach var in baseline {
	bysort outcome group: gen `var'_est = sum(`var') / _N
	bysort outcome group: replace `var'_est = `var'_est[_N]
	gen `var'_mi = string(`var'_est, "%9.2f")
}

keep group outcome baseline_mi change_mi diff_v_control_mi diff_v_control_p order

foreach var in baseline change diff_v_control  {
	rename `var'_mi `var'
}

order outcome group baseline change diff_v_control diff_v_control_p

sort order
drop order

duplicates drop

label define pa_int 1 "M3 with referral" 2 "M3 no referral" 3 "Standard care"
label values group pa_int
export excel using "...\Movement_outcomes_sg_mi.xlsx", firstrow(variables) replace
restore





**********************************************
///MI-OBJECTIVE 2 CHANGE CHANGE ANALYSIS
**********************************************

gen MVPA_10_c = MVPA_c /10
gen MVPA_10_b = MVPA_b /10


////////////////////////
local imputations = 20
/////////////////////////////


preserve
clear
tempfile changes 
save `changes', emptyok
restore
local num = 0

forvalues m=1/`imputations' {
	
	foreach var in hba1c tc ldl hdl tg sbp dbp {
	
		preserve 
		mi extract `m', clear
		local num = `num' +1	
		mixed `var'_c c.bmi_b##i.visit c.bmi_c##i.visit i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths i.trial_site || record_id:, noconstant residuals(unstructured, t(visit)) reml
		margins, dydx(bmi_c) at(visit=3)
		clear 
		set obs 1 
		gen order = `num'
		gen exp = "BMI (per 1 kg/m2 decrease)"
		gen outcome = "`var'"
		gen change = -r(table)[1,1]
		gen change_se = r(table)[2,1]
		append using `changes'
		save `changes',replace
		restore
	}

	foreach var in hba1c tc ldl hdl tg sbp dbp bmi weight fm ffm fm_ratio fat_p_26 {
		
		preserve 
		mi extract `m', clear
		local num = `num' +1	
		mixed `var'_c c.MVPA_10_b##i.visit c.MVPA_10_c##i.visit i.treatment_allocation##i.visit c.`var'_b##i.visit age i.sex i.eths i.trial_site i.season_b c.Nvalid_days_b c.Nvalid_days_fu || record_id:, noconstant residuals(unstructured, t(visit)) reml
		margins, dydx(MVPA_10_c) at(visit=3)
		clear 
		set obs 1 
		gen order = `num'
		gen exp = "MVPA (per 10 min/day change)"
		gen outcome = "`var'"
		gen change = -r(table)[1,1]
		gen change_se = r(table)[2,1]
		append using `changes'
		save `changes',replace
		restore
	}
}

preserve
use `changes', clear

foreach var in change {
	bysort outcome exp: gen `var'_w = (sum(`var'_se^2) / _N)
	bysort outcome exp: replace `var'_w = `var'_w[_N]
	bysort outcome exp: gen `var'_b = (sum(`var') / _N)
	bysort outcome exp: replace `var'_b = `var'_b[_N]
	bysort outcome exp: replace `var'_b = (`var' - `var'_b)^2
	bysort outcome exp: replace `var'_b = sum(`var'_b) / (_N-1)
	bysort outcome exp: replace `var'_b = `var'_b[_N]
	bysort outcome exp: gen `var'_t = `var'_w + (1 + (1/_N))*`var'_b
	bysort outcome exp: gen `var'_est = sum(`var') / _N
	bysort outcome exp: replace `var'_est = `var'_est[_N]
	bysort outcome exp: gen `var'_r = ((1 + 1/_N)*`var'_b)/`var'_w
	bysort outcome exp: gen `var'_df = (_N-1)*(1 + 1/`var'_r)^2
	bysort outcome exp: gen `var'_crit = invttail(`var'_df, 0.025)
	gen `var'_mi = string(`var'_est, "%9.2f") + " (" + string((`var'_est - (`var'_crit* sqrt(`var'_t))),"%9.2f") + ", " + string((`var'_est + (`var'_crit* sqrt(`var'_t))), "%9.2f") + ")"
}

foreach var in change {
	
	gen `var'_p = string((2*ttail(`var'_df, abs(`var'_est/sqrt(`var'_t)))),"%9.3f")
	
}

keep exp outcome change_mi change_p order

foreach var in change {
	rename `var'_mi `var'
}

order exp outcome change  change_p

sort order
drop order

duplicates drop

export excel using "...\Changes_mi.xlsx", firstrow(variables) replace
restore

