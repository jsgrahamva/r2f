LREPIRP7	;DALOI/CKA - EPI-PRINT VERIFICATION REPORT ;23 Apr 2013  4:33 PM
	;;5.2;LAB SERVICE;**281,320,421**;Sep 27, 1994;Build 48
	; Reference to X ^DD("DD") supported by IA #10017
	;USED TO PRINT VERIFICATION REPORT
	W !?5,"Print Detailed Verification Report Option",!!
CHOOSE	;which date report to print
	S LRNODE="LREPIREP",LRDATE=0,LRNUM=1
	F  S LRNODE=$O(^XTMP(LRNODE)) Q:LRNODE=""!(LRNODE'["LREPIREP")  S LRDATE=$E(LRNODE,9,22) D
	.S Y=LRDATE X ^DD("DD") S LRREP(LRNUM)=LRDATE_"^"_Y,LRNUM=LRNUM+1
	F LRNUM=1:1 Q:'$D(LRREP(LRNUM))  W !,LRNUM_" "_$P(LRREP(LRNUM),"^",2),$E(^XTMP("LREPIREP"_$P(LRREP(LRNUM),"^"),"HDG",3),12,99)
	S LRNUM=LRNUM-1
	S DIR(0)="NO^1:"_LRNUM
	S DIR("A")="Choose the number for the report you wish to print"
	D ^DIR
	G:$D(DIRUT) EXIT
	S LRREP=Y
	K DIR,DIRUT
	G:$D(DIRUT) CHOOSE
	S LRDATE=$P(LRREP(LRREP),"^")
	I '$D(^XTMP("LREPIREP"_LRDATE,"DONE")) D  Q
	.W !!
	.W !?5,"This report is not completed generating."
	.W !?5,"Please try again later."
	.S LREND=1
PRIV	;PRIVACY MESSAGE
	W !!!,"This report will contain Confidential Information."
	K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue/proceed"
	S DIR("B")="NO"
	D ^DIR S:$D(DIRUT) LREND=1
	G:'Y EXIT
ALL	K DIR,DIRUT
	S DIR(0)="Y",DIR("B")="NO",DIR("A")="Include All Pathogens"
	S DIR("?")="Enter (Y)es or return for all entries to be Selected"
	D ^DIR
	S LRALL=+Y
	K DIR
	I +LRALL'>0 D
	.W @IOF
	.F  Q:$D(DIRUT)  D  Q:X=""
	..S DIR(0)="PAO^69.5:EMZ",DIR("A")="Select Pathogens: "
	..S DIR("?")="Select the Pathogens. "
	..S DIR("S")="I Y<100"
	..D ^DIR
	..Q:$D(DIRUT)!(Y=-1)
	..S LREPI($P(^LAB(69.5,+Y,0),U,9))=+Y
	..K DIR,DTOUT,DUOUT,DIRUT
	G:$D(DTOUT)!$D(DUOUT) Q
	I '$D(LREPI)&('LRALL) W !,"Sorry No Pathogens Selected" G CHOOSE
	D REP
EXIT	;
	D ^%ZISC
	K DIC,D0,LRAUTO,LRBEG,LRDT,LREND,LRRNDT,LREPI,LRRPE,LRRPS,ZTSAVE
	K ZTRTN,ZTIO,ZTDESC,ZTDTH,ZTSK,X,Y,X1,%DT,POP,%ZIS
	K LRCOUNT,LRLC,LRHDG,LRQUIT,LRHDGLC,LRPAGE,LRNODE
	K DIR,DIRUT,DTOUT,DUOUT,J,LRMSGLIN,LRREP,LRSPSHT,MSG
	K LRALL,LRCOUNT,LRDATE,LRDFN,LRDG1,LRDSPCNT,LRNUM,LROBR,LROBX,LRPAGE
	K LRPATH,LRPID,LRSEG,LRTYPE,LRUPDNUM,LRZXECNT
	K LRSBCNT,LRPV1,LRNOPAT,LRADMDT,LRDG1CNT,LRDISDT,LRDSP,LRDTHDG,LRHDGL2
	K LRI,LRNAME,LRNTECNT,LRNUM1,LROBRCNT,LROBXCNT,LRPATHCT,LRPERCNT
	K LRPV1CNT,LRPV1N,LRPV1ND,LRSUBCNT,LRTMP,LRTOT,LRTOTCNT,LRZXE,SITE,SSN
	K ZTREQ
	Q
	;
