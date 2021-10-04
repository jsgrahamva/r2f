DVBAB2	;ALB/KLB - CAPRI RO AMIS REPORT CONT. ;05/01/00
	;;2.7;AMIE;**35,42,149,184**;Apr 10, 1995;Build 10
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
DAY30	;exam completion
	N DVBADTS,DVBAPPTS,DVBACNT,DVBADTM,DVBANDE,X,X1,X2
	K ^TMP("DVBC",$J),^TMP($J,"SDAMA301")
	;DES Type exams required to be completed in 45 days, all others 30
	S DVBADTS=$S(((";IDES;")[(";"_DVBAPREXM_";")):45,1:30)
	;setup call to scheduling API
	S DVBAPPTS(1)=DTRPT_";"_EDATE,DVBAPPTS(4)=PNAM,DVBAPPTS(3)="R;I;NT"
	S DVBAPPTS("SORT")="P",DVBAPPTS("FLDS")="10"
	S DVBACNT=$$SDAPI^SDAMA301(.DVBAPPTS)
	I (DVBACNT'>0) K ^TMP($J,"SDAMA301") Q
	S DVBADTM=""
	F  S DVBADTM=$O(^TMP($J,"SDAMA301",PNAM,DVBADTM)) Q:('+DVBADTM)  D
	.S ^TMP("DVBC",$J,9999999-DVBADTM,DVBADTM)=""
	S DVBANDE=$O(^TMP("DVBC",$J,0)),DVBADTM=$O(^TMP("DVBC",$J,DVBANDE,0))
	D:(DVBADTM]"")
	.S X2=DVBADTM,X1=$S(DTSCHEDC]"":DTSCHEDC,1:DVBCNOW)
	.D ^%DTC  ;calculate date diff
	.S:(X>DVBADTS) TOT(DVBAPREXM,"30DAYEX")=TOT(DVBAPREXM,"30DAYEX")+1
	K ^TMP($J,"SDAMA301")
	Q
	;
PENDCNT	I X'<0&(X'>90) S TOT(DVBAPREXM,"P90")=TOT(DVBAPREXM,"P90")+1
	I X>90&(X'>120) S TOT(DVBAPREXM,"P121")=TOT(DVBAPREXM,"P121")+1
	I X>120&(X'>150) S TOT(DVBAPREXM,"P151")=TOT(DVBAPREXM,"P151")+1
	I X>150&(X'>180) S TOT(DVBAPREXM,"P181")=TOT(DVBAPREXM,"P181")+1
	I X>180&(X'>365) S TOT(DVBAPREXM,"P365")=TOT(DVBAPREXM,"P365")+1
	I X>365 S TOT(DVBAPREXM,"P366")=TOT(DVBAPREXM,"P366")+1
	Q
	;
SET	;
	N DVBAPREXM
	S DTA=^DVB(396.3,REQDA,0),DTREQ=$P(DTA,U,2),XRONUM=$P(DTA,U,3),XRONUM=$S($D(^DIC(4,+XRONUM,99)):$P(^(99),U,1),1:0) Q:XRONUM'=RONUM&(RONUM'="ALL")
	; Next 2 lines check for specific division  SPH/ALB - 9/3/02
	I DVBDIV'="" I '$D(^DVB(396.3,REQDA,1)) Q
	I DVBDIV'="" I $P(^DVB(396.3,REQDA,1),"^",4)'=DVBDIV Q
	K XRONUM S DTRPT=$P(DTA,U,5),DTSCHEDC=$P(DTA,U,6),DTRQCMP=$P(DTA,U,7),DTTRANS=$P(DTA,U,12),DTREL=$P(DTA,U,14),RQSTAT=$P(DTA,U,18),DTCAN=$P(DTA,U,19),PRIO=$P(DTA,U,10) K DTA
	I DTRPT="",DTCAN]"" S DTRPT=DTCAN
	Q:DTRPT=""  ;requests never printed
	;check for Parent Request (retrieve current/parent Priority of Exam)
	S DVBAPREXM=$$CHKREQ^DVBCIRP1(REQDA)
	;original report run (Exclude new priorities)
	Q:((DVBAEXMP']"")&((";BDD;QS;IDES;AO;")[(";"_DVBAPREXM_";")))
	;report for specific priority
	Q:((DVBAEXMP]"")&(DVBAEXMP'[(";"_DVBAPREXM_";")))
	S:(DVBAEXMP']"") DVBAPREXM="ALL"  ;identifier for totals
	I DTREL'<BDATE,DTREL'>EDATE D DAY30
	I DTRPT'<BDATE,DTRPT'>EDATE S TOT(DVBAPREXM,"SENT")=TOT(DVBAPREXM,"SENT")+1
	I DTRPT'<BDATE,DTRPT'>EDATE,RQSTAT'["X" S X1=$S(DTSCHEDC]"":DTSCHEDC,1:DVBCNOW),X2=DTRPT D ^%DTC I X>3 S TOT(DVBAPREXM,"3DAYSCH")=TOT(DVBAPREXM,"3DAYSCH")+1
	I DTREL'<BDATE&(DTREL'>EDATE),RQSTAT="C"!(RQSTAT="R") S:PRIO'="E" DVBCPCTM=$$PROCDAY^DVBCUTL2(REQDA) S:PRIO="E" DVBCPCTM=$$INSFTME^DVBCUTA1(REQDA) S TOT(DVBAPREXM,"DAYS")=TOT(DVBAPREXM,"DAYS")+DVBCPCTM K DVBCPCTM
	I DTRPT'>EDATE,"^P^S^T"[RQSTAT S TOT(DVBAPREXM,"PENDADJ")=TOT(DVBAPREXM,"PENDADJ")+1,X1=EDATE,X2=DTRPT D ^%DTC,PENDCNT
	I DTRPT'>EDATE,"^C^CT^R^RX^X^"[RQSTAT,(+DTREL>EDATE)!(+DTCAN>EDATE) S TOT(DVBAPREXM,"PENDADJ")=TOT(DVBAPREXM,"PENDADJ")+1,X1=EDATE,X2=DTRPT D ^%DTC,PENDCNT
	I DTREL'<BDATE&(DTREL'>EDATE),RQSTAT["C"!(RQSTAT="R") S TOT(DVBAPREXM,"COMPLETED")=TOT(DVBAPREXM,"COMPLETED")+1
	I DTRPT'<BDATE,DTRPT'>EDATE,PRIO="E" S TOT(DVBAPREXM,"INSUFF")=TOT(DVBAPREXM,"INSUFF")+1
	I DTCAN'<BDATE&(DTCAN'>EDATE),RQSTAT="X"!(RQSTAT="RX") S TOT(DVBAPREXM,"INCOMPLETE")=TOT(DVBAPREXM,"INCOMPLETE")+1
	K DTRPT Q
	;
GO	;
	N DVBAEXMP,DVBAP,DVBAPREXM,DVBATOT,DVBALNE
	S DVBAEXMP=$S($G(DVBAPRTY)["BDD":";BDD;QS;",($G(DVBAPRTY)["IDES"):";IDES;",($G(DVBAPRTY)["AO"):";AO;",1:"")
	S DVBABCNT=0,DVBALNE="" K ^TMP($J)
	S %DT="TS",X="NOW" D ^%DT S DVBCNOW=Y
	S PNAM="" F JJ=0:0 S PNAM=$O(^DVB(396.3,"B",PNAM)) Q:PNAM=""  F REQDA=0:0 S REQDA=$O(^DVB(396.3,"B",PNAM,REQDA)) Q:REQDA=""  D SET
	;
	S DVBAEXMP=$S($G(DVBAPRTY)["BDD":"BDD,QS",($G(DVBAPRTY)["IDES"):"IDES",($G(DVBAPRTY)["AO"):"AO",1:"ALL")
	M DVBATOT=TOT  ;save totals for all priorities into new array
	F DVBAP=1:1:$L(DVBAEXMP,",") D
	.S DVBAPREXM=$P(DVBAEXMP,",",DVBAP)
	.;re-create TOT array for each priority of exam
	.D CRTOT^DVBCAMR2(DVBAPREXM,.DVBATOT,.TOT)
	.S TOT("AVGDAYS")=0
	.I TOT("COMPLETED")>0 S TOT("AVGDAYS")=TOT("DAYS")/TOT("COMPLETED"),TOT("AVGDAYS")=$J(TOT("AVGDAYS"),5,1)
	.D BULLTXT^DVBCAMR1(DVBAPREXM)
	.F JI=0:0 S JI=$O(^TMP($J,JI)) Q:JI=""  S DVBABCNT=DVBABCNT+1,MSG(DVBABCNT)=^TMP($J,JI,0)
	.S:'$D(XMY) SBULL="N" I SBULL="Y" D SEND
	.D:(DVBAP'=$L(DVBAEXMP,","))  ;another report to run
	..;insert line breaks / horizontal line break
	..S DVBABCNT=DVBABCNT+1,MSG(DVBABCNT)=""
	..F JI=1:1:70 S $P(DVBALNE,"-",JI)="-"
	..S DVBABCNT=DVBABCNT+1,MSG(DVBABCNT)=DVBALNE
	..S DVBABCNT=DVBABCNT+1,MSG(DVBABCNT)=""
	;
EXIT	K BDATE,%DT,DVBABCNT,C,DTCAN,DTREL,DTREQ,DTRQCMP,DTSCHEDC,DTTRANS
	K DVBCNOW,DVBCPCTM,EDATE,FA,FB,JI,JJ,L,PNAM,PRIO,REQDA,RONUM,RQSTAT
	K SBULL,TOT,X,X1,X2,XMDUZ,XMMG,XMY,Y,YY
	Q
	;
BULL	S XMDUZ=$P(^VA(200,DUZ,0),U),XMMG=$S($D(^VA(200,DUZ,0)):$P(^(0),U,1),1:""),XMY(DUZ)=""
	Q
	;
SEND	;send 2507 AMIS report in bulletin
	N DVBAXMY M DVBAXMY=XMY
	S XMSUB="RO AMIS 290 Report "_$S((($G(DVBAPREXM)]"")&($G(DVBAPREXM)'="ALL")):"("_$G(DVBAPREXM)_" Exam Priority) ",1:"")_"-  "
	S Y=BDATE X ^DD("DD") S XMSUB=XMSUB_Y S Y=EDATE X ^DD("DD") S XMSUB=XMSUB_" to "_Y,XMTEXT="^TMP($J,"
	D ^XMD K XMTEXT,XMSUB,^TMP($J)
	S DVBABCNT=DVBABCNT+1,MSG(DVBABCNT)=""
	S DVBABCNT=DVBABCNT+1,MSG(DVBABCNT)=">>> Mail message transmitted. <<<"
	M XMY=DVBAXMY  ;restore address list for subsequent bulletins
	Q
	;
