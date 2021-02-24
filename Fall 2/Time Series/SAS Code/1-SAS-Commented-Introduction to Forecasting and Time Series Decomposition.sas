/*-----------------------------*/
/* Introduction to Forecasting */
/*  and Time Series Structure  */
/*                             */
/*        Dr Susan Simmons     */
/*-----------------------------*/

/* Create library for data sets */
libname Time 'Q:\My Drive\Fall 2017 - Time Series\Data';
run;

/* Time series plot and decomposition of Airline Passengers */
proc timeseries data=Time.USAirlines plots=(series decomp sc);
	id date interval=month;
	var Passengers;
run;

/* Time series and decomposition of Airline Passengers, but 
   now the seasonal cycle is set to a year
*/
proc timeseries data=Time.USAirlines plots=(series decomp sc) seasonality=12;
	var Passengers;
run;
