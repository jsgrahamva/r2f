DGBTR121	;ALB/RFE - SUMMARY REPORT; 05/02/12
	;;1.0;Beneficiary Travel;**20**;November 11, 2011;Build 185
	Q
EN	;Entry point
	N %,%Y,CCFEE,DATALINE,DGBTEXCEL,DGBTDIV,DGBTDIVN,DGBTQ,ENDDT,ENTRY,EQUAL,GRAND,I,LINEM,LINESP,LINEZERO,PAGE,PDT,POP,PROMPT,STARTDT,SQ,TYPE,X,X2,Y
	N ZTQUEUED
	D CLEAN^DILF
	S X2="2$",DGBTEXCEL=0
	K DIR
	S DIR("A")="START DATE: ",DIR(0)="DA^2991231:NOW:EX" D ^DIR K DIR
	I ($D(DIRUT))!($D(DIROUT)) D CLEAN^DILF Q
	S STARTDT=Y
	S DIR("A")="END DATE: ",DIR(0)="DA^"_STARTDT_":NOW:EX" D ^DIR K DIR
	I ($D(DIRUT))!($D(DIROUT)) D CLEAN^DILF Q
	S ENDDT=Y
	K DIR
	S DIR(0)="S^M:MILEAGE;S:SPECIAL MODE",DIR("A")="Which claim type do you want to run?" D ^DIR K DIR
	I (($D(DIRUT))!($D(DTOUT))!($D(DUOUT))) D CLEAN^DILF Q
	S TYPE=Y
	S X=$G(^DG(40.8,0)) I X="" W !,"WARNING...MEDICAL CENTER DIVISION FILE IS NOT SET UP",!,"USE THE ADT PARAMETER OPTION FILE TO SET UP DIVISION" D CLEAN^DILF Q
	D
	.I $$GET1^DIQ(43,1,11,"I") D  Q
	..S DGBTDIVN=$$YESNO^DGBTUTL("Do you wish to run this report for all divisions")
	..I DGBTDIVN S DGBTDIVN="ALL",DGBTDIV="" Q
	..I (($D(DIRUT))!($D(DTOUT))!($D(DUOUT))) Q
	..K DIR S DIR(0)="P^40.8:EMZ" D ^DIR K DIR
	..I (($D(DIRUT))!($D(DTOUT))!($D(DUOUT))) Q
	..S DGBTDIVN=+Y,DGBTDIV=$P(Y,U,2)
	.S DGBTDIVN=$O(^DG(40.8,0)),DGBTDIV=$P(^DG(40.8,DGBTDIVN,0),U)
	I (($D(DIRUT))!($D(DTOUT))!($D(DUOUT))) D CLEAN^DILF Q
	D SETPRT,QUIT
	Q
SETPRT	;
	S DGBTEXCEL=$$SELEXCEL^DGBTUTL
	I $G(DGBTEXCEL)="^" Q
	I '$G(DGBTEXCEL) N COLWID S COLWID=132 D PRINTMSG^DGBTUTL
	D DEVICE^DGBTUTL("Beneficiary Travel Summary Report","MAIN^DGBTR121(STARTDT,ENDDT,DGBTDIVN,DGBTDIV)")
	;D DEVICE^DGBTUTL("Beneficiary Travel Summary Report","MAIN^DGBTR121",DGBTEXCEL,132)
	I $G(DGBTQ) Q
	;
	I $D(IO("Q")) D:'$D(ZTQUEUED) ^%ZISC Q
	D MAIN(STARTDT,ENDDT,DGBTDIVN,DGBTDIV)
	D:'$D(ZTQUEUED) ^%ZISC
	U IO
	Q
MAIN(STARTDT,ENDDT,DGBTDIVN,DGBTDIV)	;
	K ^TMP("DGBTRPS",$J)
	D GETRECS
	I '$D(^TMP("DGBTRPS",$J)) W !,"No records found" D QUIT Q
	D PRINT
	Q
GETRECS	;
	I TYPE="M" F I="CLAIMS","MILEAGE","CC FEE","ECON","M&L","F&B","DED","PAY" S GRAND(I)=0
	I TYPE="S" F I="CLAIMS","MILEAGE","BASE RATE","MILEAGE FEE","NSNL","WAIT TIME","EXTRA CREW","SPECIAL EQUIPMENT","INVOICE AMOUNT" S GRAND(I)=0
	S ENTRY=$O(^DGBT(392,"D",STARTDT),-1)
	F  S ENTRY=$O(^DGBT(392,"D",ENTRY)) Q:ENTRY=""  Q:ENTRY>ENDDT  D
	.S I=""
	.F  S I=$O(^DGBT(392,"D",ENTRY,I)) Q:I=""  D GETLINE
	Q