REP	;
Q	S %ZIS="Q" D ^%ZIS Q:POP  I '$D(IO("Q")) U IO D PRT Q
	S ZTRTN="PRT^LREPIRP7",ZTSAVE("LR*")="",ZTDESC="PRINT EPI VERIFICATION REPORT",ZTREQ="@" D ^%ZTLOAD
	I $D(ZTSK)[0 W !!?5,"Report Cancelled."
	E  W !!?5,"The Task has been queued",!,"Task #",$G(ZTSK) H 5
	D HOME^%ZIS G EXIT
	Q
PRT	;Print report
	I 'LRALL D PATH G EXIT
	S LRPATH=0,LRDFN=0,LRPV1=0,LROBR=0,LROBX=0,LRPAGE=1,LRQUIT=0,LRNUM=0
	S LRPATH=1 D PPRT1^LREPIRP8
	I LRQUIT G EXIT
	S LRDFN=0,LRPV1=0,LRDG1=0
	S LRPATH=2 D PPRT3^LREPIRP8
	I LRQUIT G EXIT
	S LRDFN=0
	F LRPATH=3,4,5,6 D PPRT1^LREPIRP8 Q:LRQUIT  S LRDFN=0
	I LRQUIT G EXIT
	S LRDFN=0,LRPV1=0,LRDG1=0
	S LRPATH=7 D PPRT2^LREPIRP8
	I LRQUIT G EXIT
	S LRDFN=0,LRNUM=0
	S LRPATH=8 D PPRT1^LREPIRP8
	I LRQUIT G EXIT
	S LRDFN=0,LRPV1=0,LRDG1=0
	S LRPATH=9 D PPRT2^LREPIRP8
	I LRQUIT G EXIT
	S LRDFN=0,LRNUM=0
	S LRPATH=10 D PPRT1^LREPIRP8
	I LRQUIT G EXIT
	S LRDFN=0,LRPV1=0,LRDG1=0
	F LRPATH=11,12,13,14 D PPRT4^LREPIRP8 Q:LRQUIT  S LRDFN=0
	I LRQUIT G EXIT
	S LRDFN=0,LRPV1=0,LROBR=0,LROBX=0,LRDG1=0
	F LRPATH=15,16,17 D PPRT3^LREPIRP8 Q:LRQUIT  S LRDFN=0
	I LRQUIT G EXIT
	S LRDFN=0
	F LRPATH=18,19,20,21,22,23 D PPRT1^LREPIRP8 Q:LRQUIT  S LRDFN=0
	I LRQUIT G EXIT
	S LRDFN=0,LRPV1=0,LRDG1=0
	W @IOF
	W !,?70,"  PAGE ",LRPAGE
	S LRHDGLC=0,LRLC=0
	F  S LRHDGLC=$O(^XTMP("LREPIREP"_LRDATE,"UPDHDG",LRHDGLC)) Q:LRHDGLC=""  W !,^(LRHDGLC)
	S LRPAGE=LRPAGE+1
	W !!,"Name                     LAST 4  Admission date     Discharge date"
	W !,"__________________________________________________________________"
	S LRUPDNUM=0
	F  S LRUPDNUM=$O(^XTMP("LREPIREP"_LRDATE,"UPDATES",LRUPDNUM)) Q:LRUPDNUM=""  W !,^(LRUPDNUM) I $Y>(IOSL+14) D NPG
	W @IOF
	W !,?70,"PAGE ",LRPAGE
	S LRHDGLC=0,LRLC=0
	F  S LRHDGLC=$O(^XTMP("LREPIREP"_LRDATE,"PHHDG",LRHDGLC)) Q:LRHDGLC=""  W !,^(LRHDGLC)
	S LRPAGE=LRPAGE+1
	W !!
	S LRTYPE="",LRZXECNT=0,LRCOUNT=0,LRSBCNT=0,LRDFN=0
	F  S LRTYPE=$O(^XTMP("LREPIREP"_LRDATE,"ZXE",LRTYPE)) Q:LRTYPE=""  D  D ZXETOT S LRSBCNT=0
	.W !,LRTYPE
	.F  S LRDFN=$O(^XTMP("LREPIREP"_LRDATE,"ZXE",LRTYPE,LRDFN)) Q:LRDFN=""  D
	..F  S LRZXECNT=$O(^XTMP("LREPIREP"_LRDATE,"ZXE",LRTYPE,LRDFN,LRZXECNT)) Q:LRZXECNT=""  D
	...W !,?5,^XTMP("LREPIREP"_LRDATE,"ZXE",LRTYPE,LRDFN,LRZXECNT)
	...S LRSBCNT=LRSBCNT+1
	...I $Y>(IOSL+1) D NPG
	W !,"------------------------------------------------------------"
	W !?5,"COUNT ",LRCOUNT
	W @IOF
	W !?70,"PAGE ",LRPAGE
	S LRHDGLC=0,LRLC=LRLC+1,LRCOUNT=0,LRSUBCNT=0
	F  S LRHDGLC=$O(^XTMP("LREPIREP"_LRDATE,"HEPCHDG",LRHDGLC)) Q:LRHDGLC=""  W !,^(LRHDGLC)
	S LRPAGE=LRPAGE+1
	W !!
	F LRNUM=1:1:7 W !! D
	.I LRNUM=1 W !,"DECLINED ASSESSMENT FOR HEPATITIS C"
	.I LRNUM=2 W !,"NO RISK FACTORS FOR HEPATITIS C"
	.I LRNUM=3 W !,"PREVIOUSLY ASSESSED FOR HEPATITIS C"
	.I LRNUM=4 W !,"RISK FACTORS FOR HEPATITIS C"
	.I LRNUM=5 W !,"POSITIVE TEST FOR HEPATITIS C ANTIBODY"
	.I LRNUM=6 W !,"NEGATIVE TEST FOR HEPATITIS C ANTIBODY"
	.I LRNUM=7 W !,"HEPATITIS C DIAGNOSIS (ICD BASED)"
	.W !,"--------------------------------------"
	.S LRTOT(LRNUM)=$G(^XTMP("LREPIREP"_LRDATE,"HEPTOT",LRNUM))
	.I LRTOT(LRNUM)="" W !!,"NO PATIENTS REPORTED FOR THE REPORT PERIOD" Q
	.S LRTYPE="",LRDSPCNT=0,LRCOUNT=0,LRSBCNT=0,LRDFN=0
	.F  S LRTYPE=$O(^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE)) Q:LRTYPE=""  D  D:LRSBCNT>0 DSPTOT S LRSBCNT=0
	..F  S LRDFN=$O(^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN)) Q:LRDFN=""  D
	...F  S LRDSPCNT=$O(^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT)) Q:LRDSPCNT=""  D
	....I LRNUM=1&(LRTYPE="DECLINED HEP C RISK ASSESSMENT") W !?5,^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT) D:($Y>(IOSL+11)) NPG S LRSBCNT=LRSBCNT+1
	....I LRNUM=2&(LRTYPE="NO RISK FACTORS FOR HEP C") W !?5,^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT) D:($Y>(IOSL+11)) NPG S LRSBCNT=LRSBCNT+1
	....I LRNUM=3&(LRTYPE="PREVIOUSLY ASSESSED HEP C RISK") W !?5,^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT) D:($Y>(IOSL+11)) NPG S LRSBCNT=LRSBCNT+1
	....I LRNUM=4&(LRTYPE="RISK FACTOR FOR HEPATITIS C") W !?5,^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT) D:($Y>(IOSL+11)) NPG S LRSBCNT=LRSBCNT+1
	....I LRNUM=5&(LRTYPE="HEP C VIRUS ANTIBODY POSITIVE") W !?5,^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT) S LRSBCNT=LRSBCNT+1
	....I LRNUM=6&(LRTYPE="HEP C VIRUS ANTIBODY NEGATIVE") W !?5,^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT) S LRSBCNT=LRSBCNT+1
	....I LRNUM=7&(LRTYPE="HEPATITIS C INFECTION") W !?5,^XTMP("LREPIREP"_LRDATE,"DSP",LRTYPE,LRDFN,LRDSPCNT) D:($Y>(IOSL+11)) NPG S LRSBCNT=LRSBCNT+1
	W !,"-----------------------------------------------------------------"
	W !?5,"COUNT ",LRCOUNT
	K MSGLIN,LRSEG
	Q
