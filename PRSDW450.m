PRSDW450	;HISC/GWB-WRITE PAID EMPLOYEE DATA ;03/14/03
	;;4.0;PAID;**2,78,106**;Sep 21, 1995;Build 5
	;;Per VHA Directive 2004-038, this routine should not be modified.
WRITE	S NODEDD=^DD(450,FIELDN,0)
	S NODEUTIL=$G(^UTILITY("DIQ1",$J,450,DA,FIELDN,"E"))
	I CATEGORY="VERIFICATION OF EMPLOYMENT",FIELDN=556 D DSPYTD^PRSDYTD Q:PRTC=0
	I CATEGORY="BENEFITS",FIELDN=427 D  D CHECK Q:PRTC=0
	.W:TSPYTD'=0 !,"TSP EMP DED YTD",?30,$J($FN(TSPYTD,",",2),14) K TSPYTD
	I CATEGORY="BENEFITS",FIELDN=232 D  D CHECK Q:PRTC=0
	.W:HBDYTD'=0 !,"HEALTH BENEFITS DEDUCTION YTD",?30,$J($FN(HBDYTD,",",2),14) K HBDYTD
	I (NODEUTIL="")!(NODEUTIL="NA") K NODEDD,NODEUTIL Q
	S INTERNAL=^UTILITY("DIQ1",$J,450,DA,FIELDN,"I")
	S DESC=^UTILITY("DIQ1",$J,450,DA,FIELDN,"E")
	I CATEGORY="VERIFICATION OF EMPLOYMENT",FIELDN=28,INTERNAL<50 W !,"HOURLY RATE",?30,$J($FN(INTERNAL,",",2),14) D CHECK Q:PRTC=0  S INTERNAL=INTERNAL*2087,DESC=DESC_" X 2087"
	I $P(NODEDD,U,2)["NJ",+INTERNAL=0 K NODEDD,NODEUTIL Q
	I PRTC=1 D HDR^PRSDSRS S PRTC=""
	W !,$P(NODEDD,U,1)
	I FIELDN>88,FIELDN<116.3 S INTERNAL="",FNM=$P(NODEDD,U,1) D  G CHECK
	.I $D(^PRSP(454,1,"PUC","C",FNM)) S FUIEN=$O(^PRSP(454,1,"PUC","C",FNM,0)),INTERNAL=$P(^PRSP(454,1,"PUC",FUIEN,0),U,1)
	.I INTERNAL'="",$P(^PRSP(454,1,"PUC",FUIEN,0),U,3)'="" S INTERNAL=INTERNAL_"  "_$P(^PRSP(454,1,"PUC",FUIEN,0),U,3)
	.W ?30,$J(DESC,14),?47,INTERNAL
	I (FIELDN=349)!(FIELDN=355)!(FIELDN=363)!(FIELDN=369) W ?47,DESC G CHECK
	I (FIELDN=725)!(FIELDN=731)!(FIELDN=740)!(FIELDN=746) W ?47,DESC G CHECK
	I FIELDN=565 W ?38,$J(INTERNAL,6,4) G CHECK
	W ?30,$S($P(NODEDD,U,5)["""$""":$J($FN(INTERNAL,",",2),14),$P(NODEDD,U,2)["NJ":$J(INTERNAL,14,2),$P(NODEDD,U,2)["D":$J(DESC,14),1:$J(INTERNAL,14))
	I $P(NODEDD,U,2)'["D",INTERNAL'=DESC D DESC
	K DESC,INTERNAL,NODEDD,NODEUTIL,FNM,FUIEN
CHECK	I $E(IOST,1)="C",$Y>(IOSL-4) D PRTC
	Q
PRTC	W ! K DIR,DIRUT,DIROUT,DTOUT,DUOUT
	S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR S PRTC=Y
	S:$D(DIRUT) PRTC=0
	Q
DESC	I $L(DESC)<33 W ?47,DESC Q
	S COLUMN=47,LGTH=0
	F L1=1:1 Q:LGTH=$L(DESC)!(LGTH>($L(DESC)))  W:$L($P(DESC," ",L1))>(80-COLUMN) ! S:$L($P(DESC," ",L1))>(80-COLUMN) COLUMN=47 W ?COLUMN,$P(DESC," ",L1) S COLUMN=COLUMN+$L($P(DESC," ",L1))+1,LGTH=LGTH+$L($P(DESC," ",L1))+1
	K COLUMN,LGTH,L1
	Q
