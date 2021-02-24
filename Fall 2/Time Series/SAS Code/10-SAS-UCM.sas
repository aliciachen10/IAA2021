libname time 'Q:\My Drive\Fall 2017 - Time Series\Data';
run;

proc sgplot data=time.airline;
series x=date y=logpsngr;
run;
quit;

/* Fitting a level */
proc ucm data=time.airline plots=all;
level;
irregular;
model logpsngr;
run;

/* Notice what this predicts!!  */
proc ucm data=time.airline plots=all;
level;
irregular;
model logpsngr;
forecast lead=24;
run;

/* Fitting a level, slope and season component */
proc ucm data=time.airline;
level;
slope;
season length=12 type=trig;
irregular;
model logpsngr;
run;
 /* Make slope deterministic */
proc ucm data=time.airline;
level;
slope variance = 0 noest;
season length=12 type=trig;
irregular;
model logpsngr;
run;

/* print smoothed plots of components */
proc ucm data=time.airline ;
level plot=smooth;
slope variance = 0 noest plot=smooth;
season length=12 type=trig plot=smooth;
irregular;
model logpsngr;
run;




/* Look at ACF and PACF and White Noise plots */
proc ucm data=time.airline ;
level plot=smooth;
slope variance = 0 noest;
season length=12 type=trig plot=smooth;
irregular SQ=1;
estimate plot=(acf pacf wn); 
model logpsngr;
run;



/* Forecast */
proc ucm data=time.airline plots=all ;
level ;
slope variance = 0 noest;
season length=12 type=trig ;
irregular SQ=1;
estimate plot=(acf pacf wn); 
model logpsngr;
forecast lead=24;
run;


