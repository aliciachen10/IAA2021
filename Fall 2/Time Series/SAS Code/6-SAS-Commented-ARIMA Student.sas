/*-----------------------------*/
/*      ARIMA Forecasting &    */
/*        Identification       */
/*                             */
/*        Dr Susan Simmons     */
/*-----------------------------*/

* Create a library to access the data sets; 
libname time 'Q:\My Drive\Fall 2017 - Time Series\Data';
run;

/* BUILDING AN AUTOREGRESSIVE MOVING AVERAGE MODEL ---------- 
   (AUTOMATIC SELECTION TECHNIQUES)                ---------- */

* Fit an ARIMA model; 
proc arima data=Time.Hurricanes plot=all;
	identify var=MeanVMax nlag=12 stationarity=(adf=2);
run;
quit;

* Model identification with minimum information criterion (MINIC); 
proc arima data=Time.Hurricanes plot=all;
	identify var=MeanVMax nlag=12 minic P=(0:12) Q=(0:12);
run;
quit;

* Model identification with smallest canonical correlation (SCAN); 
proc arima data=Time.Hurricanes plot=all;
	identify var=MeanVMax nlag=12 scan P=(0:12) Q=(0:12);
run;
quit;

* Model identificaiton with extended sample autocorrelation function (ESACF); 
proc arima data=Time.Hurricanes plot=all;
	identify var=MeanVMax nlag=12 esacf P=(0:12) Q=(0:12);
run;
quit;

* Create estimates with our ARIMA model p=2, q=3; 
proc arima data=Time.Hurricanes plot=all;
	identify var=MeanVMax nlag=12;
	estimate  method=ML;
run;
quit;

/* FORECASTING ---------------------------------------------- */
proc arima data=Time.Hurricanes plot=all;
	identify var=MeanVMax nlag=10 ;
	estimate  method=ML;
	forecast lead=10;
run;
quit;




proc iml;

/*select ARIMA parameters*/
phi = {1 0.5};
theta = {1 -0.3};
N = 1000;

/*y = armasim(phi,theta,mean,variance,sample size)*/;
y = armasim(phi,theta,2,1,N);
time = (1:N)`;
All = time || y;
create mydata2 from All[colname= {'time','y'}];
append from All;
close;
quit;

proc arima data=mydata2;
identify var=y;
estimate method=ML;
run;
quit;


proc arima data=mydata2;
identify var=y;
estimate p=1 q=1 method=ML;
run;
quit;
