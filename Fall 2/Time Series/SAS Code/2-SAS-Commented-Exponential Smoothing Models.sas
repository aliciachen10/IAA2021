/*-----------------------------*/
/*    Exponential Smoothing    */
/*            Models           */
/*                             */
/*        Dr Susan Simmons     */
/*-----------------------------*/

/* Create library for data sets */
libname Time 'Q:\My Drive\Fall 2017 - Time Series\Data';
run;

/* SIMPLE EXPONENTIAL SMOOTHING MODEL -----------------*/

* Create a simple exponential smoothing model;
proc esm data=Time.Steel print=all plot=all lead=24;
	forecast steelshp / model=simple;
run;

* Create a simple exponential smoothing model with ID statement; 
proc esm data=Time.USAirlines print=all plot=all lead=24;
	id date interval=month;
	forecast Passengers / model=simple;
run;


/* LINEAR TREND FOR EXPONENTIAL SMOOTHING  -----------------*/

* Double exponential smoothing; 
proc esm data=Time.Steel print=all plot=all lead=24;
	forecast steelshp / model=double;
run;

* linear exponential smoothing; 
proc esm data=Time.Steel print=all plot=all lead=24;
	forecast steelshp / model=linear;
run;

* damped trend exponential smoothing; 
proc esm data=Time.Steel print=all plot=all lead=24;
	forecast steelshp / model=damptrend;
run;

* linear exponential smoothign with interval = month; 
proc esm data=Time.USAirlines print=all plot=all lead=24;
	id date interval=month;
	forecast Passengers / model=linear;
run;


/* SEASONAL EXPONENTIAL SMOOTHING MODEL -----------------*/

* Additive seasonal exponential smoothing model; 
proc esm data=Time.USAirlines print=all plot=all 
		 seasonality=12 lead=24 outfor=test1;
	forecast Passengers / model=addseasonal;
run;

* mulitplicative seasonal exponential smoothing model; 
proc esm data=Time.USAirlines print=all plot=all 
		 seasonality=12 lead=24;
	forecast Passengers / model=multseasonal;
run;

* Winters additive exponential smoothing model (includes trend); 
proc esm data=Time.USAirlines print=all plot=all 
		 seasonality=12 lead=24;
	forecast Passengers / model=addwinters;
run;

* Winters multiplicative exponential smoothing model (includes trend); 
* Lead = 24; 
proc esm data=Time.USAirlines print=all plot=all 
		 seasonality=12 lead=24;
	forecast Passengers / model=multwinters;
run;

* Winters multiplicative exponential smoothing model (includes trend); 
* Lead = 12; 
proc esm data=Time.USAirlines print=all plot=all lead=12 back=12 seasonality=12;
	forecast Passengers / model=multwinters;
run;


/* EXPLORATION of SEASONAL EXPONENTIAL SMOOTHING MODEL -----------------*/


* Winters multiplicative exponential smoothing model (includes trend); 
* Lead = 12, uses outfor statement to output forecasts; 
proc esm data=Time.USAirlines print=all plot=all 
		 seasonality=12 lead=12 back=12 outfor=test;
	forecast Passengers / model=multwinters;
run;

* calculate |error|/|actual value|;
data test2;
set test;
if _TIMEID_>207;
abs_error=abs(error);
abs_err_obs=abs_error/abs(actual);
run;

* mean of |error|/|actual value| for this forecast;  sdlfk
proc means data=test2 mean;
var abs_error abs_err_obs;
run;


