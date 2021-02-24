/* 
-------------------------------------
        Seasonal ARIMA Models        
       Intervention Variables        
              ARIMAX                 
         Transfer Functions          
                                     
            Dr Simmons               
------------------------------------- 
*/

* Create library to access the data sets; 
libname time 'Q:\My Drive\Fall 2017 - Time Series\Data';
run;

/* BUILDING AN INTERVENTION MODEL ---------- */

* Input the deer accidents data set; 
Data Time.DEER;
	input date date7. deer nondeer;
	format date monyy.;
	label deer = "NC accidents involving deer";
	label nondeer = "other reported accidents";
cards;
01JAN03     1218   18030
01FEB03      937   16132
01MAR03     1013   16098
01APR03      805   17419
01MAY03      762   19054
01JUN03      833   17308
01JUL03      662   17864
01AUG03      583   18858
01SEP03      744   17595
01OCT03     2154   19531
01NOV03     3619   17530
01DEC03     2098   18590
01JAN04     1322   18507
01FEB04     1118   17501
01MAR04      960   16669
01APR04      818   17063
01MAY04      707   17847
01JUN04      722   17310
01JUL04      683   17314
01AUG04      604   18443
01SEP04      708   18276
01OCT04     2154   18194
01NOV04     3566   18625
01DEC04     2147   19468
01JAN05     1377   17388
01FEB05     1133   15170
01MAR05     1118   17075
01APR05      849   17312
01MAY05      771   17716
01JUN05      864   17534
01JUL05      674   17380
01AUG05      595   17449
01SEP05      870   15433
01OCT05     2285   18213
01NOV05     3311   17443
01DEC05     2093   18063
01JAN06     1575   15499
01FEB06     1094   14120
01MAR06      966   15649
01APR06      789   16597
01MAY06      780   17033
01JUN06      920   17895
01JUL06      776   15777
01AUG06      654   17355
01SEP06      814   17306
01OCT06     2566   19396
01NOV06     4095   18543
01DEC06     2575   17533
01JAN07     1613   16470
01FEB07     1345   15442
01MAR07     1376   17760  
01APR07      839   16777
01MAY07      880   17187
01JUN07     1030   17035
01JUL07      943   16007
01AUG07      867   16884
01SEP07     1112   16838
01OCT07     2444   19596
01NOV07     4207   17230
01DEC07     2621   17804
;

* Plot time series of deer accidents; 
proc arima data=Time.DEER plot(unpack)=series(corr);
	identify var=deer nlag=24;
run;

* Add Month variable to deer accident data; 
data Time.DEER;
	set Time.DEER;
	Month = MONTH(Date);
	if month=11 then Nov = 1; else Nov=0;
run;

* Blank deer accidents with next two years; 
data Time.DEER2;
	set Time.DEER;
	input Date Deer Nodeer Month;
	informat Date MONYY5.;
	format Date MONYY5.;
cards;
JAN08 . . 1
FEB08 . . 2
MAR08 . . 3
APR08 . . 4
MAY08 . . 5
JUN08 . . 6
JUL08 . . 7
AUG08 . . 8
SEP08 . . 9
OCT08 . . 10
NOV08 . . 11
DEC08 . . 12
JAN09 . . 1
FEB09 . . 2
MAR09 . . 3
APR09 . . 4
MAY09 . . 5
JUN09 . . 6
JUL09 . . 7
AUG09 . . 8
SEP09 . . 9
OCT09 . . 10
NOV09 . . 11
DEC09 . . 12
;

* Merge the observed data and unobserved "blank" data; 
data Time.DEER2;
	set Time.DEER Time.DEER2;
run;

/* POINT (PULSE) INTERVENTION - DETERMINISTIC -------------------- */

proc arima data=Time.DEER2 plot(unpack)=(series(corr) forecast(all));
	identify var=deer nlag=24 crosscorr=(Nov);
	estimate input=(Nov) method=ML;
	forecast lead=24 id=date interval=month;
run;
quit;


/* POINT (PULSE) INTERVENTION - STOCHASTIC -------------------- */

proc arima data=Time.DEER2 plot(unpack)=(series(corr) forecast(all));
	identify var=deer nlag=24 crosscorr=(Nov);
	estimate input=(/(1)Nov) method=ML;
	forecast lead=24 id=date interval=month;
run;
quit;

/* POINT (PULSE) INTERVENTION - STOCHASTIC + ARIMA MODEL ----------- */

proc arima data=Time.DEER2 plot(unpack)=(series(corr) forecast(all));
	identify var=deer nlag=24 crosscorr=(Nov);
	estimate input=( /(1)Nov) p=(12) method=ML;
	forecast lead=24 id=date interval=month;
run;
quit;


proc arima data=Time.DEER2 plot(unpack)=(series(corr) forecast(all));
	identify var=deer nlag=24 crosscorr=(Date Nov);
	estimate input=( /(1)Nov Date) p=(1)(12) method=ML;
	forecast lead=24 id=date interval=month;
run;
quit;

