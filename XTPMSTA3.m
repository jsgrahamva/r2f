XTPMSTA3	;OAK/BP - PRINT PATCH STATISTICS BY RELEASED DATE; ; 3/15/11 7:29am
	;;7.3;TOOLKIT;**130**; Apr 25, 1995;Build 2
	;Per VHA Directive 2004-038, this routine should not be modified.
	S IOP="HOME" D ^%ZIS K IOP
EN	W @IOF,"Patch Monitor Statistics By Released Date",!!!
	;
DATE	W ! S %DT="AEP"
	S %DT("A")="Enter BEGINNING Released date: " D ^%DT G:Y<0 EXIT S XTBBDT=Y X ^DD("DD") S XTBBDT1=Y
	S %DT="AE",%DT("A")="     and ENDING Released date: " D ^%DT G:Y<0 EXIT S XTBEDT=Y X ^DD("DD") S XTBEDT1=Y
	I XTBEDT<XTBBDT W !!,$C(7),"Starting date is later than ending date.",!! H 2 G DATE
	W !!,"Do you want to see the patch data" S %=2 D YN^DICN S XTBVIEW=%
	;
DEV	W !! S %ZIS="AEQ" D ^%ZIS G:POP EXIT
	I $D(IO("Q")) S ZTIO=ION,ZTRTN="SORT^XTPMSTA3",ZTSAVE("XTB*")="",ZTDESC="Patch Monitor Statistics By Released Date" D ^%ZTLOAD D HOME^%ZIS
	I $D(ZTSK) W !,"Queued as task #",ZTSK H 2 G EXIT
	;
	; sort patches by released date
SORT	U IO K ^TMP($J)
	S XTBDA=0
	F  S XTBDA=$O(^XPD(9.9,XTBDA)) Q:'XTBDA  DO
	.S XTBDTA=$G(^XPD(9.9,XTBDA,0)) Q:XTBDTA=""
	.S XTBPTNAM=$P(XTBDTA,U,1),XTBNMSP=$P($P(XTBDTA,U,4)," - ",1) Q:XTBNMSP=""  ;parent package missing in file
	.S XTBRELDT=$P(XTBDTA,U,2),XTBPRIOR=$P(XTBDTA,U,3),XTBCPLDT=$P(XTBDTA,U,9)
	.Q:(XTBRELDT<XTBBDT)!(XTBRELDT>XTBEDT)
	.S ^TMP($J,XTBRELDT,XTBPTNAM,XTBDA)=XTBCPLDT_U_XTBPRIOR
