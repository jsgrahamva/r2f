ECXUSUR	;ALB/TJL-Surgery Extract Unusual Volume Report ;2/20/14  17:01
	;;3.0;DSS EXTRACTS;**49,71,84,93,105,148,149**;Dec 22, 1997;Build 27
	;
EN	; entry point
	N X,Y,DATE,ECRUN,ECXDESC,ECXSAVE,ECXTL,ECTHLD,ECXPORT,CNT ;149
	N ECSD,ECSD1,ECSTART,ECED,ECEND,ECXERR,QFLG,ECXFLAG
	S QFLG=0,ECTHLD="",ECXFLAG=$G(FLAG)
	; get today's date
	D NOW^%DTC S DATE=X,Y=$E(%,1,12) D DD^%DT S ECRUN=$P(Y,"@") K %DT
	I 'ECXFLAG D BEGIN Q:QFLG
	D SELECT Q:QFLG
	S ECXPORT=$$EXPORT^ECXUTL1 Q:ECXPORT=-1  I $G(ECXPORT) D  Q  ;149 Section added
	.K ^TMP($J,"ECXPORT"),^TMP("ECXPORT",$J)
	.S ^TMP("ECXPORT",$J,0)="NAME^SSN^DAY^CASE #^ENCOUNTER #^PT HOLDING TIME^ANESTHESIA TIME^PATIENT TIME^OPERATION TIME^PACU TIME^OR CLEAN TIME^CANC/ABORT^PRINCIPAL PROCEDURE",CNT=1
	.D PROCESS
	.M ^TMP($J,"ECXPORT")=^TMP("ECXPORT",$J) ;149 Move results to TMP for printing
	.D EXPDISP^ECXUTL1
	.D AUDIT^ECXKILL K ^TMP("ECXPORT",$J)
	S ECXDESC=$S(ECXFLAG:"SUR Volume Report",1:"Surgery Extract Unusual Volume Report")
	S ECXSAVE("EC*")=""
	W !!,"This report requires 132-column format."
	D EN^XUTMDEVQ("PROCESS^ECXUSUR",ECXDESC,.ECXSAVE)
	I POP W !!,"No device selected...exiting.",! Q
	I IO'=IO(0) D ^%ZISC
	D HOME^%ZIS
	D AUDIT^ECXKILL
	Q
	;
BEGIN	; display report description
	W @IOF
	W !,"This report prints a listing of unusual volumes that would be"
	W !,"generated by the Surgery extract (SUR) as determined by a"
	W !,"user-defined threshold value.  It should be run prior to the"
	W !,"generation of the actual extract(s) to identify and fix, as"
	W !,"necessary, any volumes determined to be erroneous."
	W !!,"Unusual volumes are those where either the Operation Time,"
	W !,"Patient Time, Anesthesia Time, Recovery Room Time, OR Clean Time"
	W !,"or Pt Holding Time field is greater than the threshold value."
	W !!,"Note: The threshold can be set after a report is selected."
	W !!,"Run times for this report will vary depending upon the size of"
	W !,"the extract and could take as long as 30 minutes or more to"
	W !,"complete.  This report has no effect on the actual extracts and"
	W !,"can be run as needed."
	W !!,"The report is sorted by descending Volume and Case Number."
	S DIR(0)="E" W ! D ^DIR K DIR I 'Y S QFLG=1 Q
	W:$Y!($E(IOST)="C") @IOF,!!
	Q
	;
