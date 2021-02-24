#-------------------------------------#
#        Seasonal ARIMA Models        #
#                                     #
#            Dr Simmons               #
#-------------------------------------#

* Create a library to access the data sets; 
libname time 'Q:\My Drive\Fall 2017 - Time Series\Data';
run;





* Create a txnoaa data set; 
data txnoaa;
	set time.txnoaa;
	if month=1 then seas1=1; else seas1=0;
	if month=2 then seas2=1; else seas2=0;
	if month=3 then seas3=1; else seas3=0;
	if month=4 then seas4=1; else seas4=0;
	if month=5 then seas5=1; else seas5=0;
	if month=6 then seas6=1; else seas6=0;
	if month=7 then seas7=1; else seas7=0;
	if month=8 then seas8=1; else seas8=0;
	if month=9 then seas9=1; else seas9=0;
	if month=10 then seas10=1; else seas10=0;
	if month=11 then seas11=1; else seas11=0;
run;

* Fit an ARIMA model and obtain a forecast; 
proc arima data=txnoaa;
	identify var=Temperature crosscorr=(seas1 seas2 seas3 seas4 seas5 seas6 seas7 seas8 seas9 seas10 seas11);
	estimate p=1 input=(seas1 seas2 seas3 seas4 seas5 seas6 seas7 seas8 seas9 seas10 seas11);
	forecast lead=12;
run;
quit;

* Now change the txnoaa data set to include sines and cosines; 
data txnoaa;
	set time.txnoaa;
	pi=constant("pi");
	s1=sin(2*pi*1*_n_/12);
	c1=cos(2*pi*1*_n_/12);
	s2=sin(2*pi*2*_n_/12);
	c2=cos(2*pi*2*_n_/12);
	s3=sin(2*pi*3*_n_/12);
	c3=cos(2*pi*3*_n_/12);
	s4=sin(2*pi*4*_n_/12);
	c4=cos(2*pi*4*_n_/12);
run;


* Fit an ARIMA model using this sine & cosine data; 
proc arima data=txnoaa plot=all;
	identify var=temperature crosscorr=(s1 c1 s2 c2 s3 c3 s4 c4);
	estimate p=1 input=(s1 c1 s2 c2 s3 c3 s4 c4);
	forecast lead=12;
run;
quit;


proc arima data=txnoaa;
	identify var=Temperature(12);
	estimate p=1;
	forecast lead=12;
run;
quit;


proc arima data=txnoaa;
identify var=Temperature stationarity=(adf=2 dlag=12);
run;
quit;

/* EXAMPLE: AIRLINEI DATA SET ------------------------------ */ 

proc arima data=time.airline plot=all;
	identify var=LogPsngr(1,12) nlag=25;
	estimate q=(1,12,13) method=ML;
	estimate q=(1)(12) method=ML;
	forecast lead=24;
run;
quit;
