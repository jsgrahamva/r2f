PSJOCDT	;BIR/MV - PROCESS DUPLICATE THERAPY ORDER CHECKS ;6 Jun 07 / 3:37 PM
	;;5.0;INPATIENT MEDICATIONS;**181,260,288,257**;16 DEC 97;Build 105
	;
	; Reference to EN^PSODRDU2 is supported by DBIA# 2189.
	;
DT	;
	NEW PSJN1,PSJCLASS,PSJDNCNT,PSJNDV,PSJPROSP,PSJOCDT
	S PSJCLASS=""
	F PSJN1=0:0 S PSJN1=$O(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1)) Q:'PSJN1  D
	. D SETCLASS
	. F PSJDNCNT=0:0 S PSJDNCNT=$O(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,"DRUGS",PSJDNCNT)) Q:'PSJDNCNT  D
	.. S PSJNDV=$G(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,"DRUGS",PSJDNCNT))
	.. D SETOC
	I '$D(PSJPROSP) Q
	D DSPOC
	Q
DTDGCK	;This version of DT is only executed when the user selects hidden action CK (Drug Check)
	NEW PSJN1,PSJCLASS,PSJDNCNT,PSJNDV,PSJPROSP,PSJOCDT,PSJXX
	S PSJCLASS=""
	F PSJXX=1:1:2 D
	.F PSJN1=0:0 S PSJN1=$O(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1)) Q:'PSJN1  D
	..I PSJXX=1 I $P(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,"DRUGS",1),";",3)'="PROSPECTIVE" Q
	..I PSJXX=2 I $P(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,"DRUGS",1),";",3)'="PROFILE" Q
	..D SETCLASS
	..F PSJDNCNT=0:0 S PSJDNCNT=$O(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,"DRUGS",PSJDNCNT)) Q:'PSJDNCNT  D
	...S PSJNDV=$G(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,"DRUGS",PSJDNCNT))
	...D SETOC
	..D DSPOC K PSJOCDT,PSJPROSP S PSJCLASS=""
	Q
DSPOC	;
	;PSJDSPON(ON) - Is set after the order is displayed so the same order is not displayed again
	NEW PSJTYPE,PSJDNM,PSPON,PSJPONX,PSJX,PSJDSPON,PSJCLINF
	D HDR
	F PSJTYPE=0:0 S PSJTYPE=$O(PSJOCDT(PSJTYPE)) Q:'PSJTYPE  D
	. S PSJDNM="" F  S PSJDNM=$O(PSJOCDT(PSJTYPE,PSJDNM)) Q:PSJDNM=""  D
	.. S PSJPON="" F  S PSJPON=$O(PSJOCDT(PSJTYPE,PSJDNM,PSJPON)) Q:PSJPON=""  D
	... K PSJCLINF S PSJCLINF="" I $P(PSJPON,";",2)'="",PSJOCDT(PSJTYPE,PSJDNM,PSJPON)'=""  S PSJCLINF=PSJOCDT(PSJTYPE,PSJDNM,PSJPON),PSJCLINF(2)=PSJPON,PSJCLINF(3)=PSJDNM
	... I ($Y+6)>IOSL D PAUSE^PSJMISC(1,) W @IOF
	... S PSJPONX=$P(PSJPON,";",2)
	... I PSJTYPE=10,+PSJPONX D
	.... I '$D(PSJDSPON(PSJPONX)) D DSPORD^PSJOC(PSJPONX,,.PSJCLINF)
	.... S PSJDSPON(PSJPONX)=""
	... I ($Y+8)>IOSL D PAUSE^PSJMISC(1,) W @IOF
	... I PSJTYPE>10 D
	.... I PSJCLINF D CLNDISP^PSJCLNOC(.PSJCLINF) Q
	.... D EN^PSODRDU2(DFN,PSJPON,"PSJPRE")
	;Break the display text this way so the info on classes are indented correctly
	S PSJCLASS=" Involved in Therapeutic Duplication(s): "_PSJCLASS
	S PSJX=$L(PSJCLASS)\65 I ($Y+PSJX+4)>IOSL D PAUSE^PSJMISC(1,) W @IOF
	W !,"Class(es)"
	D MYWRITE^PSJMISC(PSJCLASS,3,67)
	I ($Y+8)>IOSL D PAUSE^PSJMISC(1,) W @IOF
	W !
	;D LINE^PSJMISC($S($G(PSJOLDN):PSJLINE,1:"="),81)
	D LINE^PSJMISC("=",81)
	I '$D(PSJOCDT(10)),$D(PSJOCDT) K PSJPAUSE D PAUSE^PSJLMUT1 W @IOF Q
	;I ($Y+8)>IOSL D PAUSE^PSJMISC(1,) W @IOF
	I $D(PSJDGCK) W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue..." D ^DIR K DIR Q
	I $D(PSJDGCK) Q
	D CONT
	Q:$G(PSGORQF)
	S PSJY=$$SORTLST()
	K PSJPAUSE
	I PSJY=1 D  Q
	. W !!
	. D:'$D(PSJDGCK) PROCLST(PSJY)
	I (PSJY>1),+$$DCPROMPT() D
	. W !
	. S PSJY=$$LST() W !
	. D:'$D(PSJDGCK) PROCLST(PSJY)
	Q
