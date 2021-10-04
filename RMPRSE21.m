RMPRSE21	;HINES CIOFO/HNB - SEARCH FILE 660 ENTRIES PSAS HCPCS HISTORY;1/23/1998
	;;3.0;PROSTHETICS;**36,62,77,92,90,128,168**;Feb 09, 1996;Build 43
	;
	; Reference to $$SINFO^ICDEX supported by ICR #5747
	; Reference to $$ICDDX^ICDEX supported by ICR #5747
	; Reference to $$VLT^ICDEX   supported by ICR #5747
	;
	; RVD patch #62 - add ICD9 code and Description in the output
	; RVD patch #77 3/17/03 - use RMPR("STA") instead of $$STA^RMPRUTIL
	;
	; AAC Patch 92 08/03/04 - Code Set Versioning (CSV)
	;
EN	S (ITEM,RMPRARR,RMPRI,RMPRDA)=""
	K KILL
	D HOME^%ZIS,DIV4^RMPRSIT G:$D(X) EXIT1
	W !!!
	S DIC="^RMPR(661.1,",DIC(0)="AEQM"
	F ITEM=1:1 S DIC("A")="Select PSAS HCPCS ("_ITEM_"): " D ^DIC G:$D(DTOUT)!(X["^")!(X=""&(ITEM=1)) EXIT1 Q:X=""  D
	.I $D(RMPRI(+Y)) W !,$C(7)," ??",?40,"..Duplicate PSAS HCPCS" S ITEM=ITEM-1 Q
	.S RMPRARR(ITEM)=+Y,RMPRI(+Y)=""
	S RMPRCOUN=0 W !! S %DT("A")="Beginning Date: ",%DT="AEPX",%DT("B")="T-30" D ^%DT S RMPRBDT=Y G:Y<0 EXIT1
ENDATE	S %DT("A")="Ending Date: ",%DT="AEX",%DT("B")="TODAY"
	D ^%DT G:Y<0 EXIT1
	I RMPRBDT>Y W !,$C(7),"Invalid Date Range Selection!!" G ENDATE
	G:Y<0 EXIT
	S RMPREDT=Y,Y=RMPRBDT D DD^%DT S RMPRX=Y,Y=RMPREDT  D DD^%DT S RMPRY=Y
	S %ZIS="MQ" K IOP D ^%ZIS G:POP EXIT
	I '$D(IO("Q")) U IO G PRINT
	K IO("Q") S ZTDESC="SEARCH FOR PSAS HCPCS",ZTRTN="PRINT^RMPRSE21",ZTIO=ION,ZTSAVE("RMPRBDT")="",ZTSAVE("RMPREDT")="",ZTSAVE("RMPRI(")="",ZTSAVE("RMPRX")="",ZTSAVE("RMPRY")="",ZTSAVE("RMPR(""STA"")")="",ZTSAVE("RMPRARR(")=""
	S ZTSAVE("RMPR(")="",ZTSAVE("RMPRSITE")=""
	D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED!" H 1 G EXIT1
PRINT	;ENTRY POINT FOR PRINTING REPORT
	S PAGE=1,(RMPRCOUN,RP,QTYT,COSTT)=0
	S RQ=0
	F  S RQ=$O(RMPRARR(RQ)) Q:RQ'>0!($D(KILL))  D  D REST
	.S RO=$P(RMPRARR(RQ),U,1),RO=RO-1
	.F  S RO=$O(^RMPR(660,"H",RO)) Q:RO'>0  D
	. .Q:RO=""!(RO'=$P(RMPRARR(RQ),U))!($D(KILL))
	. .K ENDD
	. .F  S RP=$O(^RMPR(660,"H",RO,RP)) Q:RP=""!($D(KILL))  D CK
	G EXIT
	Q
EXIT	;EXIT FROM REPORT HERE
	I RMPRCOUN>0,$D(RMPREDT),'$D(KILL) W !!?32,"END OF REPORT"
	I $E(IOST)["C"&($Y<22),'$D(ENDD) F  W ! Q:$Y>20
	I $D(RMPREDT),$E(IOST)["C",'$D(RMPRFLL),'$D(KILL),'$D(DUOUT),'$D(DTOUT),'$D(ENDD) K DIR S DIR(0)="E" D ^DIR
EXIT1	K RMPRARR,%DT,GOTO,QTYT,ITEM,KILL,ENDD,RQ,RP,RO,ITEM,RMPRI,COSTT,DIC,DIR,PAGE,RO,RMPRCOUN,RMPRSE,RMPRBDT,RMPREDT,RMPRX,RMPRY D ^%ZISC
	Q
CK	Q:'$D(^RMPR(660,RP,0))
	;hcpcs
	I ('$P(^RMPR(660,RP,1),U,4))!($P(^(0),U,3)<RMPRBDT)!($P(^(0),U,3)>RMPREDT)  Q
	I $P(^RMPR(660,RP,0),U,10)'=RMPR("STA") Q
	;
	I $P(RMPRARR(RQ),U,1)=$P(^RMPR(660,RP,1),U,4) D CON
	Q
	;
CON	I $Y>(IOSL-6),PAGE=1,'RMPRCOUN W @IOF
	D HEAD S RMPRCOUN=RMPRCOUN+1
	S (RMPRDA,Y)=$P(^RMPR(660,RP,0),U,3) D DD^%DT
	W !,Y,?15,$E($P(^DPT($P(^RMPR(660,RP,0),U,2),0),U,1),1,13),?30,$E($P(^DPT($P(^RMPR(660,RP,0),U,2),0),U,9),6,9)
	W:$P(^RMPR(660,RP,0),U,9)'="" ?36,$E($P(^PRC(440,$P(^RMPR(660,RP,0),U,9),0),U,1),1,35)
	W !,"ITEM: " S ITMP=$P(^RMPR(660,RP,0),U,6)
	W:ITMP'="" $E($P(^PRC(441,$P(^RMPR(661,ITMP,0),U,1),0),U,2),1,20)
	K ITMP
	I $P(^RMPR(660,RP,0),U,13)=4 D
	.W ?27,"QTY: ",$J($P(^RMPR(660,RP,0),U,7),4),?38,"TOTAL COST: ",$J($FN($P(^("LB"),U,9),"P",2),8) S QTYT=QTYT+$P(^(0),U,7),COSTT=COSTT+$P(^("LB"),U,9)
	I $P(^RMPR(660,RP,0),U,13)'=4 W ?27,"QTY: ",$J($P(^RMPR(660,RP,0),U,7),4),?38,"TOTAL COST: ",$J($FN($P(^(0),U,16),"P",2),8) S QTYT=QTYT+$P(^(0),U,7),COSTT=COSTT+$P(^(0),U,16)
	W ?60,$S($P(^RMPR(660,RP,0),U,4)="I":"INITIAL ISSUE",$P(^(0),U,4)="R":"REPLACEMENT",$P(^(0),U,4)="S":"SPARE",$P(^(0),U,4)="X":"REPAIR",$P(^(0),U,4)="5":"RENTAL",1:"UNK"),!,"INITIATOR: "
	I $P(^RMPR(660,RP,0),U,27),$D(^VA(200,$P(^(0),U,27),0)) W ?15,$P(^(0),U)
	;
	; Patch 92 - Code Set Versioning (CSV) changes below
	; AAC - 08/03/04
	; Changes for ICD-10 Class I Remediation Project
	;
	N RMPRACS,RMPRACSI,RMPRCNT,RMPRDAT,RMPRDATA,RMPRERR,RMPRICD,RMPRSICD
	N RMPRPROD,RMPRTOR,RMPRTXT1
	S (RMPRACS,RMPRACSI,RMPRDAT,RMPRDATA,RMPRICD,RMPRSICD)=""
	S (RMPRPROD,RMPRTOR,RMPRTXT1)=""
	S RMPRERR=0
	S RMPRDAT=$P($G(^RMPR(660,RP,0)),U,1)
	; Determine Active Coding System based on Date of Interest
	S RMPRACS=$$SINFO^ICDEX("DIAG",RMPRDAT) ; Supported by ICR 5747
	S RMPRACSI=$P(RMPRACS,U,1)
	S RMPRACS=$P(RMPRACS,U,2)
	S RMPRACS=$S(RMPRACS="ICD-9-CM":"ICD-9 ",RMPRACS="ICD-10-CM":"ICD-10 ",1:"ICD: ")
	;
	; Load Suspense data
	S RMPRDATA=$G(^RMPR(660,RP,10))
	I RMPRDATA'="" D
	.S RMPRTOR=$P(RMPRDATA,U,5) ; TYPE OF REQUEST #8.5
	.S RMPRPROD=$P(RMPRDATA,U,7) ; PROVISIONAL DIAGNOSIS #8.7
	.S RMPRSICD=$P(RMPRDATA,U,8) ; SUSPENSE ICD #8.8
	;
	; If SUSPENSE ICD existed, retrieve data
	I RMPRSICD'="" D
	.; Use new API to return ICD Data
	.S RMPRICD=$$ICDDX^ICDEX(RMPRSICD,RMPRDAT,RMPRACSI,"I") ; Supported by ICR 5747
	.S RMPRERR=$P(RMPRICD,U,1)
	.; Update error message to display either ICD-9 or ICD-10 based on Date Of Interest
	.I RMPRERR<0 W !,RMPRACS_"Message: "_$P(RMPRICD,U,2) Q
	.; Retrieve full ICD Description
	.S RMPRTXT(2)=$$VLT^ICDEX(80,+RMPRICD,RMPRDAT) ; Supported by ICR 5747
	;
	; Check for Manual Suspense and adjust line label if needed
	S RMPRTXT(1)=$S(RMPRTOR="MANUAL"&(RMPRSICD=""):"MANUAL SUSPENSE: ",1:RMPRACS_"CODE: ")
	;
	I +$G(RMPRSICD) D
	.S RMPRTXT(1)=RMPRTXT(1)_$P(RMPRICD,U,2)_"  "
	.;
	.; Process SUSPENSE ICD
	.I $P(RMPRICD,U,10)'>0 D
	..S Y=$P(RMPRICD,U,12) ; Inactive Date
	..D DD^%DT
	..S RMPRTXT(3)="  ** Inactive ** Date: "_Y
	.;
	.; Parse ICD data into 80 char array
	.D PARSE^RMPOPED(.RMPRTXT)
	;
	; Loop to display ICD and Suspense info
	F RMPRCNT=1:1 Q:'$D(RMPRTXT(RMPRCNT))  W !,RMPRTXT(RMPRCNT)
	K RMPRTXT
	;
	; End of Patch 92 & ICD-10 mods
	;
	I $E(IOST)["C"&($Y>(IOSL-6)) S DIR(0)="E" D ^DIR S:Y<1 KILL=1 Q:Y<1  K DIR W @IOF D HEAD Q
	I $Y>(IOSL-6) W @IOF D HEAD
	Q
	;
HEAD	I $Y<2!(PAGE=1) D
	.N RMPRSTAW
	.S RMPRSTAW=RMPR("STA")
	.I RMPRSTAW'="",$D(^DIC(4,RMPRSTAW,99)) S RMPRSTAW=$P(^DIC(4,RMPRSTAW,99),U)
	.W !,"PSAS HCPCS HISTORY:",?15
	.W $E($P(^RMPR(661.1,$P(^RMPR(660,RP,1),U,4),0),U,1),1,39)
	.W ?63,"STA ",RMPRSTAW,?72,"PAGE ",PAGE S PAGE=PAGE+1
	.W !!,"REQUEST DATE",?15,"PATIENT NAME",?30,"SSN",?36,"VENDOR"
	.S Y=RMPRBDT D DD^%DT W ?55,Y,"-" S Y=RMPREDT D DD^%DT W Y
	.W ! F BH=1:1:IOM W "="
	Q
	;
REST	D:'RMPRCOUN NONE Q:$D(KILL)!('RMPRCOUN)  W !,"TOTAL DOLLARS SPENT ON THIS HCPCS: ","$"_$J($FN(COSTT,"P",2),9),?45,"TOTAL QUANTITY ISSUED: ",$J(QTYT,4)
	I $O(RMPRARR(RQ)),$E(IOST)["C" W ! K DIR S DIR(0)="E" D ^DIR S:Y<1 KILL=1 W:'$D(KILL) @IOF
	I $E(IOST)'["C",$O(RMPRARR(RQ)) W @IOF
	S (COSTT,QTYT,RMPRCOUN)=""
	Q
	;
NONE	W @IOF,!!,"No '",$P(^RMPR(661.1,RMPRARR(RQ),0),U,1),"' PSAS HCPCS History for this date range.",!
	;,$P(^PRC(441,$P(^RMPR(661,$P(RMPRARR(RQ),U),0),U),0),U,2)
	I $E(IOST)["C" K DIR S DIR(0)="E" W !!!! D ^DIR W @IOF S:Y<1 KILL=1 S ENDD=1
	Q
XREF	;set new x-ref for the field HCPCS in 660
	;fix HCPCS VA117, REMOVE BLANK SPACE IN R90
	S $P(^RMPR(661.1,2801,0),U,6)="R90"
	W !!,"New Cross Reference for HCPCS..."
	S DIK="^RMPR(660,",DIK(1)="4.5^H" D ENALL^DIK
	W !!,"Done"
	Q
	;END
