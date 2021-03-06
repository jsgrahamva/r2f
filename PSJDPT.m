PSJDPT	;BIR/JLC - CENTRALIZED PATIENT LOOKUP FOR IPM ; 7/2/08 3:47pm
	;;5.0;INPATIENT MEDICATIONS;**53,124,166,160,198,267,275**;16 DEC 97;Build 157
	;
	; Reference to ^DPT is supported by DBIA 10035
	; Reference to ^DGSEC4 is supported by DBIA 3027
	; Reference to ^DIC is supported by DBIA 10006
	; Reference to ^DICN is supported by DBIA 10009
	; Reference to ^DPTLK is supported by DBIA 3787
	; Reference to ^DPTLK1 is supported by DBIA 3266
	; Reference to DISPPRF^DGPFAPI is supported by DBIA 4563
	; Reference to GETACT^DGPFAPI is supported by DBIA 3860
	; Reference to ^ORRDI1 is supported by DBIA 4659.
	; Reference to ^XTMP("ORRDI" is supported by DBIA 4660.
	;
EN	; MAIN ENTRY POINT FOR PATIENT LOOKUP
	K DIC S DIC="^DPT(",DIC("W")="D DPT^PSJDPT",DIC(0)="QEMZ" D ^DPTLK K DIC
	I $$BADADR^DGUTL3(+Y) H 2
	N Y
	D
	. ;PSJ*5.0*198;GMZ;Don't print remote data msg on view profile only menu options
	. I $T(HAVEHDR^ORRDI1)]"",$$HAVEHDR^ORRDI1,$D(^XTMP("ORRDI","OUTAGE INFO","DOWN")),'$G(PSJNODIS) W !,"Remote data not available - Only local order checks processed." D PAUSE^PSJLMUT1
	Q
CHK(Y,DISP,PAUSE)	N RESULT,RES,CHKY,PSGTEMP
	S DISP=$G(DISP),PAUSE=$G(PAUSE)
	I $G(XQY0)["PSJI COMPLETE",$$GETACT^DGPFAPI(+Y,"PSGTEMP") K PSGTEMP W @IOF,"PATIENT: ",$P(Y,U,2)
	S CHKY=Y D DISPPRF^DGPFAPI(Y) S Y=CHKY K CHKY
	D PTSEC^DGSEC4(.RESULT,$P(Y,"^"),1)
	I RESULT(1)'=0 D
	. W !! I DISP W ?(80-$L($P(Y,"^",2)))\2,$P(Y,"^",2),!
	. F I=2:1:9 I $D(RESULT(I)) W ?(80-$L(RESULT(I)))\2,RESULT(I),!
	. I RESULT(1)'=0,RESULT(1)'=2,PAUSE H 2
	. Q:RESULT(1)=1
	. I RESULT(1)=-1!(RESULT(1)=3)!(RESULT(1)=4) S Y=-1 Q
	. I RESULT(1)=2 D ENCONT I Y=-1 Q
	. D NOTICE^DGSEC4(.RES,Y,XQY0,$S(RESULT(1)=1:1,1:3)) I RES=0 S Y=-1 Q
	I '$$AA(+Y) S Y=-1 Q
	Q
ENCONT	W !,"Do you want to continue processing this patient record"
	S %=2 D YN^DICN I %<0!(%=2) S Y=-1
	I '% W !!,"Enter 'YES' to continue processing, or 'NO' to quit processing this record." G ENCONT
	Q
DPT	I $$DOB^DPTLK1(Y)["*SENSITIVE" G SENS
	S ND=$S($D(^DPT(Y,0)):^(0),1:""),NB=$P(ND,"^",3),NS=$P(ND,"^",9)
	I NS W ?42,$E(NS,1,3),"-",$E(NS,4,5),"-",$E(NS,6,10)," "
	I NB W ?55,$E(NB,4,5),"/",$E(NB,6,7),"/",$E(NB,2,3)," "
	I $D(^DPT(Y,.1)) W ?67,$P(^(.1),"^")
	Q
SENS	W ?42,"*SENSITIVE* ",?55,"*SENSITIVE* ",?67,"*SENSITIVE*" Q
	;
AA(DFN)	; Allergy Assessment
	Q:$G(DFN)<1 0
	N VAN,VAV,VADM,Y,X D DEM^VADPT
	Q:+$G(VADM(6)) 1
	N PSJENTRY S PSJENTRY=$P($G(XQY0),"^") I '(("^PSJU NE^PSJI ORDER^PSJ OE^PSJU VBW^PSJI PROFILE^")[("^"_PSJENTRY_"^")) Q 1
	N PSGP,Y S (Y,PSGP)=+DFN N DFN S DFN=PSGP
	I $G(DFN) N PSJAAOK,PSJAACHK,PSJAADPT,PSJRXREQ,GMRA,GMRAL S PSJAADPT=1,PSJAAOK="" D
	.S GMRA="0^0^111",DFN=PSGP D ^GMRADPT I $G(GMRAL)="" S PSJAACHK=1 F  Q:$G(PSJAAOK)  D
	..D CLEAR^VALM1,FULL^VALM1
	..W !!,"NO ALLERGY ASSESSMENT exists for " W $P($G(^DPT(+PSGP,0)),"^"),!!,"Would you like to enter one now" S %=2 D YN^DICN
	..I $G(%)=2 S PSJAAOK=1 D  Q
	...W !!,"Now creating Pharmacy Intervention",!
	...S PSJRXREQ="NO ALLERGY ASSESSMENT",PSJDD="" D DIC^PSJRXI
	..I $G(%)=1 S VALMBCK="R" D INIT^PSJLMDA I $G(DFN) D NEWALL^PSJLMUTL(DFN) D  Q
	...S GMRA="0^0^111" D ^GMRADPT I $G(GMRAL)'="" S PSJAAOK=1
	..I $G(%)<0 S PSJAAOK=1 S Y="" Q
	..W !!?5,"Enter 'Y' to create an allergy assessment, or 'N'",!?5,"to continue without creating an allergy assessment"
	Q $S($G(Y)>0:Y,1:0)
