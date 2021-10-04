PSGPER1	;BIR/CML3-PRINTS PRE-EXCHANGE NEEDS REPORT ;18 MAR 03 / 5:08 PM
	;;5.0;INPATIENT MEDICATIONS;**80,127,279**;16 DEC 97;Build 150
	;
EN	; Entry point
	S PSGPERRF=0,POP=0 N PSGPRCLD,PSGCURCL S PSGPRCLD="" D DEFCL(PSGPXN,.PSGPRCLD)
	N PSGPRTYP,PSGPRCL
	I $G(PSGPRCLD("WARD")) S PSGPRTYP="PSGPERP" D DEV K PSGPRCLD("WARD")
	I POP D POP G:%=1 EN G DONE
	I $D(PSGPRCLD)>1 S PSGPRTYP="PSGPERPC" S PSGCURCL="" F  S PSGCURCL=$O(PSGPRCLD("DEV",PSGCURCL)) Q:PSGCURCL=""  D DEV
	D DONE
	Q
DEV	; Select Device
	S PSGION=ION
	D DEV1
	Q
DEV0	; Validate Device
	S PSGION=ION
DEV1	; Device validation loop
	W !!,"PRE-EXCHANGE UNITS REPORT"
	K IOP,%ZIS,IO("Q") S %ZIS="Q",%ZIS("A")="Select DEVICE for "_$S($G(PSGPRCLD("WARD")):"Ward "_$G(^DPT(DFN,.1)),$G(PSGCURCL)]"":"Clinic "_PSGCURCL,1:"")_": ",%ZIS("B")=$S(($G(PSGCURCL)]""):$G(PSGPRCLD("DEV",PSGCURCL)),1:"")
	D ^%ZIS K %ZIS
	I POP D POP G:%=1 DEV1
	I $D(IO("Q")) K ZTSAVE S PSGTIR="^PSGPER2",ZTDESC="PRE-EXCHANGE UNITS REPORT",ZTDTH=$H,ZTSAVE("PSGPXN")="",ZTSAVE("DFN")="",ZTSAVE("PSGPRTYP")="",ZTSAVE("PSGCURCL")="" D ENTSK^PSGTI G:'$D(ZTSK) DEV0 K ZTSK
	D ENP^PSGPER2,AG I %=1 S PSGPERRF=1 G DEV0
	Q
	;
DONE	;
OUT	;
	D TASKPRGE^PSGPER1(PSGPXN) ;
	K PSGPERRF,PSGPXN
	Q:$G(PSJCOM)!$G(PSJPREX)
	D ENIVKV^PSGSETU,ENCV^PSGSETU
	Q
	;
POP	;
	S %=2 W:'PSGPERRF !!,"IF A DEVICE IS NOT CHOSEN, NO REPORT WILL BE RUN AND THE DATA WILL NO LONGER BE RETRIEVABLE THROUGH THIS REPORT."
	I 'PSGPERRF F  W !,"Do you want another chance to choose a device" S %=1 D YN^DICN Q:%  W !?3,"Enter 'YES' to choose a device to print.  Enter 'NO' to quit now."
	I %'=1 S IOP=PSGION D ^%ZIS S %=2
	Q
	;
AG	;
	F  W !!,"DO YOU NEED TO PRINT THIS REPORT AGAIN" S %=0 D YN^DICN Q:%  D AGMSG
	Q
	;
AGMSG	;
	I %Y'?1."?" W $C(7),"  ANSWER 'YES' OR 'NO' (Entry required)" Q
	W !,"  Enter 'YES' to print this report again.  Enter 'NO' (or an '^') to quit",!,"now.  PLEASE NOTE that you will NOT be able to retrieve this data at a later",!,"date.  You should print this information now." Q
	;
DEFON()	; All Pre-Exchange Devices have been removed from Ward Parameters - restore previous functionality
	N ON,W S ON=0,W=0 F  S W=$O(^PS(59.6,W)) Q:'W!ON  I $P(^(W,0),U,29)]"" S ON=1
	I $G(PSJPXDOF) S ON=0 K PSJPXDOF
	Q ON
	;
DEFCL(PSGPXN,CLINICS)	; Default devices for Clinics
	K CLINICS N CLINIC,CLINM,CLINX,CLINDEV
	N CLINAM,DFN S DFN=0 F  S DFN=$O(^PS(53.4,PSGPXN,1,DFN)) Q:'DFN  S ON=0 F  S ON=$O(^PS(53.4,PSGPXN,1,DFN,1,ON)) Q:'ON  D
	.S CLINIC=$$CLINIC^PSJO1(DFN,+ON_"U")
	.I CLINIC]"" N CLINUM,DIC,X,Y S DIC="^SC(",DIC(0)="NSUXZ",X=CLINIC D ^DIC I $G(Y)>0 S CLINUM=+Y D
	..S CLINAM=CLINIC N LCLCL S LCLCL=$P($G(PSJSYSW0("CLINIC",+CLINUM,1)),"^")
	..I $G(PSJSYSW0("CLINIC",+CLINUM,0)) S CLINICS("DEV",CLINAM)=$$GET1^DIQ(3.5,+LCLCL,".01"),CLINICS("DEVX",+CLINIC)=CLINAM
	.I CLINIC="" S CLINICS("WARD")=1
	Q
TASKPRGE(PXN)	; Task purge of entry from file 53.4
	K ZTIO,ZTDTH,ZTSK S ZTIO="",ZTRTN="PURGE^PSGPER1",ZTDESC="PURGE PRE-EXCHANGE NEEDS" S ZTSAVE("PXN")="" S ZTDTH=$$HADD^XLFDT($H,1,0,0,0)
	D ^%ZTLOAD
	K %ZIS,IOP,PSGTID,PSGTIR,ZTDESC,ZTDTH,ZTRTN,ZTDESC,ZTSAVE
	Q
PURGE	; Purge entry from file 53.4
	Q:'$G(PXN)
	N PSGPXINF,PSGNOWFM S PSGPXINF=$G(^PS(53.4,+$G(PXN),0)),PSGPXINF=$P($P(PSGPXINF,"^",2),".") Q:'$G(PSGPXINF)
	S PSGNOWFM=$P($$NOW^XLFDT,".") Q:'(PSGNOWFM>PSGPXINF)
	S DIK="^PS(53.4,",DA=PXN D ^DIK
	Q
