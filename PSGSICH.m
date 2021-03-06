PSGSICH	;BIR/JCH-PROVIDER & PHARMACY OVERRIDE UTILITIES ; 08/19/11 1:02pm
	;;5.0;INPATIENT MEDICATIONS;**254,304**;16 DEC 97;Build 22
	;
	; Reference to ^APSPQA(32.4 is supported by DBIA #2179
	;
NAME(TMPDUZ,NAME,INIT)	;
	;TMPDUZ = IEN or Name in VA(200
	;NAME = Return IEN in VA(200
	;INIT = Return the initial
	NEW IEN,DIC,Y,X S X=TMPDUZ
	S DIC="^VA(200,",DIC(0)="NZ" D ^DIC
	S IEN=+Y,NAME=$G(Y(0,0)),INIT=$P($G(Y(0)),U,2)
	Q
	;
HLD	; Prompt user to continue or exit
	K DIR
	S DIR(0)="E",DIR("A")="Press RETURN to Continue or '^' to Exit "
	D ^DIR K DIR I 'Y S PSJQUITD=1
	W @IOF
	Q
	; 
ORDEXIST(PSGP,PSGORD)	; Has order been filed?
	Q:'$G(PSGP) 0
	I $G(PSGORD)["P",$D(^PS(53.1,+PSGORD,0)) Q 1
	I $G(PSGORD)["U",$D(^PS(55,PSGP,5,+PSGORD,0)) Q 1
	I $G(PSGORD)["V",$D(^PS(55,PSGP,"IV",+PSGORD,0)) Q 1
	Q 0
	;
OROICHK(DFN,ORDER,PSJOVRAR)	; Find the CPRS order number associated with the last Orderable Item edit
	N OCI,TMPOI,CURROI,TMPORDER,PSJOCDT K CURRCPRS
	I '$G(DFN)!'$G(ORDER) Q 0
	S CURROI=$S(ORDER["P":+$G(^PS(53.1,+ORDER,.2)),ORDER["U":+$G(^PS(55,DFN,5,+ORDER,.2)),ORDER["V":+$G(^PS(55,DFN,"IV",+ORDER,.2)),1:"")
	Q:'CURROI 0
	S PSJOCDT="" F  S PSJOCDT=$O(PSJOVRAR(DFN,ORDER,PSJOCDT),-1) Q:PSJOCDT=""!$G(CURRCPRS)  S OCI="" F  S OCI=$O(PSJOVRAR(DFN,ORDER,PSJOCDT,OCI)) Q:'OCI!$G(CURRCPRS)  S TMPORDER=$G(PSJOVRAR(DFN,ORDER,PSJOCDT,OCI)) I TMPORDER D
	.S TMPOI=$S(TMPORDER["P":+$G(^PS(53.1,+TMPORDER,.2)),TMPORDER["U":+$G(^PS(55,DFN,5,+TMPORDER,.2)),ORDER["V":+$G(^PS(55,DFN,"IV",+TMPORDER,.2)),1:"")
	.Q:'TMPOI  I TMPOI'=CURROI S CURRCPRS=$S(TMPORDER["P":$P($G(^PS(53.1,+TMPORDER,0)),"^",21),TMPORDER["U":$P($G(^PS(55,DFN,5,+TMPORDER,0)),"^",21),TMPORDER["V":$P($G(^PS(55,DFN,"IV",+TMPORDER,0)),"^",21),1:"")
	Q +$G(CURRCPRS)
	;
ONEINTER(INTER,PSJORDER,PSJIDTM,OUTARRAY)	; Accept one intervention IEN and return OUTARRAY with formatted intervention information
	; INPUT: INTER = Intervention IEN from ^APSPQA(32.4
	;     PSJORDER = Inpatient Order
	;      PSJIDTM = Order Date/Time
	;     OUTARRAY = Array containing CPRS overrides and pharmacy interventions 
	Q:'$G(INTER)  Q:'$D(^APSPQA(32.4,+INTER))
	D INTRDICO^PSGSICH2(+INTER)
	S INT=0 F  S INT=$O(^UTILITY("DIQ1",$J,9009032.4,INT)) Q:'INT  D INTROUT^PSGSICH2(INT,PSJIDTM,$S($G(PSJORDER):PSJORDER,1:0),.OUTARRAY)
	K ^UTILITY("DIQ1",$J)
	Q
	;
CHKADD(PSJINTER,PSGP,PSJIVORN)	; Check for existence of Intervention Orderable Item in IV Additives
	N NXTADD,PSJINTOK,ADDOI,DIC,DR,DA,NXTSOL,SOLOI
	Q:'$G(PSJINTER) 1
	K ^UTILITY("DIQ1",$J,9009032.4) S DIC="^APSPQA(32.4,",DR=".05",DA=PSJINTER,DIQ(0)="I" D EN^DIQ1
	S PSJINTOI=$G(^UTILITY("DIQ1",$J,9009032.4,PSJINTER,.05,"I")),PSJINTOI=+$G(^PSDRUG(+PSJINTOI,2)) K ^UTILITY("DIQ1",$J,9009032.4)
	I 'PSJINTOI Q 1
	I PSJIVORN["V" S NXTADD=0 F  S NXTADD=$O(^PS(55,PSGP,"IV",+PSJIVORN,"AD",NXTADD)) Q:'NXTADD!$G(PSJINTOK)  D
	.N ADDIEN S ADDIEN=+$G(^PS(55,PSGP,"IV",+PSJIVORN,"AD",NXTADD,0))
	.S ADDOI=$P($G(^PS(52.6,+ADDIEN,0)),"^",11) I ADDOI=PSJINTOI S PSJINTOK=1
	I PSJIVORN["V",'$G(PSJINTOK) S NXTSOL=0 F  S NXTSOL=$O(^PS(55,PSGP,"IV",+PSJIVORN,"SOL",NXTSOL)) Q:'NXTSOL!$G(PSJINTOK)  D
	.N SOLIEN S SOLIEN=+$G(^PS(55,PSGP,"IV",+PSJIVORN,"SOL",NXTSOL,0))
	.S SOLOI=$P($G(^PS(52.7,+SOLIEN,0)),"^",11) I SOLOI=PSJINTOI S PSJINTOK=1
	I PSJIVORN["P" S NXTADD=0 F  S NXTADD=$O(^PS(53.1,+PSJIVORN,"AD",NXTADD)) Q:'NXTADD!$G(PSJINTOK)  D
	.N ADDIEN S ADDIEN=+$G(^PS(53.1,+PSJIVORN,"AD",NXTADD,0))
	.S ADDOI=$P($G(^PS(52.6,+ADDIEN,0)),"^",11) I ADDOI=PSJINTOI S PSJINTOK=1
	I PSJIVORN["P",'$G(PSJINTOK) S NXTSOL=0 F  S NXTSOL=$O(^PS(53.1,+PSJIVORN,"SOL",NXTSOL)) Q:'NXTSOL!$G(PSJINTOK)  D
	.N SOLIEN S SOLIEN=+$G(^PS(53.1,+PSJIVORN,"SOL",NXTSOL,0))
	.S SOLOI=$P($G(^PS(52.7,+SOLIEN,0)),"^",11) I SOLOI=PSJINTOI S PSJINTOK=1
	Q $S($G(PSJINTOK):1,1:0)
	;
SETIVIN2(PSJI1,PSJI2)	; Store Intervention pointers in the IV Intervention multiple
	N PSJOLDOI,PSJNEWOI,DINUM,PSJICNT,PSJINTDT
	Q:'$G(DFN)
	I $D(^TMP("PSJINTER",$J)) D STOREINT^PSGSICH1 K ^TMP("PSJINTER",$J) Q
	I ($G(PSJI1)["P"),$G(PSJI2)["V" I $O(^PS(53.1,+$G(PSJI1),11,0)) D  Q
	.S PSJNEWOI=+$G(^PS(55,DFN,"IV",+PSJI2,.2)),PSJOLDOI=+$G(^PS(53.1,+PSJI1,.2)) Q:'PSJNEWOI  Q:(PSJNEWOI'=PSJOLDOI)
	.N PSJINCNT,PSJNXTI,PSJINTER,DO K DA,DIC S PSJINCNT=+$P($G(^PS(55,DFN,"IV",+PSJI2,8,0)),"^",3)
	.S PSJNXTI="B" F  S PSJNXTI=$O(^PS(53.1,+$G(PSJI1),11,PSJNXTI),-1) Q:'PSJNXTI  D
	..S PSJINTER=$G(^PS(53.1,+$G(PSJI1),11,PSJNXTI,0)) Q:'PSJINTER  Q:$D(^PS(55,DFN,"IV",+$G(PSJI2),8,"B",+PSJINTER))
	..S PSJICNT=$G(PSJICNT)+1 I PSJICNT=1 S PSJINTDT=$P(PSJINTER,"^",2)
	..I $G(PSJINTDT) Q:(PSJINTDT'=$P(PSJINTER,"^",2))
	..Q:'$$CHKADD(+PSJINTER,DFN,PSJI2)
	..S PSJINCNT=$G(PSJINCNT)+1
	..S DIC="^PS(55,"_+DFN_",""IV"","_+PSJI2_",8,",DIC(0)="L",DIC("P")="55.1153PA",DA(1)=+PSJI2,DA(2)=DFN,(DINUM,X)=+PSJINCNT
	..S DIC("DR")=".01////"_+PSJINTER_";1////"_$P(PSJINTER,"^",2)_";" D FILE^DICN
	.K DIC,DA
	I ($G(PSJI1)["V"),($G(PSJI2)["P") I $O(^PS(55,DFN,"IV",+PSJI1,8,0)) D  Q
	.S PSJOLDOI=+$G(^PS(55,DFN,"IV",+PSJI1,.2)),PSJNEWOI=+$G(^PS(53.1,+PSJI2,.2)) I $G(PSJNEWOI)  Q:(PSJNEWOI'=PSJOLDOI)
	.N PSJINCNT,PSJNXTI,PSJINTER K DA,DIC S PSJINCNT=+$P($G(^PS(53.1,+PSJI2,11,0)),"^",3)
	.S PSJNXTI="B" F  S PSJNXTI=$O(^PS(55,DFN,"IV",+$G(PSJI1),8,PSJNXTI),-1) Q:'PSJNXTI  D
	..S PSJINTER=$G(^PS(55,DFN,"IV",+$G(PSJI1),8,PSJNXTI,0)) Q:'PSJINTER  Q:$D(^PS(53.1,+PSJI2,11,"B",+PSJINTER))
	..S PSJICNT=$G(PSJICNT)+1 I PSJICNT=1 S PSJINTDT=$P(PSJINTER,"^",2)
	..I $G(PSJINTDT) Q:(PSJINTDT'=$P(PSJINTER,"^",2))
	..I $D(^PS(53.1,+PSJI2,"AD")) Q:'$$CHKADD(+PSJINTER,DFN,PSJI2)
	..N IC,IG S (IG,IC)=0 F  Q:$G(IG)  S IC=$O(^PS(53.1,+PSJI2,11,IC)) Q:'IC!$G(IG)  S:(+$G(^PS(53.1,+PSJI2,11,IC,0))=+PSJINTER) IG=1
	..Q:$G(IG)  S PSJINCNT=$G(PSJINCNT)+1 S DIC="^PS(53.1,"_+PSJI2_",11,",DIC(0)="L",DIC("P")="53.13PA",DA(2)=+PSJI2,X=+PSJINTER,(DINUM,DA(1))=+PSJINCNT
	..S DIC("DR")=".01////"_+PSJINTER_";1////"_$P(PSJINTER,"^",2)_";" D FILE^DICN
	I ($G(PSJI1)["P"),($G(PSJI2)["P") I $O(^PS(53.1,+PSJI1,11,0)) D  Q
	.S PSJOLDOI=+$G(^PS(53.1,+PSJI1,.2)),PSJNEWOI=+$G(^PS(53.1,+PSJI2,.2)) I $G(PSJNEWOI)  Q:(PSJNEWOI'=PSJOLDOI)
	.I PSJI1=PSJI2 Q:$G(ON)'["P"  Q:'$D(^PS(53.1,+ON,0))  S PSJI2=ON
	.N PSJINCNT,PSJNXTI,PSJINTER K DA,DIC S PSJINCNT=+$P($G(^PS(53.1,+PSJI2,11,0)),"^",3)
	.S PSJNXTI="B" F  S PSJNXTI=$O(^PS(53.1,+PSJI1,11,PSJNXTI),-1) Q:'PSJNXTI  D
	..S PSJINTER=$G(^PS(53.1,+PSJI1,11,PSJNXTI,0)) Q:'PSJINTER  Q:$D(^PS(53.1,+PSJI2,"B",+PSJINTER))
	..S PSJICNT=$G(PSJICNT)+1 I PSJICNT=1 S PSJINTDT=$P(PSJINTER,"^",2)
	..I $G(PSJINTDT) Q:(PSJINTDT'=$P(PSJINTER,"^",2))
	..I $D(^PS(53.1,+PSJI2,"AD")) Q:'$$CHKADD(PSJINTER,DFN,PSJI2)
	..N IC,IG S (IG,IC)=0 F  Q:$G(IG)  S IC=$O(^PS(53.1,+PSJI2,11,IC)) Q:'IC!$G(IG)  S:(+$G(^PS(53.1,+PSJI2,11,IC,0))=+PSJINTER) IG=1
	..Q:$G(IG)  Q:$D(^PS(53.1,+PSJI2,11,"B",+PSJINTER))  S PSJINCNT=$G(PSJINCNT)+1
	..S DIC="^PS(53.1,"_+PSJI2_",11,",DIC(0)="L",DIC("P")="53.13PA",DA(2)=+PSJI2,X=+PSJINTER,(DINUM,DA(1))=+PSJINCNT
	..S DIC("DR")=".01////"_+PSJINTER_";1////"_$P(PSJINTER,"^",2)_";" K DO D FILE^DICN K DO
	Q