GETLINE	;
	S LINEZERO=$G(^DGBT(392,I,0))
	I $$GET1^DIQ(392,I,45.2,"I") Q    ;'="NO" Q
	I '$$DIV Q
	S SQ=$P(LINEZERO,U,13)_U_$P(LINEZERO,"^",11)_U_$P(LINEZERO,U,6)
	S DATALINE=$G(^TMP("DGBTRPS",$J,SQ))
	S $P(DATALINE,U)=1+$P(DATALINE,U) ; CLAIMS
	I TYPE="M" D GLMILES Q
	I TYPE="S" D GLSP Q
	Q
DIV()	;
	I DGBTDIVN="ALL" Q 1
	Q $P(LINEZERO,U,11)=DGBTDIVN
GLMILES	;
	I $$GET1^DIQ(392,I,56,"I")'="M" Q
	S LINEM=$G(^DGBT(392,I,"M"))
	S CCFEE=$$GET1^DIQ(392,I,55)
	;S PAYABLE=$$PAYABLE
	S GRAND("CLAIMS")=GRAND("CLAIMS")+1
	S $P(DATALINE,U,2)=($P(LINEM,U)*$P(LINEM,U,2))+$P(DATALINE,U,2) ; MILEAGE
	S GRAND("MILEAGE")=GRAND("MILEAGE")+($P(LINEM,U)*$P(LINEM,U,2))
	S $P(DATALINE,U,3)=CCFEE+$P(DATALINE,U,3) ;COMMON CARRIER FEE
	S GRAND("CC FEE")=GRAND("CC FEE")+$$GET1^DIQ(392,I,55)
	S $P(DATALINE,U,4)=$P(LINEZERO,U,8)+$P(DATALINE,U,4) ; MOST ECONOMICAL COST
	S GRAND("ECON")=GRAND("ECON")+$P(LINEZERO,U,8)
	S $P(DATALINE,U,5)=$P(LINEM,U,4)+$P(DATALINE,U,5) ; MEALS & LODGING
	S GRAND("M&L")=GRAND("M&L")+$P(LINEM,U,4)
	S $P(DATALINE,U,6)=$P(LINEM,U,5)+$P(DATALINE,U,6) ; FERRIES & BRIDGES
	S GRAND("F&B")=GRAND("F&B")+$P(LINEM,U,5)
	S $P(DATALINE,U,7)=$P(LINEZERO,U,9)+$P(DATALINE,U,7) ; DEDUCTIBLE
	S GRAND("DED")=GRAND("DED")+$P(LINEZERO,U,9)
	S $P(DATALINE,U,8)=$P(LINEZERO,U,10)+$P(DATALINE,U,8) ; PAYABLE
	S GRAND("PAY")=GRAND("PAY")+$P(LINEZERO,U,10)
	S ^TMP("DGBTRPS",$J,SQ)=DATALINE
	Q
GLSP	;
	I $$GET1^DIQ(392,I,56,"I")'="S" Q
	S LINESP=$G(^DGBT(392,I,"SP"))
	S GRAND("CLAIMS")=GRAND("CLAIMS")+1
	S $P(DATALINE,U,2)=$P(LINESP,U,12)+$P(DATALINE,U,2) ;MILEAGE
	S GRAND("MILEAGE")=GRAND("MILEAGE")+$P(LINESP,U,12)
	S $P(DATALINE,U,3)=$P(LINESP,U,5)+$P(DATALINE,U,3) ; BASE RATE FEE
	S GRAND("BASE RATE")=GRAND("BASE RATE")+$P(LINESP,U,5)
	S $P(DATALINE,U,4)=$P(LINESP,U,6)+$P(DATALINE,U,4) ; MILEAGE FEE
	S GRAND("MILEAGE FEE")=GRAND("MILEAGE FEE")+$P(LINESP,U,6)
	S $P(DATALINE,U,5)=$P(LINESP,U,7)+$P(DATALINE,U,5) ; NO LOAD/NO SHOW
	S GRAND("NSNL")=GRAND("NSNL")+$P(LINESP,U,7)
	S $P(DATALINE,U,6)=$P(LINESP,U,8)+$P(DATALINE,U,6) ; WAIT TIME
	S GRAND("WAIT TIME")=GRAND("WAIT TIME")+$P(LINESP,U,8)
	S $P(DATALINE,U,7)=$P(LINESP,U,9)+$P(DATALINE,U,7) ; EXTRA CREW
	S GRAND("EXTRA CREW")=GRAND("EXTRA CREW")+$P(LINESP,U,9)
	S $P(DATALINE,U,8)=$P(LINESP,U,10)+$P(DATALINE,U,8) ; SPECIAL EQUIPMENT
	S GRAND("SPECIAL EQUIPMENT")=GRAND("SPECIAL EQUIPMENT")+$P(LINESP,U,10)
	S $P(DATALINE,U,9)=$P(LINESP,U,4)+$P(DATALINE,U,9) ; TOTAL INVOICE AMOUNT
	S GRAND("INVOICE AMOUNT")=GRAND("INVOICE AMOUNT")+$P(LINESP,U,4)
	S ^TMP("DGBTRPS",$J,SQ)=DATALINE
	Q
