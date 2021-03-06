PSJLMPRI	;BIR/MLM-INPATIENT LISTMAN IV PROFILE UTILITIES ;01 JUL 96 / 2:24 PM
	;;5.0;INPATIENT MEDICATIONS;**58,85,118,110,133,154,181,275**;16 DEC 97;Build 157
	;
	; Reference to ^PS(55 is supported by DBIA 2191.
	;
PIV(DFN,ON,PSJF,DN)	      ;Setup LM display for IV order. 
	N ND14,DRG,ON55,P,PSJORIFN,TYP,V,X,Y,PSJFLAG,ND4 S TYP="?" I ON["V" D
	.S Y=$G(^PS(55,DFN,"IV",+ON,0)) F X=2,3,4,5,8,9,17,23,25 S P(X)=$P(Y,U,X)
	.S TYP=$$ONE^PSJBCMA(DFN,ON,P(9),P(2),P(3)) I TYP'="O" S TYP="C"
	.S ON55=ON,P("OT")=$S(P(4)="A":"F",P(4)="H":"H",1:"I") D GTDRG^PSIVORFB,GTOT^PSIVUTL(P(4))
	.S P("PRY")=$P($G(^PS(55,DFN,"IV",+ON,.2)),U,4),PSJFLAG=$P($G(^(.2)),U,7)
	.S ND4=$G(^PS(55,DFN,"IV",+ON,4)),V=$S(P("PRY")="D":"d",1:" ")_$S((+PSJSYSU=1&'+$P(ND4,U)):"->",(+PSJSYSU=3&'+$P(ND4,U,4)):"->",1:"") I PSJFLAG D CNTRL^VALM10(PSJLN,1,4,IORVON,IORVOFF,0)
	.S PSJL=$$SETSTR^VALM1(V,PSJL,6,3)
	.S ND14=$G(^PS(55,DFN,"IV",+ON,14,0)),ND14=$P(ND14,U,3) S:ND14 ND14=+$G(^(ND14,0))
	I ON=+ON N PSJEN2,O S PSJEN2=PSJEN,O="" F  S O=$O(^PS(53.1,"ACX",ON,O)) Q:O=""  D
	.I PSJEN2'=PSJEN S PSJL=$J(PSJEN2,4)
	.S (P(2),P(3))="",P(17)=$P($G(^PS(53.1,+O,O)),U,9),Y=+$G(^(8)),P(4)=$P(Y,U),P(8)=$P(Y,U,5),P(9)=$P($G(^(2)),U),PSJFLAG=$P($G(^(.2)),U,7)
	.D GTDRG^PSIVORFA,GTOT^PSIVUTL(P(4)) D @$S($E(P("OT"))'="F":"PUD^PSJLMPRU(DFN,O_""P"",PSJF,DN)",1:"PIV^PSJLMPRI(DFN,O_""P"",PSJF,DN)") S PSJEN2=""
	I ON["P" S (P(2),P(3))="",P(17)=$P($G(^PS(53.1,+ON,0)),U,9),Y=$G(^(8)),P(4)=$P(Y,U),P(8)=$P(Y,U,5),P(9)=$P($G(^(2)),U),PSJFLAG=$P($G(^(.2)),U,7) D  I $E(P("OT"))'="F" D PUD^PSJLMPRU(DFN,ON,PSJF,DN) Q
	. D GTDRG^PSIVORFA,GTOT^PSIVUTL(P(4))
	. S ND14=$G(^PS(53.1,+ON,14,0)),ND14=$P(ND14,U,3) S:ND14 ND14=+$G(^(ND14,0))
	I $G(PSJFLAG) D CNTRL^VALM10(PSJLN,1,4,IORVON,IORVOFF,0)
	NEW PSJIVFLG S PSJIVFLG=1
	S DRG=+$O(DRG("AD",0)) D:DRG PIVAD F  S DRG=$O(DRG("AD",DRG)) Q:'DRG  S PSJL="" D PIVAD
SOL	;
	S PSJL=$S($G(PSJIVFLG):PSJL_$S(ON["V":"in",1:"    in"),1:"        in")
	NEW DRGX,NAME
	S DRG=0 F  S DRG=+$O(DRG("SOL",DRG)) Q:'DRG  D NAME^PSIVUTL(DRG("SOL",DRG),37,.NAME,0) S DRGX=0 F  S DRGX=$O(NAME(DRGX)) Q:'DRGX  S PSJL=$$SETSTR^VALM1(NAME(DRGX),PSJL,12,60) D:$G(PSJIVFLG) PIV1 D SETTMP,SETSTAT S PSJL="      "
	;S DRG=0 F  S DRG=+$O(DRG("SOL",DRG)) Q:'DRG  D NAME^PSIVUTL(DRG("SOL",DRG),39,.NAME,0) S DRGX=0 F  S DRGX=$O(NAME(DRGX)) Q:'DRGX  S PSJL=$$SETSTR^VALM1(NAME(DRGX),PSJL,12,60) D:'$G(PSJIVFLG) SETTMP D:$G(PSJIVFLG) PIV1 S PSJL="      "
	Q
PIVAD	; Print IV Additives.
	NEW NAME
	D NAME^PSIVUTL(DRG("AD",DRG),39,.NAME,1)
	I $D(NAME(2)) S PSJL=$$SETSTR^VALM1(NAME(1),PSJL,9,60) D:$G(PSJIVFLG) PIV1 D SETTMP,SETSTAT S PSJL="",PSJL=$$SETSTR^VALM1(NAME(2),PSJL,9,60) D SETTMP,SETSTAT
	I '$D(NAME(2)) S PSJL=$$SETSTR^VALM1(NAME(1),PSJL,9,60) D:$G(PSJIVFLG) PIV1 D SETTMP,SETSTAT
	Q
	;
PIV1	; Print Sched type, start/stop dates, and status.
	K PSJIVFLG,PSJCLP I $G(PSJCLORD),$G(ON)["P" N PSJCLP S PSJCLP(2)=$P(^PS(53.1,+ON,2),"^",2),PSJCLP(3)=$P(^PS(53.1,+ON,2),"^",4) F X=2,3 S PSJCLP(X)=$E($$ENDTC^PSGMI(PSJCLP(X)),1,$S($D(PSJEXTP):8,1:5))
	F X=2,3 S P(X)=$E($$ENDTC^PSGMI(P(X)),1,$S($D(PSJEXTP):8,1:5))
	I '$D(PSJEXTP) S PSJL=$$SETSTR^VALM1(TYP,PSJL,50,1),PSJL=$$SETSTR^VALM1($S($G(PSJCLP(2)):PSJCLP(2),1:P(2)),PSJL,53,7) D
	.S PSJL=$$SETSTR^VALM1($S($G(PSJCLP(3)):PSJCLP(3),1:P(3)),PSJL,60,7),PSJL=$$SETSTR^VALM1($S($G(P(25))]"":P(25),1:P(17)),PSJL,66,2)
	E  S PSJL=$$SETSTR^VALM1(TYP,PSJL,50,1),PSJL=$$SETSTR^VALM1($S($G(PSJCLP(2)):PSJCLP(2),1:P(2)),53,7),PSJL=$$SETSTR^VALM1($S($G(PSJCLP(3)):PSJCLP(3),1:P(3)),PSJL,63,7),PSJL=$$SETSTR^VALM1($S(PSJOL'="L"&($G(P(25))]""):P(25),1:P(17)),PSJL,73,2)
	I $G(ND14) S ND14=$$ENDTC^PSGMI((ND14)) S PSJL=$$SETSTR^VALM1(ND14,PSJL,$S($D(PSJEXTP):75,1:72),5) K ND14
	;* D SETTMP
	Q
SETTMP	;
	S ^TMP($S($G(PSIVLBNM)]"":PSIVLBNM,1:"PSJPRO"),$J,PSJLN,0)=PSJL,PSJLN=PSJLN+1
	Q
	;
SETSTAT	;
	I ON["P",$P($G(^PS(53.1,+ON,.2)),"^",4)="S" D CNTRL^VALM10((PSJLN-1),9,9+$L(PSJL),IOINHI_IOBON,IOINORM,0)
	Q
	; 
LASTREN(DFN,ON)	;
	N FIL,RNDT,ND0,ND14 S ND14="" I '$G(ON)!'$G(DFN) Q 0
	S FIL=$S(ON["P":"^PS(53.1,"_+ON_",14,0)",ON["V":"^PS(55,"_DFN_",""IV"","_+ON_",14,0)",ON["U":"^PS(55,"_DFN_",5,"_+ON_",14,0)",1:"")
	; Naked reference below refers to either ^PS(53.1,+ON,14,0), ^PS(55,+ON,5,14,0), or ^PS(55,+ON,5,14,0) created using indirection in variable FIL.
	Q:FIL="" 0
	S ND14=$G(@(FIL)) I $P(ND14,"^",3) S ND14=$G(^($P(ND14,"^",3),0))
	Q ND14
	;
LASTRNBY(DFN,ON)	;
	N FIL,RNBY,ND0,ND14 S RNBY=""
	S FIL=$S(ON["P":"^PS(53.1,"_+ON_",14,0)",ON["V":"^PS(55,"_DFN_",""IV"","_+ON_",14,0)",ON["U":"^PS(55,"_DFN_",5,"_+ON_",14,0)",1:"")
	; Naked reference below refers to either ^PS(53.1,+ON,14,0), ^PS(55,+ON,5,14,0), or ^PS(55,+ON,5,14,0) created using indirection in variable FIL.
	Q:FIL="" 0
	S ND14=$G(@(FIL)) I $P(ND14,"^",3) S ND14=$G(^($P(ND14,"^",3),0)),RNBY=$P(ND14,"^",2)
	Q RNBY