PATH	S LRPATH=0,LRDFN=0,LRPV1=0,LROBR=0,LROBX=0,LRPAGE=1,LRQUIT=0
	F  S LRPATH=$O(LREPI(LRPATH)) Q:'LRPATH  D  Q:LRQUIT  S LRDFN=0
	.I LRPATH=11!(LRPATH=12)!(LRPATH=13)!(LRPATH=14) D PPRT4^LREPIRP8 Q
	.I LRPATH=7!(LRPATH=9) D PPRT2^LREPIRP8 Q
	.I LRPATH=2!(LRPATH=15)!(LRPATH=16)!(LRPATH=17) D PPRT3^LREPIRP8 Q
	.D PPRT1^LREPIRP8
	G EXIT
	Q
ZXETOT	;PRINT PHARMACY SUBTOTALS
	W !,"---------------------------------------------------------------"
	W !,?5,"SUBCOUNT  ",LRSBCNT
	W !!
	S LRCOUNT=LRCOUNT+LRSBCNT
	Q
DSPTOT	W !,"---------------------------------------------------------------"
	W !?5,"SUBCOUNT  ",LRSBCNT
	W !!
	S LRCOUNT=LRCOUNT+LRSBCNT
	Q
PAUSE	;
	Q:$G(LREND)
	K DIR S DIR(0)="E" D ^DIR
	S:($D(DTOUT))!($D(DUOUT)) LRQUIT=1
	Q
NPG	;NEW PAGE
	D:$E(IOST,1,2)="C-" PAUSE
	Q:$G(LRQUIT)
	W @IOF
	Q
HDG	;
	W @IOF
	S LRLC=0
	W !,?70,"  PAGE ",LRPAGE
	F LRHDGLC=1:1:3 S LRHDG=$G(^XTMP("LREPIREP"_LRDATE,"HDG",LRHDGLC)) D
	.W !,LRHDG
	.S LRLC=LRLC+1
	W ! S LRLC=LRLC+1
	S LRHDGLC=0
	F  S LRHDGLC=$O(^XTMP("LREPIREP"_LRDATE,LRPATH,"HDG",LRHDGLC)) Q:LRHDGLC=""  D
	.S LRHDG=$G(^XTMP("LREPIREP"_LRDATE,LRPATH,"HDG",LRHDGLC))
	.W !,LRHDG
	.S LRLC=LRLC+1
	S LRPAGE=LRPAGE+1
	Q
