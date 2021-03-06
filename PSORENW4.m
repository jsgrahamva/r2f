PSORENW4	;BIR/SAB - rx speed renew ;03/06/95
	;;7.0;OUTPATIENT PHARMACY;**11,23,27,32,37,64,46,75,71,100,130,117,152,148,264,225,301,390,313**;DEC 1997;Build 76
	;External reference to ^PSDRUG supported by DBIA 221
	;External reference to ^PS(50.7 supported by DBIA 2223
	;External references L, UL, PSOL, and PSOUL^PSSLOCK supported by DBIA 2789
	;External reference to LK^ORX2 and ULK^ORX2 supported by DBIA 867
SEL	K PSODRUG ;PSO*7*301
	I $P(PSOPAR,"^",4)=0 S VALMSG="Renewing is NOT Allowed. Check Site Parameters!",VALMBCK="" Q
	N VALMCNT I '$G(PSOCNT) S VALMSG="This patient has no Prescriptions!",VALMBCK="" Q
	S PSOPLCK=$$L^PSSLOCK(PSODFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY S VALMSG=$S($P($G(PSOPLCK),"^",2)'="":$P($G(PSOPLCK),"^",2)_" is working on this patient.",1:"Another person is entering orders for this patient.") K PSOPLCK S VALMBCK="" Q
	K PSOPLCK S X=PSODFN_";DPT(" D LK^ORX2 I 'Y S VALMSG="Another person is entering orders for this patient.",VALMBCK="" D UL^PSSLOCK(PSODFN) Q
	K PRC,PHI,PSORX("EDIT"),PSOFDR,DIR,DUOUT,DIRUT,PSORNSPD S DIR("A")="Select Orders by number",DIR(0)="LO^1:"_PSOCNT D ^DIR I $D(DTOUT)!($D(DUOUT)) K DIR,DIRUT,DTOUT,DUOUT S VALMBCK="" G SELQ
	K DIR,DIRUT,DTOUT,PSOOELSE,DTOUT I +Y S (SPEED,PSOOELSE,PSORNSPD)=1 D FULL^VALM1 S LST=Y D
	.S (PSODIR("DFLG"),PSODIR("FIELD"))=0,PSOOPT=3,(PSORENW("DFLG"),PSORENW("QFLG"),PSORX("DFLG"))=0 D INIT Q:PSORENW("DFLG")
	.F ORD=1:1:$L(LST,",") Q:$P(LST,",",ORD)']""  S ORN=$P(LST,",",ORD) D:+PSOLST(ORN)=52 PROCESS S PSORENW("DFLG")=0
	I '$G(PSOOELSE) S VALMBCK="" G SELQ
	S VALMBCK="R"
	D ^PSOBUILD,BLD^PSOORUT1 K DIR,DIRUT,DTOUT,DUOUT,LST,ORD,IEN,ORN,RPH,ST,REFL,REF,PSOACT,ORSV,PSORNW,PSORENW,PSONO,PSOCO,PSOCU,PSODIR,DSMSG,SPEED,PSORENW,PSOOELSE,PSOOPT,PSORX("FILL DATE"),PSORX("ISSUE DATE"),PSOID,PSOMSG,PSORX("DFLG"),PSOQTY
SELQ	K PSORNSPD,RTE,DRET,PRC,PHI S X=PSODFN_";DPT(" D ULK^ORX2,UL^PSSLOCK(PSODFN),CLEAN^PSOVER1
	Q
	;
PROCESS	; Process one order at a time
	W !!,"Now Renewing Rx # "_$$GET1^DIQ(52,$P(PSOLST(ORN),"^",2),.01)_"   Drug: "_$$GET1^DIQ(52,$P(PSOLST(ORN),"^",2),6),!
	I $$LMREJ^PSOREJU1($P(PSOLST(ORN),"^",2)) D  K DIR,PSOMSG D PAUSE^VALM1 Q
	. W $C(7),!,"Rx "_$$GET1^DIQ(52,$P(PSOLST(ORN),"^",2),.01)_" has OPEN/UNRESOLVED 3rd Party Payer Rejects!"
	I $$TITRX^PSOUTL($P(PSOLST(ORN),"^",2))="t" D  K DIR,PSOMSG D PAUSE^VALM1 Q
	. W $C(7),!,"Rx# "_$$GET1^DIQ(52,$P(PSOLST(ORN),"^",2),.01)_" is marked as 'Titration Rx' and cannot be renewed."
	D PSOL^PSSLOCK($P(PSOLST(ORN),"^",2)) I '$G(PSOMSG) W $C(7),!!,$S($P($G(PSOMSG),"^",2)'="":$P($G(PSOMSG),"^",2),1:"Another person is editing Rx "_$P(^PSRX($P(PSOLST(ORN),"^",2),0),"^")),! K DIR,PSOMSG D PAUSE^VALM1 Q
	K RET,DRET,PRC,PHI S PSORENW("OIRXN")=$P(PSOLST(ORN),"^",2),PSOFROM="NEW"
	S PSORENW("RX0")=^PSRX(PSORENW("OIRXN"),0),PSORENW("RX2")=^(2),PSORENW("RX3")=^(3),PSORENW("STA")=^("STA"),PSORENW("TN")=$G(^("TN")),SIGOK=$P($G(^PSRX(PSORENW("OIRXN"),"SIG")),"^",2)
	I SIGOK F I=0:0 S I=$O(^PSRX(PSORENW("OIRXN"),"SIG1",I)) Q:'I  S SIG(I)=^PSRX(PSORENW("OIRXN"),"SIG1",I,0)
	S PSOIBOLD=$G(PSORENW("OIRXN")) D SETIB^PSORENW1
	I '$G(PSORENW("PROVIDER")) D
	.S PSORENW("PROVIDER")=$P(PSORENW("RX0"),"^",4)
	.S:$P(PSORENW("RX3"),"^",3) PSORENW("COSIGNING PROVIDER")=$P(PSORENW("RX3"),"^",3)
	S PSORX("PROVIDER NAME")=$P($G(^VA(200,PSORENW("PROVIDER"),0)),"^")
	I '$G(PSORENW("CLINIC")) S PSORENW("CLINIC")=$P(PSORENW("RX0"),"^",5)
	S PSORENW("REMARKS")="RENEWED FROM RX # "_$P(PSORENW("RX0"),"^")
	S PSORENW("SIG")=$P($G(^PSRX(PSORENW("OIRXN"),"SIG")),"^")
	S PSORENW("PSODFN")=$P(PSORENW("RX0"),"^",2)
	S PSORENW("ORX #")=$P(PSORENW("RX0"),"^")
	S PSORENW("DRUG IEN")=$P(PSORENW("RX0"),"^",6)
	S PSORENW("QTY")=$P(PSORENW("RX0"),"^",7)
	;S PSORENW("DAYS SUPPLY")=$P(PSORENW("RX0"),"^",8)
	;S PSORENW("# OF REFILLS")=$P(PSORENW("RX0"),"^",9)
	S PSORENW("INS")=$S($G(PSORENW("ENT"))]"":PSORENW("ENT"),1:$G(^PSRX(PSORENW("OIRXN"),"INS")))
	S:$G(PSORENW("ENT"))']"" PSORENW("ENT")=0
	F I=0:0 S I=$O(^PSRX(PSORENW("OIRXN"),6,I)) Q:'I  S DOSE=^PSRX(PSORENW("OIRXN"),6,I,0) D
	.S PSORENW("ENT")=PSORENW("ENT")+1,PSORENW("DOSE",PSORENW("ENT"))=$P(DOSE,"^")
	.S PSORENW("UNITS",PSORENW("ENT"))=$P(DOSE,"^",3),PSORENW("DOSE ORDERED",PSORENW("ENT"))=$P(DOSE,"^",2),PSORENW("ROUTE",PSORENW("ENT"))=$P(DOSE,"^",7)
	.S PSORENW("SCHEDULE",PSORENW("ENT"))=$P(DOSE,"^",8),PSORENW("DURATION",PSORENW("ENT"))=$P(DOSE,"^",5),PSORENW("CONJUNCTION",PSORENW("ENT"))=$P(DOSE,"^",6)
	.S PSORENW("NOUN",PSORENW("ENT"))=$P(DOSE,"^",4),PSORENW("VERB",PSORENW("ENT"))=$P(DOSE,"^",9)
	.I $G(^PSRX(PSORENW("OIRXN"),6,I,1))]"" S PSORENW("ODOSE",PSORENW("ENT"))=^PSRX(PSORENW("OIRXN"),6,I,1)
	.K DOSE
	I $P($G(^PSDRUG(PSORENW("DRUG IEN"),"CLOZ1")),"^")="PSOCLO1" N PSON S PSON=0 D  I PSON K PSON D POZ,KLIB^PSORENW1 D PSOUL^PSSLOCK($P(PSOLST(ORN),"^",2)) Q
	. I '$L($P(^VA(200,PSORENW("PROVIDER"),"PS"),"^",2)),'$L($P(^VA(200,PSORENW("PROVIDER"),"PS"),"^",3)) D  Q
	. . S PSON=1 W $C(7),!!,"Only providers with DEA# or a VA# can write prescriptions for clozapine.",!
	. I '$D(^XUSEC("YSCL AUTHORIZED",PSORENW("PROVIDER"))) D 
	. . S PSON=1 W $C(7),!!,"Provider must hold YSCL AUTHORIZED key to write prescriptions for clozapine.",!
	I $G(PSORNW("MAIL/WINDOW"))]"" S PSORENW("MAIL/WINDOW")=PSORNW("MAIL/WINDOW")
	I $O(^PSRX(PSORENW("OIRXN"),"PI",0)) D  K T
	.S PHI=^PSRX(PSORENW("OIRXN"),"PI",0),T=0
	.F  S T=$O(^PSRX(PSORENW("OIRXN"),"PI",T)) Q:'T  S PHI(T)=^PSRX(PSORENW("OIRXN"),"PI",T,0)
	;I $O(^PSRX(PSORENW("OIRXN"),"PRC",0)) D  K T
	;.S PRC=^PSRX(PSORENW("OIRXN"),"PRC",0),T=0
	;.F  S T=$O(^PSRX(PSORENW("OIRXN"),"PRC",T)) Q:'T  S PRC(T)=^PSRX(PSORENW("OIRXN"),"PRC",T,0)
	W !!,"Now Renewing Rx # "_PSORENW("ORX #")_"   Drug: "_$P($G(^PSDRUG(+$G(PSORENW("DRUG IEN")),0)),"^"),!
	I '$P($G(^PSDRUG($P(PSORENW("RX0"),"^",6),2)),"^") D  G:$G(PSORENW("DFLG")) PROCESSX
	.I $P($G(^PSRX(PSORENW("OIRXN"),"OR1")),"^") S PSODRUG("OI")=$P(^PSRX(PSORENW("OIRXN"),"OR1"),"^"),PSODRUG("OIN")=$P(^PS(50.7,+^("OR1"),0),"^") Q
	.W !!,"Cannot Renew!!  No Pharmacy Orderable Item!" S VALMSG="Cannot Renew!!  No Pharmacy Orderable Item!",PSORX("DFLG")=1
	D CHECK^PSORENW0 G:PSORENW("DFLG") PROCESSX
	D FILDATE^PSORENW0
	D DRUG^PSORENW0 G:PSORENW("DFLG") PROCESSX
	D RXN^PSORENW0 G:PSORENW("DFLG") PROCESSX
	D STOP^PSORENW1