PRINT	;
	U IO
	I $G(DGBTEXCEL) D
	.I TYPE="M" W "DATE ENTERED^DIVISION^ACCT^# CLAIMS^MILEAGE^CC FEE^MOST ECONOMIC^M & L^FERRIES AND BRIDGES^DEDUCTIBLE^AMOUNT PAYABLE" Q
	.W "DATE ENTERED^DIVISION^ACCT^# CLAIMS^MILEAGE^BASE RATE^MILEAGE FEE^NO SHOW NO LOAD^WAIT TIME^EXTRA CREW^SPECIAL EQUPIMENT^INV AMT"
	S (PROMPT,SQ)="",PAGE=0,$P(EQUAL,"=",133)=""
	D NOW^%DTC S Y=% D DD^%DT S PDT=Y
	I (TYPE="M")&('$G(DGBTEXCEL)) D HDRMIL
	I (TYPE="S")&('$G(DGBTEXCEL)) D HDRSP
	F  S SQ=$O(^TMP("DGBTRPS",$J,SQ)) Q:SQ=""  D  Q:PROMPT="^"
	.S DATALINE=^TMP("DGBTRPS",$J,SQ)
	.I $G(DGBTEXCEL) D PRTXL Q
	.I (TYPE="M")&(($Y+3)>IOSL) D  Q:PROMPT="^"
	..I ($E(IOST,1)="C"),(IOSL'[99) R !,"Please press return to continue or '^' to stop ",PROMPT:DTIME Q:PROMPT="^"
	..D HDRMIL
	.I (TYPE="S")&(($Y+3)>IOSL) D  Q:PROMPT="^"
	..I ($E(IOST,1)="C"),(IOSL'[99) R !,"Please press return to continue or '^' to stop ",PROMPT:DTIME Q:PROMPT="^"
	..D HDRSP
	.I TYPE="M" D
	..W !,$S(DGBTDIV'="":DGBTDIV,1:$$GET1^DIQ(40.8,$P(SQ,U,2),.01)),?37,$$FMTE^XLFDT($P(SQ,U)),?50,$$GET1^DIQ(392.3,$P(SQ,U,3),2),?55,$P(DATALINE,U)
	..W ?64,$P(DATALINE,U,2),?72,$$DLRAMT($P(DATALINE,U,3)),?87,$$DLRAMT($P(DATALINE,U,4)),?99,$$DLRAMT($P(DATALINE,U,5)),?112,$$DLRAMT($P(DATALINE,U,6))
	..W !?5,$$DLRAMT($P(DATALINE,U,7)),?18,$$DLRAMT($P(DATALINE,U,8))
	.I TYPE="S" D
	..W !,$S(DGBTDIV'="":DGBTDIV,1:$$GET1^DIQ(40.8,$P(SQ,U,2),.01)),?37,$$FMTE^XLFDT($P(SQ,U)),?50,$$GET1^DIQ(392.3,$P(SQ,U,3),2),?55,$P(DATALINE,U)
	..W ?64,$P(DATALINE,U,2),?72,$$DLRAMT($P(DATALINE,U,3)),?87,$$DLRAMT($P(DATALINE,U,4)),?99,$$DLRAMT($P(DATALINE,U,5)),?111,$$DLRAMT($P(DATALINE,U,6))
	..W !,?5,$$DLRAMT($P(DATALINE,U,7)),?17,$$DLRAMT($P(DATALINE,U,8)),?29,$$DLRAMT($P(DATALINE,U,9))
	I '$G(DGBTEXCEL) D
	.I ($Y+4)<IOSL W !!!
	.I TYPE="M" D GRANDMIL
	.I TYPE="S" D GRANDSP
	 I IOST["C-" S DGBTQ=1 S Y=$$PAUSE^DGBTUTL(DGBTEXCEL)
	 I IOST'["C-" W !,"REPORT HAS FINISHED"
	Q
PRTXL	;
	W !,$$FMTE^XLFDT($P(SQ,U)),U,$S(DGBTDIV'="":DGBTDIV,1:$$GET1^DIQ(40.8,$P(SQ,U,2),.01)),U,$$GET1^DIQ(392.3,$P(SQ,U,3),2)
	F I=1,2 W U,$P(DATALINE,U,I)
	F I=3:1:$L(DATALINE,U) W U,$$DLRAMT($P(DATALINE,U,I))
	Q
HDRMIL	;
	S PAGE=PAGE+1
	W @IOF
	W "BT SUMMARY REPORT      PRINT DATE: ",PDT,?(126-$L(PAGE)),"PAGE ",PAGE
	W !,$$FMTE^XLFDT(STARTDT)," TO ",$$FMTE^XLFDT(ENDDT)
	W !,"CLAIM TYPE: MILEAGE"
	W !,"DIVISION: ",$S(DGBTDIVN="ALL":"ALL",1:DGBTDIV)
	W !,$E(EQUAL,1,122)
	W !,"DIVISION",?37,"ENTERED",?50,"ACCT",?55,"CLAIMS",?64,"MILEAGE",?72,"CC FEE",?87,"MOST ECON",?99,"M&L",?112,"F&B"
	W !,?5,"DED",?18,"PAYABLE"
	W !,$E(EQUAL,1,122)
	Q
HDRSP	;
	S PAGE=PAGE+1
	W @IOF
	W "BT SUMMARY REPORT      PRINT DATE: ",PDT,?(126-$L(PAGE)),"PAGE ",PAGE
	W !,$$FMTE^XLFDT(STARTDT)," TO ",$$FMTE^XLFDT(ENDDT)
	W !,"CLAIM TYPE: SPECIAL MODE"
	W !,"DIVISION: ",$S(DGBTDIVN="ALL":"ALL",1:DGBTDIV)
	W !,$E(EQUAL,1,122)
	W !,"DIVISION",?37,"ENTERED",?50,"ACCT",?55,"CLAIMS",?64,"MILEAGE",?72,"BASE RATE",?87,"MILEAGE FEE",?99,"NSNL",?111,"WAIT TIME"
	W !,?5,"EXTRA CREW",?17,"SPEC EQ",?29,"INV AMT"
	W !,$E(EQUAL,1,122)
	Q
GRANDMIL	;
	I ($Y+5)>IOSL D HDRMIL
	W !,$E(EQUAL,1,122)
	W !,?55,"CLAIMS",?64,"MILEAGE",?72,"CC FEE",?87,"MOST ECON",?99,"M&L",?112,"F&B"
	W !,?5,"DED",?18,"PAYABLE"
	W !,?55,GRAND("CLAIMS"),?64,GRAND("MILEAGE"),?72,$$DLRAMT(GRAND("CC FEE")),?87,$$DLRAMT(GRAND("ECON")),?99,$$DLRAMT(GRAND("M&L"))
	W ?112,$$DLRAMT(GRAND("F&B")),!,?5,$$DLRAMT(GRAND("DED")),?18,$$DLRAMT(GRAND("PAY"))
	W !,$E(EQUAL,1,122)
	Q
GRANDSP	;
	I ($Y+5)>IOSL D HDRSP
	W !,$E(EQUAL,1,122)
	W !,"GRAND TOTALS:",?55,GRAND("CLAIMS"),?64,GRAND("MILEAGE"),?72,$$DLRAMT(GRAND("BASE RATE")),?87,$$DLRAMT(GRAND("MILEAGE FEE"))
	W ?99,$$DLRAMT(GRAND("NSNL")),?111,$$DLRAMT(GRAND("WAIT TIME")),!,?5,$$DLRAMT(GRAND("EXTRA CREW")),?17,$$DLRAMT(GRAND("SPECIAL EQUIPMENT"))
	W ?29,$$DLRAMT(GRAND("INVOICE AMOUNT"))
	W !,$E(EQUAL,1,122)
	Q
DLRAMT(X)	;
	D COMMA^%DTC I '$G(DGBTEXCEL) Q $TR(X," ","")
	Q $TR(X," ,$","")
QUIT	; 
	K ^TMP("DGBTRPS",$J)
	D CLEAN^DILF
	Q
