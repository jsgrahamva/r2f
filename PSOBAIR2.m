PSOBAIR2	;BIR/RTR-Report of suspended prescriptions with bad address ;08/16/2006
	;;7.0;OUTPATIENT PHARMACY;**233,200,264,362**;DEC 1997;Build 8
	;External reference ^PS(55 supported by DBIA 2228
EN	;
	N PSOAPAT,PSOSDT,PSOEDT,PSOSDTX,PSOEDTX,X,Y,X1,X2,PSUSDIV,PII,PSOCNT,PSOBDF
	W !!,"This option shows unprinted suspended prescriptions for the following:",!
	W !,"- BAD ADDRESS INDICATOR set in the PATIENT file (#2) and no active temporary",!,"  address"
	W !,"- DO NOT MAIL set in the PHARMACY PATIENT file (#55)"
	W !,"- FOREIGN ADDRESS set in the PATIENT file (#2) and no active US temporary",!,"  address",!
	K DIR S DIR(0)="S^B:Bad Address Indicator;D:Do Not Mail;F:Foreign;A:All;",DIR("B")="A"
	S DIR("A")="Print for Bad Address Indicator/Do Not Mail/Foreign/All (B/D/F/A)"
	S DIR("?")="Print prescriptions with Bad Address Indicated/Do Not Mail/Foreign Address, or all"
	D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) D MESS Q
	S PSOBDF=Y