DSPL	K PSOEDT,PSOLM S PSDY=PSORENW("DAYS SUPPLY"),PSRF=PSORENW("# OF REFILLS")
	F DEA=1:1 Q:$E(PSODRUG("DEA"),DEA)=""  I $E(+PSODRUG("DEA"),DEA)>1,$E(+PSODRUG("DEA"),DEA)<6 S PSODIR("CS")=1
	I $G(PSODIR("CS")) D
	.S PSORENW("# OF REFILLS")=$S(PSDY<60:5,PSDY'<60&(PSDY'>89):2,PSDY=90:1,1:0)
	.I PSORENW("# OF REFILLS")>PSRF S PSORENW("# OF REFILLS")=PSRF
	D DSPLY^PSORENW3 G:PSORENW("DFLG") PROCESSX
	D:$D(^XUSEC("PSORPH",DUZ))!('$P(PSOPAR,"^",2)) VER1^PSOORNE4(.PSORENW) G:PSORENW("DFLG")=1 PROCESSX
	I $G(PSOQTY) D QTY^PSODIR1(.PSORENW) G:PSORENW("DFLG")=1 PROCESSX
	D EN^PSORN52(.PSORENW)
	D RNPSOSD^PSOUTIL
	D CAN^PSORENW0,DCORD^PSONEW2
	S PSORENW("# OF REFILLS")=PSRF K PSDY,PSRF,PSODIR("CS"),DEA,PSORENW("ENT")
	S BBRN="",BBRN1=$O(^PSRX("B",PSORENW("NRX #"),BBRN)) I $P($G(^PSRX(BBRN1,0)),"^",11)["W" S BINGCRT="Y",BINGRTE="W",BBFLG=1,BBRX(1)=$G(BBRX(1))_BBRN1_","
PROCESSX	I PSORENW("DFLG") D  W:'$G(POERR) !,$C(7),"Rx NOT RENEWED. RENEWED RX DELETED",! S POERR("DFLG")=1 D CLEAN^PSOVER1
	.K PHI,PRC,PSODRUG,SIG,PSORXED,SIGOK
	.K PSORENW("DOSE"),PSORENW("DURATION"),PSORENW("DRUG IEN"),PSORENW("ENT"),PSORENW("INS"),PSORENW("NOUN"),PSORENW("ROUTE"),PSORENW("SCHEDULE"),PSORENW("SIG"),PSORENW("VERB"),PSORENW("UNITS")
	.D POZ
	K PSORDLOK I PSORENW("DFLG") S PSORDLOK=1
	D:$G(PSORENW("OLD FILL DATE"))]"" SUSDATEK^PSOUTIL(.PSORENW)
	K BBRN,BBRN1,PSODRUG,PSORX("PROVIDER NAME"),PSORX("CLINIC")
	K PSOEDT,PSOLM S:$G(PSORENW("FROM"))="" (PSORENW("DFLG"),PSORENW("QFLG"))=0
	I $G(PSORDLOK) D PSOUL^PSSLOCK($P(PSOLST(ORN),"^",2))
	D KLIB^PSORENW1
	K PSORDLOK
	S RXN=$O(^TMP("PSORXN",$J,0)) I RXN N ZRXN S ZRXN=RXN D
	.S RXN1=^TMP("PSORXN",$J,RXN) D EN^PSOHLSN1(RXN,$P(RXN1,"^"),$P(RXN1,"^",2),"",$P(RXN1,"^",3))
	.I $P(^PSRX(RXN,"STA"),"^")=5 D EN^PSOHLSN1(RXN,"SC","ZS",$P(RXN1,"^",4))
	.;saves drug allergy order chks pso*7*390
	.I +$G(^TMP("PSODAOC",$J,1,0)) D
	.I $G(PSORX("DFLG"))!$G(PSORENW("DFLG")) K ^TMP("PSODAOC",$J) Q
	.S RXN=ZRXN,PSODAOC="Rx Backdoor "_$S($P(^PSRX(RXN,"STA"),"^")=4:"NON-VERIFIED ",1:"")_"SPEED RENEW Order Acceptance_OP"
	.D DAOC^PSONEW
	K ZRXN,RXN,RXN1,^TMP("PSORXN",$J),^TMP("PSODAOC",$J)
	Q
INIT	;
	D ASK Q:PSORENW("DFLG")
	D NOORE^PSONEW(.PSORENW) Q:PSORENW("DFLG")
	Q
ASK	;upfront questions
	W !! D ISSDT^PSODIR2(.PSORENW) Q:PSORENW("DFLG")  S PSORENW("ISSUE DATE")=PSOID
	D FILLDT^PSODIR2(.PSORENW) K PSONEW("DAYS SUPPLY"),PSONEW("# OF REFILLS") Q:PSORENW("DFLG")
	S PSORNW("FILL DATE")=PSORENW("FILL DATE")
	D MW^PSODIR2(.PSORENW) Q:PSORENW("DFLG")
	D PTSTAT^PSODIR1(.PSORENW) Q:PSORENW("DFLG")
	D DAYS^PSODIR1(.PSORENW) Q:PSORENW("DFLG")
	S PSODRUG("DEA")=0 D REFILL^PSODIR1(.PSORENW) K PSODRUG("DEA") Q:PSORENW("DFLG")
	K DIR,DIRUT S DIR(0)="Y",DIR("B")="No",DIR("A")="Do you want to edit Renewed Rx(s) QTY " D ^DIR I $D(DIRUT) S PSORENW("DFLG")=1 K DIR,DIRUT Q
	S PSOQTY=Y K DIR,DIRUT
	D CLINIC^PSODIR2(.PSORENW) Q:PSORENW("DFLG")
	D PROV^PSODIR(.PSORENW) S:PSORENW("DFLG") PSORENW("DFLG")=0
	Q
	;
POZ	;
	K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR,DIRUT,DTOUT
	Q
