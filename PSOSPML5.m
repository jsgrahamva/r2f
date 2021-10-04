PSOSPML5	;BIRM/MFR - SPMP Information Disclosure Report ;04/10/13
	;;7.0;OUTPATIENT PHARMACY;**408**;DEC 1997;Build 100
	;
	N %DT,BATIEN,DIR,DIRUT,X,Y,DIC,DTOUT,DUOUT,PSOFROM,PSOTO,PSOST,PSOPT
	;
	; - Ask for FROM DATE
	S %DT(0)=-DT,%DT="AEP",%DT("A")="     BEGIN DATE: "
	W ! D ^%DT I Y<0!($D(DTOUT)) G EXIT
	S PSOFROM=Y\1-.00001
	;
	; - Ask for TO DATE
	K %DT S %DT(0)=PSOFROM+1\1,%DT="AEP",%DT("B")="TODAY",%DT("A")="     END DATE: "
	W ! D ^%DT I Y<0!($D(DTOUT)) G EXIT
	S PSOTO=Y\1+.99999
	;
	; - Selection of STATE to print on the Report
	N DIC,X,I,Y K PSOST S PSOST=""
	W !!,?5,"You may select a single or multiple STATES,"
	W !,?5,"or enter ^ALL to select all STATES.",!
	S DIC("B")=$$GET1^DIQ(5,+$O(^PS(58.41,0)),.01)
	S DIC=5,DIC(0)="QEAM",DIC("A")="     Select STATE: "
	F  D ^DIC Q:Y<0  S PSOST(+Y)="" K DIC("B") S DIC("A")="     Another STATE: "
	I X="^ALL" S PSOST="ALL"
	I $G(PSOST)'="ALL",$D(DUOUT)!($D(DTOUT)) Q
	I $G(PSOST)'="ALL",'$O(PSOST(0)) Q
	;
	; - Selection of PATIENTS to print on the Report
	N DIC,X,I,Y K PSOPT S PSOPT=""
	W !!,?5,"You may select a single or multiple PATIENTS,"
	W !,?5,"or enter ^ALL to select all PATIENTS.",!
	S DIC(0)="QEAM",DIC("A")="     Select PATIENT: ",DIC("B")="^ALL"
	F  D EN^PSOPATLK S Y=PSOPTLK Q:+Y<1  S PSOPT(+Y)="" K PSOPTLK S DIC("A")="     Another PATIENT: "
	I Y="^ALL" K PSOPT S PSOPT="ALL"
	I $G(PSOPT)'="ALL",$G(PSOPTLK)="^" Q
	I $G(PSOPT)'="ALL",'$O(PSOPT(0)) Q
	;
	W !!,"Please wait..."
	;
	D EN(PSOFROM,PSOTO,.PSOST,.PSOPT)
	;
	G EXIT
	;
EN(PSOFROM,PSOTO,PSOST,PSOPT)	; Entry point
	D EN^VALM("PSO SPMP DISCLOSURE REPORT")
	D FULL^VALM1
	Q
	;
HDR	; - Builds the Header section
	S VALMHDR(1)="Date Range: "_$$FMTE^XLFDT(PSOFROM+1\1,2)_" - "_$$FMTE^XLFDT(PSOTO\1,2)
	S VALMHDR(2)="State(s): "_$S($G(PSOST)="ALL":"ALL",$O(PSOST($O(PSOST(0)))):"Multiple",1:$$GET1^DIQ(5,+$O(PSOST(0)),.01))
	S $E(VALMHDR(2),40)="Patient(s): "_$S($G(PSOPT)="ALL":"ALL",$O(PSOPT($O(PSOPT(0)))):"Multiple",1:$$GET1^DIQ(2,+$O(PSOPT(0)),.01))
	S VALMHDR(3)=""
	S VALMHDR(4)="   # DT DISC PATIENT                    Rx#            DRUG"
	Q
	;
