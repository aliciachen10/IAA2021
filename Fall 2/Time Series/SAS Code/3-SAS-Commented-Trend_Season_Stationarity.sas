#------------------------------------#
#        Trend and Season            #
#           Modelling                #
#                                    #
#       Dr Susan Simmons             #
#------------------------------------#

* Create library to access the data sets; 
libname time 'Q:\My Drive\Fall 2017 - Time Series\Data';
run;

/* AUGMENTED DICKEY-FULLER TESTING ----------------------- */

proc arima data=Time.fpp_insurance plot=all;
	identify var=quotes nlag=10 stationarity=(adf=2);
	identify var=quotes(1) nlag=10 stationarity=(adf=2);
run;
quit;


/* DETERMINISTIC TREND EXAMPLE ------------------------- */


* Fit an ARIMA model; 
proc arima data=Time.usairlines plot=all;
	identify var=passengers stationarity=(adf=2) ;
run;
quit;

*Create an index for time;
data newair;
set Time.usairlines;
time=_n_;
run;

* Fit a regression model; 
proc reg data=newair;
	model passengers=time;
run;
quit;

* Fit an ARIMA model with cross-correlated variable; 
   * Notice that this model gives same intercept and slope as the OLS regression!;
proc arima data=newair plot=all;
	identify var=passengers crosscorr=time stationarity=(adf=2) ;
	estimate input=time;
run;
quit;

/* Random Walk  with Drift Example (Ebay Data) -------------*/

proc arima data=Time.Ebay9899 plot=all;
	identify var=DailyHigh nlag=10 stationarity=(adf=2);
	identify var=DailyHigh(1) nlag=10 stationarity=(adf=2);
run;
quit;