DATE	;
	W ! S %DT="AEX",%DT("A")="Ending suspense date: " D ^%DT K %DT I Y<0!($D(DTOUT))!($D(DUOUT)) D MESS Q
	S PSOEDT=Y D DD^%DT S PSOEDTX=Y
	S X1=PSOEDT,X2=+1 D C^%DTC S PSOEDT=X
	D:'$D(PSOPAR) ^PSOLSET I '$D(PSOPAR) D MESS Q
	S PSOCNT=0 F PII=0:0 S PII=$O(^PS(59,PII)) Q:'PII  S PSOCNT=PSOCNT+1
	I PSOCNT=1 G SKIP
	W !!?3,"You are logged in under the "_$P($G(^PS(59,+$G(PSOSITE),0)),"^")_" division.",!
	K DIR S DIR(0)="Y",DIR("B")="Yes",DIR("A")="Print only those Rx's suspended for this division",DIR("?")="Enter 'Yes' to print only those Rx's for this division, enter 'No' to print Rx's suspended for all divisions."
	D ^DIR K DIR I Y["^"!($D(DIRUT)) D MESS Q
	S PSUSDIV=Y
SKIP	;
	K IOP,%ZIS,POP S %ZIS="QM" D ^%ZIS I $G(POP) D MESS Q
	I $D(IO("Q")) D  Q
	.N GG
	.S ZTRTN="REP^PSOBAIR2",ZTDESC="Pharmacy bad address suspense report" D
	..F GG="PSOSITE","PSOAPAT","PSOSDT","PSOEDT","PSOEDTX","PSOSDTX","PSUSDIV" S:$D(@GG) ZTSAVE(GG)=""
	..S ZTSAVE("PSOBDF*")="" D ^%ZTLOAD K %ZIS
	.W !!,"Report queued to print.",!
REP	;
	K ^TMP("PSOBADL",$J) S (PSOBDF("B"),PSOBDF("D"),PSOBDF("F"))=0
	N PSODEV,PSOUT,PSOLINE,PSOPAGE,PSOADND,PSOADF,PSOADFF,PSOAOPT,PSOAOPTA,PSOAOPTZ,PSOAOPTB,PSOAOPTC,PSOADLP,PSOANODE,PSOADX,SFN,PSOADATE,PSOC,PSOAALL,PSODFN,PSOANAME,PSONI,PSONX,PSONB,PSOASN,VA,DFN,PSONSSN,PSOAFLAG
	U IO
	S (PSOUT,PSOAFLAG)=0,PSODEV=$S($E(IOST,1,2)'="C-":0,1:1),PSOPAGE=1
	S $P(PSOLINE,"-",78)=""
ALL	;
	N PSORD,SFN,PSOLBL,PSOX,PSODFN,RXIEN,PRINTED,RXSITE,RXSTS,PARTIAL
	S PSODFN=0 F  S PSODFN=$O(^PS(52.5,"AC",PSODFN)) Q:'PSODFN  D
	.S (PSOBAI,PSOBDF("B"),PSOBDF("D"),PSOBDF("F"))=0 D CHKADDR,FOREIGN,CHKMAIL Q:(PSOBDF("B")+PSOBDF("D")+PSOBDF("F"))=0
	.Q:(PSOBDF="A"&'(PSOBDF("B")!PSOBDF("F")!PSOBDF("D")))  I PSOBDF'="A" Q:('PSOBDF(PSOBDF))
	.S PSORD=0 F  S PSORD=$O(^PS(52.5,"AC",PSODFN,PSORD)) Q:'PSORD!(PSORD>PSOEDT)  D
	..S SFN=0 F  S SFN=$O(^PS(52.5,"AC",PSODFN,PSORD,SFN)) Q:'SFN  D DETAIL
	S PSODFN=0 F  S PSODFN=$O(^PS(52.5,"AG",PSODFN)) Q:'PSODFN  D
	.S (PSOBAI,PSOBDF("B"),PSOBDF("D"),PSOBDF("F"))=0 D CHKADDR,FOREIGN,CHKMAIL Q:(PSOBDF("B")+PSOBDF("D")+PSOBDF("F"))=0
	.Q:(PSOBDF="A"&'(PSOBDF("B")!PSOBDF("F")!PSOBDF("D")))  I PSOBDF'="A" Q:('PSOBDF(PSOBDF))
	.S SFN=0 F  S SFN=$O(^PS(52.5,"AG",PSODFN,SFN)) Q:'SFN  D
	..S PSORD=$G(^PS(52.5,SFN,0)),PSORD=$P(PSORD,"^",2) I PSORD<PSOEDT D DETAIL
	D HD
	I '$D(^TMP("PSOBADL",$J)) W !!,"No data found to print for this date range.",! G END
	S PSONI="" F  S PSONI=$O(^TMP("PSOBADL",$J,PSONI)) Q:PSONI=""!(PSOUT)  D
	.S PSONX="" F  S PSONX=$O(^TMP("PSOBADL",$J,PSONI,PSONX)) Q:PSONX=""!(PSOUT)  D NAME,PRALL D
	..S PSONB="" F  S PSONB=$O(^TMP("PSOBADL",$J,PSONI,PSONX,PSONB)) Q:PSONB=""!(PSOUT)  D
	...S SFN="" F  S SFN=$O(^TMP("PSOBADL",$J,PSONI,PSONX,PSONB,SFN)) Q:SFN=""!(PSOUT)  D
	....I ($Y+5)>IOSL D HD Q:PSOUT
	....S Y=PSONB D DD^%DT S PSOADATE=Y
	....S PNODE=$G(^TMP("PSOBADL",$J,PSONI,PSONX,PSONB,SFN)) D PRONE
END	;
	I PSOBDF="A" W !!!,"NOTE: B=BAD ADDRESS INDICATOR  D=NO NOT MAIL  F=FOREIGN ADDRESS"
	K ^TMP("PSOBADL",$J)
	K DTOUT,DUOUT,PSOBAI
	I '$G(PSOUT),PSODEV W !!,"End of Report." K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
	I 'PSODEV W !!,"End of Report."
	I PSODEV W !
	E  W @IOF
	D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
	Q
HD	;
	S PSOAFLAG=1
	I PSODEV,PSOPAGE'=1 W ! K DIR S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y S PSOUT=1 Q
	I PSOPAGE=1,'PSODEV W ! I 1
	E  W @IOF
	D  W ?67,"PAGE: "_PSOPAGE S PSOPAGE=PSOPAGE+1
	.W !,"Suspense "_$S(PSOBDF="A":"BAI/DO NOT MAIL/FOREIGN ADRESS",PSOBDF="B":"BAD ADDRESS INDICATOR",PSOBDF="D":"DO NOT MAIL",1:"FOREIGN ADDRESS")_" report - division = ",$S($G(PSUSDIV):$P($G(^PS(59,+$G(PSOSITE),0)),"^"),1:"ALL")
	W !,"for suspense dates through "_$G(PSOEDTX) W:PSOBDF="A" ?70,"B/D/F"
	W !,PSOLINE
	Q
MESS	;
	W !!,"Nothing queued to print.",!
	K DTOUT,DUOUT
	Q
NAME	;Set name(ssn)
	K VA S DFN=PSONX D PID^VADPT6
	S PSONSSN=$G(PSONI)_"   ("_$E(VA("PID"),5,12)_")"
	K VA
	Q
PRALL	;Print data for all patients
	N PSOADDR
	S PSOADDR=""
	S PSOAFLAG=0
	W !!,$G(PSONSSN) D CHKADDR W ?30,"  ",PSOADDR I ($Y+5)>IOSL D HD Q:PSOUT
	Q
PRONE	;Print data for one patient
	N SFN0
	S SFN0=$G(^PSRX(SFN,0)) I SFN0=""!($P(SFN0,"^",6)="") Q
	D CON W !,$G(PSOADATE),?15," Rx#: ",$P(SFN0,"^"),?30,"  ",$P($G(^PSDRUG($P(SFN0,"^",6),0)),"^")
	W:PSOBDF="A" ?70,PNODE
	I ($Y+5)>IOSL D HD Q:PSOUT
	Q
CON	;
	I PSOAFLAG W !,$G(PSONSSN) S PSOAFLAG=0
	Q
	;
CHKADDR	;
	N PSOBADR,PSOTEMP
	S PSOBADR=$$BADADR^DGUTL3(PSODFN)
	I PSOBADR D
	.S PSOTEMP=$$CHKTEMP^PSOBAI(PSODFN)
	I PSOBADR,'PSOTEMP S (PSOBAI,PSOBDF("B"))=1 Q
	Q
	;
FOREIGN	;
	N PSOFORGN,PSON
	S DFN=PSODFN D ADD^VADPT
	S PSOFORGN=$P($G(VAPA(25)),"^",2) I PSOFORGN'="" D   ;*362
	.S PSOBDF("F")=1
	.S PSON=$$GET1^DIQ(59,PSOSITE,.01)
	.I PSON'["MANILA",PSOFORGN["UNITED STATES" S PSOBDF("F")=0 Q
	.I PSON["MANILA",PSOFORGN["PHILIPPINES" S PSOBDF("F")=0
	Q
	;
CHKMAIL	;
	N PSOTEMP,MAILEXP
	S PSOTEMP=$G(^PS(55,PSODFN,0)) Q:$P(PSOTEMP,"^",3)'=2
	S MAILEXP=$P(PSOTEMP,"^",5) I MAILEXP=""!(MAILEXP>DT) S PSOBDF("D")=1
	Q
	;
DETAIL	;
	I '$D(^PS(52.5,SFN,0))!'$D(^DPT(+PSODFN,0)) Q
	S RXIEN=+$$GET1^DIQ(52.5,SFN,.01,"I")
	S RXSITE=+$$GET1^DIQ(52.5,SFN,.06,"I")
	I $G(PSUSDIV),RXSITE'=$G(PSOSITE) Q
	S RXSTS=$$GET1^DIQ(52,RXIEN,100,"I") I RXSTS>8 Q
	S PARTIAL=+$$GET1^DIQ(52.5,SFN,.05,"I")
	I PARTIAL,'$D(^PSRX(RXIEN,"P",PARTIAL)) Q
	S PSOANAME=$P($G(^DPT(PSODFN,0)),"^") Q:PSOANAME=""
	S ^TMP("PSOBADL",$J,PSOANAME,PSODFN,PSORD,RXIEN)=$S(PSOBDF("B"):"B",PSOBDF("D"):"D",PSOBDF("F"):"F",1:"")
	Q
