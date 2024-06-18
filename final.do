*****************************************************************************************; 
*  AUTHOR:  	Katherine Chu   														*;
*  CODE:   		E:\GEOG464\Final\final.do												*; 	  		  
*  DATA:    	E:\GEOG464\Final\ej_screen.dta											*;					
*  PURPOSE: 	Final																	*;
*****************************************************************************************;

*Setup

log using "D:\GEOG464\Final\final.log", replace

cd "D:\GEOG464\Final"

* Review data set

use ej_screen.dta					/* for this command to work as is, this data file has to be stored in the folder you pointed to above in the "cd" command line */

// * Set Up MGWR *******************************************************************************************
//
// bysort id: assert _N==1		/* The numeric variable in the data set called 'id' uniquely identifies each row (tract) */
// assert id!=.				/* The unique id - 'id' - does not have any missing values	*/
//
// spset id
// spset modify	/* Set the data set as spatial data w/id as the geographic identifier */
// save, replace
//
// spmatrix create contiguity W		/* Set contiguity weights matrix */
// spmatrix create idistance M		/* Set inverse distance weight matrix */		
//
// ** Linear Regression - Spatial Lag
//
// *** Superfund
// 
// reg pnpl peopcolorpct lowincpct lingisopct lesshspct
//
// estat moran, errorlag(W)	
//
// *** RMP
//
// reg prmp peopcolorpct lowincpct lingisopct lesshspct
//
// estat moran, errorlag(W)	
//
// *** Hazardous
//
// reg ptsdf peopcolorpct lowincpct lingisopct lesshspct
//
// estat moran, errorlag(W)	
//
// * Export results for GWR model *
// export delimited using "D:\GEOG464\final\final_mgwr.csv", nolabel replace

* Poisson/Negative Binomial *******************************************************************************************

** Superfund

*** Poisson - BETTER FIT (AIC:426.18, BIC:446.24)

mepoisson pnpl peopcolorpct lowincpct lingisopct lesshspct || id:

estat ic

*** Negative Binomial (AIC: 428.66, BIC:452.73)

menbreg pnpl peopcolorpct lowincpct lingisopct lesshspct || id:

estat ic

** RMP

*** Poisson - BETTER FIT (AIC:672.74, BIC:692.80)

mepoisson prmp peopcolorpct lowincpct lingisopct lesshspct || id:

estat ic

*** Negative Binomial (AIC:772.59, BIC: 796.66)

menbreg prmp peopcolorpct lowincpct lingisopct lesshspct || id:

estat ic

** Hazardous Waste

*** Poisson (AIC:1966.82, BIC:1990.89)

mepoisson ptsdf peopcolorpct lowincpct lingisopct lesshspct || id:

estat ic

*** Negative Binomial - BETTER FIT (AIC:1963.17, BIC:1987.24)

menbreg ptsdf peopcolorpct lowincpct lingisopct lesshspct || id:

estat ic

* Close log

log close

