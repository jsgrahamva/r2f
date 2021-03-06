RGMTAUD	;BIR/CML-MPI/PD AUDIT FILE PRINT FOR A SPECIFIED PATIENT ;20 May 2013  2:06 PM
	;;1.0;CLINICAL INFO RESOURCE NETWORK;**3,19,20,30,60**;30 Apr 99;Build 2
	;Reference to ^DIA(2 and data derived from the AUDIT file (#1.1)
	;is supported by IA #2097 and #2602.
	;Reference to ^ORD(101 supported by IA #2596
	;
	;**60 MVI_1901 (cml) made extensive changes to accommodate the audit data for multiple subfields within the PATIENT file.
	;
	S QFLG=1
BEGIN	;
	W !!,"This option prints information from the AUDIT file (#1.1) for a"
	W !,"selected patient and date range."
	W !!,"For the PATIENT file (#2) entry selected, the report prints the"
	W !,"patient name and DFN, date/time the field was edited, the user who"
	W !,"made the change, the field edited, the old value, and the new value."
	W !,"The option or protocol (if available) will also be displayed."
	;
ASK1	;Ask for PATIENT
	W !
	S DIC="^DPT(",DIC(0)="QEAM",DIC("A")="Select PATIENT: " D ^DIC K DIC G:Y<0 QUIT S RGDFN=+Y
	;
DSP	;Display if audit data is available - **60 MVI_1901 (cml) new subroutine added to pick up audit data for multiple subfields
	S (GOT,EARLY,EARLYM)=0,EARLYDT=""
	S PTNM=$P(^DPT(RGDFN,0),"^")
	;check top level audits
	S IEN=0 F  S IEN=$O(^DIA(2,"B",RGDFN,IEN)) Q:'IEN  D
	.I $D(^DIA(2,IEN,0)) S EDITDT=$P(^(0),"^",2),GOT=1 S:EARLY=0 EARLY=EDITDT S:EDITDT<EARLY EARLY=EDITDT
	;check multiple level
	S DFNMULT=RGDFN_",0" F  S DFNMULT=$O(^DIA(2,"B",DFNMULT)) Q:DFNMULT=""  Q:$P(DFNMULT,",")'=RGDFN  I $D(^DIA(2,"B",DFNMULT)) D
	.S IEN=0 F  S IEN=$O(^DIA(2,"B",DFNMULT,IEN)) Q:'IEN  I $D(^DIA(2,IEN,0)) S EDITDT=$P(^(0),"^",2),GOT=1 S:EARLYM=0 EARLYM=EDITDT S:EDITDT<EARLYM EARLYM=EDITDT
	;
	I 'GOT W !!,"There is no audit data available for any date for ",PTNM,"." G ASK1
	I EARLYM=0,EARLY>0 S EARLYDT=EARLY
	I EARLY=0,EARLYM>0 S EARLYDT=EARLYM
	I EARLY>0,EARLYM>EARLY S EARLYDT=EARLY
	I EARLYM>0,EARLY>EARLYM S EARLYDT=EARLYM
	W !!,"The earliest audit data is "_$$FMTE^XLFDT(EARLYDT)_"."
	;
ASK2	;Ask for Date Range
	I '$D(RGDFN)&($D(DFN)) S RGDFN=DFN
	W !!,"Enter date range for data to be included in report."
	K DIR,DIRUT,DTOUT,DUOUT S DIR(0)="DAO^:DT:EPX",DIR("A")="Beginning Date:  " D ^DIR K DIR G:$D(DIRUT) QUIT
	S RGBDT=Y,DIR(0)="DAO^"_RGBDT_":DT:EPX",DIR("A")="Ending Date:  " D ^DIR K DIR G:$D(DIRUT) QUIT S RGEDT=Y
	;
DEV	W !!,"The right margin for this report is 80.",!!
	S ZTSAVE("RGBDT")="",ZTSAVE("RGEDT")="",ZTSAVE("RGDFN")=""
	D EN^XUTMDEVQ("START^RGMTAUD","MPI/PD - Print AUDIT File Data for a Specific Patient",.ZTSAVE) I 'POP Q
	W !,"NO DEVICE SELECTED OR REPORT PRINTED!!"
	G QUIT
	;
START	;
	K ^TMP("RGMTAUD",$J) S U="^"
	;
LOOP	;Loop on "B" xref of the AUDIT file
	S STOP=RGEDT+1
	S IEN=0 F  S IEN=$O(^DIA(2,"B",RGDFN,IEN)) Q:'IEN  D
	.I $D(^DIA(2,IEN,0)) S EDITDT=$P(^(0),U,2) I EDITDT>RGBDT,EDITDT<STOP D
	..S ^TMP("RGMTAUD",$J,EDITDT,IEN)=""
	;
	;find any audit data for audited fields that are multiples  - **60 MVI_1901 (cml)
	S DFNMULT=RGDFN_",0" F  S DFNMULT=$O(^DIA(2,"B",DFNMULT)) Q:DFNMULT=""  Q:$P(DFNMULT,",")'=RGDFN  I $D(^DIA(2,"B",DFNMULT)) D
	.S IEN=0 F  S IEN=$O(^DIA(2,"B",DFNMULT,IEN)) Q:'IEN  D
	..I $D(^DIA(2,IEN,0)) S EDITDT=$P(^(0),"^",2) I EDITDT>RGBDT,EDITDT<STOP S ^TMP("RGMTAUD",$J,EDITDT,IEN)=""
	; **60 MVI_1901 (cml) changes stop here
	;
PRT	;Print report
	S (PG,QFLG)=0,U="^",$P(LN,"-",81)="",SITE=$P($$SITE^VASITE(),U,2)
	S PRGBDT=$$FMTE^XLFDT(RGBDT),PRGEDT=$$FMTE^XLFDT(RGEDT)
	D NOW^%DTC S HDT=$$FMTE^XLFDT($E(%,1,12))
	D HDR
	I '$O(^TMP("RGMTAUD",$J,0)) W !!,"No audit data found in this date range for this patient." G QUIT
	S EDITDT=0 F  S EDITDT=$O(^TMP("RGMTAUD",$J,EDITDT)) Q:QFLG  Q:'EDITDT  D
	.S IEN=0 F  S IEN=$O(^TMP("RGMTAUD",$J,EDITDT,IEN)) Q:QFLG  Q:'IEN  D
	..S PRTDT=$$FMTE^XLFDT($E(EDITDT,1,12))
	..S IEN0=^DIA(2,IEN,0)
	.. ;**60 MVI_1901 (cml) modified to pick up audit data for multiple subfields and check for bad DD references
	..S FILE=2,FIELD=$P(IEN0,"^",3) I FIELD["," S FILE=+$P($G(^DD(2,$P(FIELD,","),0)),"^",2) Q:'FILE  S FIELD=$P(FIELD,",",2)
	..K RGARR D FIELD^DID(FILE,FIELD,"","LABEL","RGARR")
	..S FLD=$G(RGARR("LABEL")) Q:FLD=""
	.. ; **60 MVI_1901 (cml) changes stop here
	..S USER=$P(IEN0,U,4)
	..I 'USER S USER="UNKNOWN"
	..I USER'="UNKNOWN" S DIC="^VA(200,",DIC(0)="MZO",X="`"_USER D ^DIC S USER=$P(Y,"^",2)
	..S OLD=$G(^DIA(2,IEN,2)) I OLD']"" S OLD="<no previous value>"
	..S NEW=$G(^DIA(2,IEN,3)) I NEW']"" S NEW="<no current value>"
	..K OPTDA1,OPTDA2,RGOPTN,OPTNM I $G(^DIA(2,IEN,4.1)) D
	...S OPTDA1=+$P(^DIA(2,IEN,4.1),"^")
	...I OPTDA1 S DIC=19,DR=".01",DA=OPTDA1,DIQ(0)="EI",DIQ="RGOPTN" D EN^DIQ1 K DIC,DR,DA,DIQ S RGOPTN=$G(RGOPTN(19,OPTDA1,.01,"E"))
	...S OPTDA2=$P(^DIA(2,IEN,4.1),"^",2)
	...I $P(OPTDA2,";",2)="ORD(101," S DIC=101,DR=".01",DA=+OPTDA2,DIQ(0)="EI",DIQ="RGOPTN" D EN^DIQ1 K DIC,DR,DA,DIQ S OPTNM=$G(RGOPTN(101,+OPTDA2,.01,"E")) Q
	...I +OPTDA2 S DIC=19,DR=".01",DA=+OPTDA2,DIQ(0)="EI",DIQ="RGOPTN" D EN^DIQ1 K DIC,DR,DA,DIQ S OPTNM=$G(RGOPTN(19,+OPTDA2,.01,"E")) Q
	..D:$Y+4>IOSL HDR Q:QFLG  W !!,PRTDT,?20,FLD,?51,USER,!?20,OLD," / ",NEW
	..I $G(RGOPTN)'="" W !?3,RGOPTN ;**20
	..I $G(OPTNM)'="" W:$G(RGOPTN)="" !?3 W "/",$G(OPTNM) ;**20
	;
QUIT	;
	I $E(IOST,1,2)="C-"&('QFLG) S DIR(0)="E" D  D ^DIR K DIR
	.S SS=22-$Y F JJ=1:1:SS W !
	K ^TMP("RGMTAUD",$J)
	K %,%I,DFN,RGDFN,EDITDT,FLD,HDT,IEN,IEN0,JJ,LN,NEW,OLD,OPTDA1,OPTDA2,RGOPTN,OPTNM,PG,PRGBDT,PRGEDT,PRTDT
	K DFNMULT,EARLY,EARLYDT,EARLYM,FIELD,FILE,GOT,PTNM,QQ,SUB   ;**60 MVI_1901 (cml)
	K QFLG,RGARR,RGBDT,RGEDT,SITE,SS,STOP,USER,X,Y,ZTSK
	D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" Q
	;
HDR	;HEADER
	I $E(IOST,1,2)="C-" S SS=22-$Y F JJ=1:1:SS W !
	I $E(IOST,1,2)="C-",PG>0 S DIR(0)="E" W ! D ^DIR K DIR I 'Y S QFLG=1 Q
	S PG=PG+1 W:$Y!($E(IOST,1,2)="C-") @IOF
	W !,"PATIENT AUDIT LIST at ",SITE," on ",HDT,?72,"Page: ",PG
	W !,"Patient: ",$P(^DPT(RGDFN,0),U)," (DFN #",RGDFN,")"
	W !,"Date Range: ",PRGBDT," to ",PRGEDT
	W !!,"Date/Time Edited",?20,"Field Edited",?51,"Edited By"
	W !?20,"Old Value / New Value",!?3,"Option/Protocol",!,LN
	Q