PRINT	; 
	S Y=DT X ^DD("DD") S XTBCURDT=Y
	K XTBLINE S $P(XTBLINE,"-",(IOM-2))="-"
	S PG=0 D HDR ; first header
	S (XTBTPTCH,XTBTLATE)=0,XTBPTNAM=""
	F XTBRELDT=0:0 S XTBRELDT=$O(^TMP($J,XTBRELDT)) Q:XTBRELDT=""  F  S XTBPTNAM=$O(^TMP($J,XTBRELDT,XTBPTNAM)) Q:XTBPTNAM=""  D  Q:$D(XTBOUT)
	.F XTBDA=0:0 S XTBDA=$O(^TMP($J,XTBRELDT,XTBPTNAM,XTBDA)) Q:XTBDA=""  D  Q:$D(XTBOUT)
	..S XTBTPTCH=XTBTPTCH+1
	..S XTBDTA=^TMP($J,XTBRELDT,XTBPTNAM,XTBDA)
	..S XTBCPLDT=$P(XTBDTA,U),XTBPRIOR=$P(XTBDTA,U,2)
	..S XTBRCVDT=$P($G(^XPD(9.9,XTBDA,0)),U,2)
	..S XTBPTYPE=$P($G(^XPD(9.9,XTBDA,0)),U,10)
	..I +XTBPTYPE=0 S D0=XTBDA D ^XTPMKPCF S XTBINSDT=XTINST K D0
	..I +XTBPTYPE=1 S XTBINSDT=$P($G(^XPD(9.9,XTBDA,0)),U,11)
	..I XTBINSDT]"" S X1=XTBINSDT,X2=XTBCPLDT D ^%DTC S XTBDAYLT=X
	..I XTBINSDT="" S X1=DT,X2=XTBCPLDT D ^%DTC S XTBDAYLT=X
	..S Y=XTBINSDT X ^DD("DD") I Y'="" S XTBINSDT=$P(Y,",",1)_","_$E($P(Y,",",2),1,4) ;set date format "MON DD,YYYY"
	..S Y=XTBRELDT X ^DD("DD") S XTBRELDX=Y
	..S Y=XTBCPLDT X ^DD("DD") S XTBCPLDT=Y
	..S XTBPRIOR=$S(XTBPRIOR="m":"Mandatory",XTBPRIOR="e":"Emergency",1:"Unknown")
	..I XTBVIEW=1 W XTBRELDX,?14,XTBPTNAM,?27,XTBCPLDT,?41,XTBINSDT,?55,XTBPRIOR
	..I XTBVIEW=1,XTBDAYLT>0 W ?67,$J(XTBDAYLT,3,0)_$S(XTBDAYLT>1:" days",1:" day")
	..I XTBDAYLT>0 S XTBTLATE=XTBTLATE+1
	..I XTBVIEW=1 W ! I $Y>(IOSL-6),IOST?1"C-".E D PAUSE Q:$D(XTBOUT)
	..I XTBVIEW=1 I $Y>(IOSL-6) D HDR
	G:$D(XTBOUT) EXIT
	I $Y>(IOSL-6),IOST?1"C-".E D HDR
	W !!?6,"Totals patches received for date range: ",XTBTPTCH,!
	W "Total patches installed past compliance date: ",XTBTLATE,!!
	S XTBDIVOK=0 I XTBTPTCH>0 S XTBDIVOK=1
	W ?25,"Delinquent patch % : ",$S(XTBDIVOK=1:$J((XTBTLATE/XTBTPTCH*100),6,2),1:100)_" %",!
	W ?25,"      Compliance % : ",$S(XTBDIVOK=1:$J(100-(XTBTLATE/XTBTPTCH*100),6,2),1:100)," %",!
	I IOST?1"C-".E K XTBANS W !!,"Press ENTER to end " R XTBANS:DTIME
	;
EXIT	I IOST?1"C-".E W @IOF,!
	D ^%ZISC
	K %,%DT,%ZIS,XTBNMSP,XTBANS,XTBBDT,XTBBDT1,XTBCPLDT,XTBCPLDX,XTBDA,XTBEDT,XTBEDT1,XTBDAYLT
	K XTBINSDT,XTBLINE,XTBNMSP,XTBOLDNM,XTBNMSP,XTBPTNAM,XTBPTYPE,XTBDTA,XTBGPDA
	K XTBRCVDT,XTBTLATE,XTBTPTCH,D0,DIC,PG,POP,X,X1,X2,Y,ZTDESC,ZTIO,ZTRTN,ZTSAVE,%T,%Y
	K ^TMP($J),XTBOUT,XTBPGF,XTBOLGRP,ZTSK,XTBRELDT,XTBPRIOR,XTBCURDT,XTBDIVOK,XTBVIEW,XTINST
	Q
	;
HDR	S PG=PG+1 I IOST?1"P-".E,PG>1 W @IOF
	I IOST?1"C-".E W @IOF
	W XTBCURDT S X="Patch Statistical Report for "_^DD("SITE")
	W ?(IOM-$L(X)\2),X,?(IOM-12),"Page: ",PG,!,?31,"By Released Date",!
	S X="Date range: "_XTBBDT1_" to "_XTBEDT1 W ?(IOM-$L(X)\2),X,!
	W !,"Release",?14,"Patch",?27,"Compliance",?41,"Install",?67,"# Days",!
	W "Date",?14,"Number",?27,"Date",?41,"Date",?55,"Priority",?67,"Delinquent",!,XTBLINE,!
	Q
	;
PAUSE	Q:IOST'?1"C-".E
	K XTBANS,XTBOUT W !!,"Press ENTER to continue or '^' to end " R XTBANS:DTIME
	I XTBANS[U!('$T) S (XTBNMSP,XTBPTNAM,XTBCPLDT,XTBDA)="99999999",XTBOUT=1
	Q
	;
ADDOP	; Add a new option under the XUSER menu option.
	N XUA,XUB,XUC
	S XUA="XTPM PATCH REPORTS"
	S XUB="XTPM PATCH STATS BY RELEASED"
	IF $$FIND1^DIC(19,,"X",XUA,,,),$$FIND1^DIC(19,,"X",XUB,,,) S XUC=$$ADD^XPDMENU(XUA,XUB,8,)
	Q