HDR	;
	NEW PSJHDR,PSJDNM
	I $D(^TMP($J,"PSJPRE","OUT","DRUGDRUG")) W @IOF
	D LINE^PSJMISC("=",81)
	S PSJHDR="This patient is already receiving the following INPATIENT and/or OUTPATIENT order(s) for a drug in the same therapeutic class(es)"
	S:$D(PSJDGCK) PSJHDR="This patient is already receiving the following INPATIENT and/or OUTPATIENT order(s) for drugs in the same therapeutic class(es)"
	S PSJDNM=$O(PSJPROSP("UD",""))
	I PSJDNM]"" S PSJHDR=PSJHDR_" as "_PSJDNM_":" D WRITE^PSJMISC(PSJHDR,1,77) Q
	D WRITE^PSJMISC(PSJHDR_":",1,77)
HDR2	;
	W !,"Drug(s) Ordered:"
	S PSJDNM="" F  S PSJDNM=$O(PSJPROSP("IV",PSJDNM)) Q:PSJDNM=""  D
	. W !,?3,PSJDNM
	. I ($Y+8)>IOSL D PAUSE^PSJMISC() W @IOF
	W !
	Q
SETCLASS	;Store all classes to display at the end.
	NEW PSJN2,PSJCLS
	F PSJN2=0:0 S PSJN2=$O(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,PSJN2)) Q:'PSJN2  D
	. S PSJCLS=$G(^TMP($J,"PSJPRE","OUT","THERAPY",PSJN1,PSJN2,"CLASS"))
	. S PSJCLASS=PSJCLASS_$S(PSJCLASS="":"",1:", ")_PSJCLS
	Q