INIT	; Builds the Body section
	N RXCNT,BATDT,I,LINE,TYPE,NODE0,RX,COUNT,DRUGIEN,DRUGNAM,DRUGDEA,DSPLINE,FILL,RECTYPE,DFN,L4SSN
	N BATRXIEN,DISCDT,PATNAM,PATIEN,RXIEN,RXNFLL,RXNUM,STATE
	;
	K ^TMP("PSOSPSRT",$J)
	S BATDT=PSOFROM
	F  S BATDT=$O(^PS(58.42,"AD",BATDT)) Q:'BATDT!(BATDT>PSOTO)  D
	. S BATIEN=0 F  S BATIEN=$O(^PS(58.42,"AD",BATDT,BATIEN)) Q:'BATIEN  D
	. . S STATE=$$GET1^DIQ(58.42,BATIEN,1,"I")
	. . S DISCDT=$P(^PS(58.42,BATIEN,0),"^",10) I 'DISCDT Q
	. . I $G(PSOST)'="ALL",'$D(PSOST(STATE)) Q
	. . S BATRXIEN=0 F  S BATRXIEN=$O(^PS(58.42,BATIEN,"RX",BATRXIEN)) Q:'BATRXIEN  D
	. . . S NODE0=$G(^PS(58.42,BATIEN,"RX",BATRXIEN,0))
	. . . S RXIEN=+NODE0,FILL=$P(NODE0,"^",2),RECTYPE=$P(NODE0,"^",3),PATIEN=$$GET1^DIQ(52,RXIEN,2,"I")
	. . . I $G(PSOPT)'="ALL",'$D(PSOPT(PATIEN)) Q
	. . . S ^TMP("PSOSPSRT",$J,$$GET1^DIQ(5,STATE,.01),$$GET1^DIQ(52,RXIEN,2)_"^"_PATIEN,RXIEN_"^"_FILL_"^"_BATIEN)=DISCDT\1
	;
	K ^TMP("PSOSPML5",$J) S (VALMCNT,LINE,RXCNT,COUNT)=0
	S (STATE,PATNAM,RXNFLL)="",COUNT=0
	F  S STATE=$O(^TMP("PSOSPSRT",$J,STATE)) Q:STATE=""  D
	. D SETLN^PSOSPMU1("PSOSPML5","Disclosed to:"_STATE,0,0,0)
	. D SETLN^PSOSPMU1("PSOSPML5","Info Disclosed: Name, DOB, SSN, Prescription Data, Home Address, Phone Number",0,0,0)
	. F  S PATNAM=$O(^TMP("PSOSPSRT",$J,STATE,PATNAM)) Q:PATNAM=""  D
	. . S DFN=$P(PATNAM,"^",2) D DEM^VADPT S L4SSN=$P($P(VADM(2),"^",2),"-",3)
	. . F  S RXNFLL=$O(^TMP("PSOSPSRT",$J,STATE,PATNAM,RXNFLL)) Q:RXNFLL=""  D
	. . . S DISCDT=^TMP("PSOSPSRT",$J,STATE,PATNAM,RXNFLL)
	. . . S RXIEN=+RXNFLL,FILL=$P(RXNFLL,"^",2),RECTYPE=$P(RXNFLL,"^",3)
	. . . S RXNUM=$$GET1^DIQ(52,RXIEN,.01)
	. . . S DRUGNAM=$$GET1^DIQ(52,RXIEN,6)
	. . . S COUNT=COUNT+1
	. . . S DSPLINE=$J(COUNT,4)_" "_$$FMTE^XLFDT(DISCDT,"2Y"),$E(DSPLINE,14)=$E($P(PATNAM,"^"),1,20)_"("_L4SSN_")"
	. . . S $E(DSPLINE,41)=RXNUM,$E(DSPLINE,56)=$E(DRUGNAM,1,25)
	. . . D SETLN^PSOSPMU1("PSOSPML5",DSPLINE,0,0,0)
	. . . S ^TMP("PSOSPML5",$J,COUNT,"RX")=RXIEN_"^"_FILL_"^"_RECTYPE
	. D SETLN^PSOSPMU1("PSOSPML5"," ",0,0,0)
	I '$D(^TMP("PSOSPML5",$J)) D
	. D SETLN^PSOSPMU1("PSOSPML5","No data found for the date range selected.",0,0,0)
	S VALMCNT=LINE
	Q
	;
SEL	;Process selection of one entry
	N PSOSEL,XQORM,ORD,TITLE,RXINFO,LINE
	S PSOSEL=+$P(XQORNOD(0),"=",2) I 'PSOSEL S VALMSG="Invalid selection!",VALMBCK="R" Q
	S RXINFO=$G(^TMP("PSOSPML5",$J,PSOSEL,"RX"))
	I 'RXINFO S VALMSG="Invalid selection!",VALMBCK="R" Q
	S TITLE=VALM("TITLE")
	D EN^PSOSPML4(+RXINFO,$P(RXINFO,"^",2),$P(RXINFO,"^",3))
	S VALMBCK="R",VALM("TITLE")=TITLE
	D INIT,HDR
	Q
	;
EXIT	;
	K ^TMP("PSOSPML5",$J)
	Q
	;
HELP	; Listman HELP entry-point
	Q
