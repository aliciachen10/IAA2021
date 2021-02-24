/*-------------------------------------#
#       Intervention Variables         #
#              ARIMAX                  #
#         Transfer Functions           #
#                                      #
#            Dr Simmons                #
# -------------------------------------*/


* Visualize the data (hstarts) !!!! ;
proc sgplot data=constr2;
	series x=time y=hstarts;
run;
quit;

* Visualize the data (interest rate) !!!! ;
proc sgplot data=constr2;
	series x=time y=intrate;
run;
quit;

* Visualize the data (contracts) !!!! ;
proc sgplot data=constr2;
	series x=time y=contrcts;
run;
quit;

proc reg data=constr2;
model hstarts= contrcts intrate;
output out=residreg r=resid;
run;
quit;

proc arima data=residreg plots=all;
identify var=resid stationarity=(adf=2);
run;
quit;


proc reg data=constr2;
model hstarts= contrcts intrate time time2;
output out=residreg r=resid;
run;
quit;

proc arima data=residreg plots=all;
identify var=resid stationarity=(adf=2);
run;
quit;


proc reg data=constr2;
model hstarts= contrcts intrate time time2;
output out=residreg r=resid;
run;
quit;

proc arima data=outfinal;
identify var=residual stationarity= (adf=2);
run;
quit;
/* If this is not stationary...maybe try differences, or fitting trig functions */

proc arima data=constr2 plots=all;
identify var=hstarts crosscorr=(contrcts intrate time time2);
estimate input=(contrcts intrate time time2) method=ML;
forecast lead=0 printall out=outfinal;
run;
quit;


proc arima data=constr2 plots=all;
identify var=hstarts crosscorr=(contrcts intrate time time2);
estimate input=(contrcts intrate time time2) q=(12) p=(13,15,17) method=ML;
forecast lead=0 printall out=outfinal;
run;
quit;

/* This is one potential model  */


proc arima data=constr2 plots=all;
	identify var=hstarts(1) crosscorr=(intrate(1) contrcts jan feb mar apr may jun jul aug sep oct nov) nlag=36;
	estimate input=(intrate(1) contrcts jan feb mar apr may jun jul aug sep oct nov) q=1 p=(24) method=ML;
	forecast lead=0 printall out=outfinal;
run;
quit;
/* Another potential model */

/* Now let's consider potential lags of the X variables!! */

data constr3;
	set constr2;
	const1=lag1(contrcts);
	const2=lag2(contrcts);
	const3=lag3(contrcts);
	const4=lag4(contrcts);
	const5=lag5(contrcts);
	const6=lag6(contrcts);
	interest1=lag1(intrate);
	interest2=lag2(intrate);
	interest3=lag3(intrate);
	interest4=lag4(intrate);
	interest5=lag5(intrate);
	interest6=lag6(intrate);
	interest7=lag7(intrate);
	interest8=lag8(intrate);
	interest9=lag9(intrate);
run;


/* First need to check residuals are stationary in mean and variance  */


/* Throw them all lags in :)  */

* glmselect with BIC; 
proc glmselect data=constr3;
	model hstarts=contrcts intrate const1 const2 const3 const4 const5 const6 interest1 interest2 interest3 interest4 interest5 interest6 interest7 interest8 interest9/selection=backward select=BIC;
run;
quit;

* glmselect with AICC ; 
proc glmselect data=constr3;
	model hstarts=contrcts intrate const1 const2 const3 const4 const5 const6 interest1 interest2 interest3 interest4 interest5 interest6 interest7 interest8 interest9/selection=backward select=AICC;
run;
quit;

/*Numerator with lags 3,8,9 for intrate and contracts with 1,2,3 ...residuals are stationary*/
proc arima data=constr3;
identify var=hstarts crosscorr=(contrcts intrate);
estimate input =((3,8,9) intrate (1,2,3) contrcts) method=ML;
forecast lead=0 out=outnew;
run;
quit;

/* Try denominator term for contracts ..residuals are stationary*/
proc arima data=constr3;
identify var=hstarts crosscorr=(contrcts intrate);
estimate input =((3,8,9) intrate /(1) contrcts) method=ML;
forecast lead=0 out=outnew;
run;
quit;

/* Shift for interest rates ....residuals are stationary  */
proc arima data=constr3;
identify var=hstarts crosscorr=(contrcts intrate);
estimate input =(3$(8,9) intrate (1,2,3) contrcts) method=ML;
forecast lead=0 out=outnew;
run;
quit;


proc arima data=outnew;
identify var=residual stationarity=(adf=2);
run;
quit;

proc arima data=constr3 plots=all;
identify var=hstarts crosscorr=(contrcts intrate);
estimate input =((3,8,9) intrate (1,2,3) contrcts) q=1 method=ML;
forecast lead=0 out=outnew;
run;
quit;

proc arima data=constr3 plots=all;
identify var=hstarts crosscorr=(contrcts intrate);
estimate input =((3,8,9) intrate /(1) contrcts) q=1 method=ML;
forecast lead=0 out=outnew;
run;
quit;

proc arima data=constr3 plots=all;
identify var=hstarts crosscorr=(contrcts intrate);
estimate input =(3$(8,9) intrate (1,2,3) contrcts) q=(1)(6) method=ML;
forecast lead=0 out=outnew;
run;
quit;



/* If you want to forecast..you need to forecast X variables!!  But you need to create more dummy 
    variables for season!  */

proc arima data=constr2; 
	identify var=contrcts crosscorr=(jan feb mar apr may jun jul aug sep oct nov time);
	estimate input=(jan feb mar apr may jun jul aug sep oct nov time) p=3 method=ML;
	forecast out=contr_pred lead=0;
run;
quit;


proc arima data=constr2;
	identify var=intrate(1);
	estimate p=(2) q=(2) method=ML;
	forecast out=intrat_pred lead=0;
run;
quit;