SETOC	;Set PSJOCDT array to sort by Package(Inpt, Outpt: Active, Remote, Pending, Non-VA
	;PSJPROSP(UD/IV,drugname)="" - This is used to display the header
	;PSJOCDT(package,drugname,Pharm ord#)=""
	NEW PSJPON,PSJPKG,PSJTYPE,PSJDNM,PSJPONX,PSJCLINF,PSJDXOPT
	S PSJPON=$P(PSJNDV,U) Q:PSJPON=""
	S PSJCLINF="",PSJDXOPT=$S($G(PSJDGCK):"PROSPECTIVE",1:"PROFILE")
	I $P(PSJPON,";",3)'="PROSPECTIVE" S PSJCLINF=$P(^TMP($J,"PSJPRE","IN",PSJDXOPT,PSJPON),"^",7)
	S PSJPONX=$P(PSJPON,";",2)
	S PSJTYPE=$P(PSJPON,";") Q:PSJTYPE=""
	S PSJDNM=$P(PSJNDV,U,3) Q:PSJDNM=""
	S PSJPKG=$S(PSJTYPE["C":10,PSJTYPE="I":10,PSJTYPE="O":20,PSJTYPE="R":30,PSJTYPE="P":40,PSJTYPE="N":50,1:"")
	; Set prospective drug name array to display in the header.
	I PSJPKG=10,($P(PSJPON,";",3)="PROSPECTIVE") D  Q
	. I PSJPONX["V" S PSJPROSP("IV",PSJDNM)="" Q
	. I PSJPONX["P",+$G(PSJLIFNI) S PSJPROSP("IV",PSJDNM)="" Q
	. I PSJPONX["P",($P($G(^PS(53.1,+PSJPONX,8)),U)]"") S PSJPROSP("IV",PSJDNM)="" Q
	. S PSJPROSP("UD",PSJDNM)=""
	S PSJOCDT(PSJPKG,PSJDNM,PSJPON)=PSJCLINF
	Q
CONT	;Display the continue prompt.
	NEW DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y,X
	W !
	S DIR(0)="Y",DIR("B")="YES",DIR("A")=$S($D(PSJDGCK):"Do you wish to continue",1:"Do you wish to continue with the current order")
	S DIR("?",1)="Enter 'NO' if you wish to not continue with the order,",DIR("?")="or 'YES' to continue with the current order."
	D ^DIR
	I 'Y!($G(PSJDGCK)) S PSGORQF=1 S VALMBCK="R"
	Q
DCPROMPT()	;Prompt if user wants to DC order(s)
	NEW DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y,X
	W !
	S DIR(0)="Y",DIR("B")="NO",DIR("A")="Do you wish to DISCONTINUE any of the listed INPATIENT orders"
	S DIR("?",1)="Enter 'NO' if you don't wish to discontinue any of the order(s),",DIR("?")="or 'YES' to discontinue selected order(s)."
	D ^DIR
	Q Y
SORTLST()	;Sort orders into a numeric list
	NEW DIR,DIRUT,DTOUT,DUOUT,PSJN,PSJPON1,PSJMONV,PSJS,PSJSEV1,PSJX,X,Y,PSJDNM,PSJPONX,PSJDSPON,PSOCLINF
	;Sort orders into a numeric list
	Q:'$D(PSJOCDT(10)) 0
	S PSJN=0,PSJDNM=""
	F  S PSJDNM=$O(PSJOCDT(10,PSJDNM)) Q:PSJDNM=""  S PSJS="" F  S PSJS=$O(PSJOCDT(10,PSJDNM,PSJS)) Q:PSJS=""  D
	. S PSJPONX=$P(PSJS,";",2)
	. S PSJCLINF="",PSJCLINF=PSJOCDT(10,PSJDNM,PSJS)
	. ;Business Rule(s): don't show orders that have a status of DISCONTINUED in list
	. Q:$D(PSJDSPON(PSJPONX))
	. S PSJDSPON(PSJPONX)=""
	. S:'$$CKDC^PSJOCDT PSJN=PSJN+1,PSJOCDTL(PSJN)=PSJPONX
	Q PSJN
LST()	;
	;Only present the list if there are more than 1 orders the list
	F PSJX=0:0 S PSJX=$O(PSJOCDTL(PSJX)) Q:'PSJX  D
	. I ($Y+6)>IOSL D PAUSE^PSJMISC(1,) W @IOF
	. D DSPORD^PSJOC(PSJOCDTL(PSJX),PSJX_".  ")
	W !
	K DIR S DIR(0)="LO^1:"_$O(PSJOCDTL(""),-1),DIR("A")="Enter a list or range of numbers to discontinue" D ^DIR K DIR
	Q Y
PROCLST(PSJY)	;DC the orders selected by user
	NEW PSJX,PSJX1,PSJON,PSJCLINF
	F PSJX1=1:1:$L(PSJY) S PSJX=$P(PSJY,",",PSJX1) Q:PSJX=""  D
	. I ($Y+8)>IOSL D PAUSE^PSJMISC() W @IOF
	. I '$D(PSJOCDTL(PSJX)) Q
	. S PSJON=PSJOCDTL(PSJX),PSJCLINF=0
	. I $D(PSJOCDTL(PSJX,"CLN")) S PSJCLINF=$P(PSJOCDTL(PSJX,"CLN"),"^"),PSJCLINF(2)=$P(PSJOCDTL(PSJX,"CLN"),"^",2),PSJCLINF(3)=$P(PSJOCDTL(PSJX,"CLN"),"^",3)
	. D DC^PSJOCDC(PSGP,PSJON,.PSJCLINF)
	. W !
	Q
CKDC()	; rule: don't show orders that have a status of DISCONTINUED in list
	N PSJCKPON,PSJCKFLD
	S (PSJCKFLD,PSJCKPON)="",PSJCKPON=$S(PSJPONX["U":55.06,PSJPONX["I"!(PSJPONX["V"):55.01,1:53.1)
	S PSJCKFLD=$S(PSJPONX["V"!(PSJPONX="I"):"100",1:"28")  ;Unit dose and pending/non-verified file statuses are in field 28 in each file
	D GETS^DIQ(PSJCKPON,+PSJPONX_","_DFN,PSJCKFLD,"I","DCTMP")
	I '$D(DCTMP(PSJCKPON,+PSJPONX_","_DFN_",",PSJCKFLD,"I")) K DCTMP Q 0
	I DCTMP(PSJCKPON,+PSJPONX_","_DFN_",",PSJCKFLD,"I")="D" K DCTMP Q 1
	K DCTMP Q 0