SELECT	; user inputs for threshold volume and date range
	N DONE,OUT
	; allow user to set threshold volume
	I 'ECXFLAG D
	.S ECTHLD=25
	.W !!,"The default threshold volume for the Surgery extract is "_ECTHLD_"."
	.W !,"The default threshold volume ("_ECTHLD_") equates to 6 hours."
	.S DIR(0)="Y",DIR("A")="Would you like to change the threshold?",DIR("B")="NO" D ^DIR K DIR I X["^" S QFLG=1 Q
	.I Y D
	..W !!,"Volume > threshold"
	..S DIR(0)="N^0:99",DIR("A")="Enter the new threshold volume" D ^DIR K DIR S ECTHLD=Y I X["^" S QFLG=1 Q
	; get date range from user
	Q:QFLG
	W !!,"Enter the date range for which you would like to scan the"
	W !,"Surgery Extract records.",!
	S DONE=0 F  S (ECED,ECSD)="" D  Q:QFLG!DONE
	.K %DT S %DT="AEX",%DT("A")="Starting with Date: ",%DT(0)=-DATE D ^%DT
	.I Y<0 S QFLG=1 Q
	.S ECSD=Y,ECSD1=ECSD-.1
	.D DD^%DT S ECSTART=Y
	.K %DT S %DT="AEX",%DT("A")="Ending with Date: ",%DT(0)=-DATE D ^%DT
	.I Y<0 S QFLG=1 Q
	.I Y<ECSD D  Q
	..W !!,"The ending date cannot be earlier than the starting date."
	..W !,"Please try again.",!!
	.I $E(Y,1,5)'=$E(ECSD,1,5) D  Q
	..W !!,"Beginning and ending dates must be in the same month and year"
	..W !,"Please try again.",!!
	.S ECED=Y
	.D DD^%DT S ECEND=Y
	.S DONE=1
	Q
	;
PROCESS	; entry point for queued report
	S ZTREQ="@"
	S ECXERR=0 D EN^ECXUSUR1 Q:ECXERR
	S QFLG=0 D PRINT
	Q
	;
PRINT	; process temp file and print report
	N PG,QFLG,GTOT,LN,COUNT,VOL,SUB,REC,PIECE ;149
	U IO
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ Q
	S (PG,QFLG,GTOT,COUNT)=0,$P(LN,"-",132)=""
	I '$G(ECXPORT) D HEADER Q:QFLG  ;149
	S VOL=-999999 F  S VOL=$O(^TMP($J,VOL)) Q:VOL=""!QFLG  D
	.S SUB="" F  S SUB=$O(^TMP($J,VOL,SUB)) Q:SUB=""!QFLG  S REC=^(SUB)  D
	..I $G(ECXPORT) F PIECE=1:1:5,7,11,9,10,6,8,14,13 S ^TMP("ECXPORT",$J,CNT)=$G(^TMP("ECXPORT",$J,CNT))_$P(REC,U,PIECE)_$S(PIECE'=13:"^",1:"") S:PIECE=13 CNT=CNT+1 ;149
	..I $G(ECXPORT) Q  ;149
	..S COUNT=COUNT+1
	..I $Y+3>IOSL D HEADER Q:QFLG
	..W !,?1,$P(REC,U),?7,$P(REC,U,2),?18,$P(REC,U,3),?27,$P(REC,U,4)
	..W ?34,$P(REC,U,5),?55,$$RJ^XLFSTR($P(REC,U,7),4)
	..W ?66,$$RJ^XLFSTR($P(REC,U,11),4),?77,$$RJ^XLFSTR($P(REC,U,9),4)
	..W ?86,$$RJ^XLFSTR($P(REC,U,10),4),?93,$$RJ^XLFSTR($P(REC,U,6),4)
	..W ?103,$$RJ^XLFSTR($P(REC,U,8),4),?113,$P(REC,U,14)
	..W ?117,$P(REC,U,13)
	I $G(ECXPORT) Q  ;149
	Q:QFLG
	I COUNT=0 W !!,?8,$S(ECXFLAG=1:"No surgery volumes to report for this extract",1:"No unusual volumes to report for this extract")
CLOSE	;
	I $E(IOST)="C",'QFLG D
	.S SS=22-$Y F JJ=1:1:SS W !
	.S DIR(0)="E" W ! D ^DIR K DIR
	Q
	;
HEADER	;header and page control
	N SS,JJ
	I $E(IOST)="C" D
	.S SS=22-$Y F JJ=1:1:SS W !
	.I PG>0 S DIR(0)="E" W ! D ^DIR K DIR S:'Y QFLG=1
	Q:QFLG
	W:$Y!($E(IOST)="C") @IOF S PG=PG+1
	W !,$S(ECXFLAG:"SUR Volume Report",1:"Surgery Extract Unusual Volume Report"),?124,"Page: "_PG
	W !,"Start Date: ",ECSTART,?97,"Report Run Date/Time: "_ECRUN
	W !,"  End Date: ",ECEND I 'ECXFLAG W ?97,"     Threshold Value: ",ECTHLD
	W !!,?28,"Case",?38,"Encounter",?52,"Pt Holding",?63,"Anesthesia",?75,"Patient",?83,"Operation",?93,"PACU",?101,"OR Clean",?111,"Canc/",?121,"Principal"
	W !,?1,"Name",?10,"SSN",?20,"Day",?27,"Number",?40,"Number"
	W ?54,"Time",?66,"Time",?77,"Time",?86,"Time",?93,"Time",?103,"Time"
	W ?111,"Abort",?121,"Procedure"
	W !,LN,!
	Q
	;