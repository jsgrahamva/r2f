DVBAB85	;SPH - CAPRI REPORTS ;03/01/05
	;;2.7;AMIE;**90,185**;Apr 10, 1995;Build 18
	;
RPTSTAT(Y,DVBDSTRT,DVBDBEND,DVBDLMT)	;
	; REPORT FORMAT:
	; PT NAME + AUTHOR + DATE/TIME ENTERED + DATE/TIME LOCKED + STATUS
	; FORM 1, FORM 2, ETC.
	N DVBABIEN,DVBABCNT,DVBABIE2,DVBTEMP,DVBNM,DVBAUT,DVBDTE,DVBDTL,DVBST,DVBEXAMS,ST
	N DVBATMP,DVBADLMTR,X,XEXAMS
	S DVBADLMTR="^"
	I '$D(DVBDLMT) S DVBDLMT=0
	I DVBDLMT'=1 S DVBDLMT=0
	K ^TMP("DVBARPT",DUZ)
	S DVBABIEN=0,DVBABCNT=0,ST("P")="REVIEW PENDING",ST("N")="NOT REQUIRED",ST("S")="SENT BACK"
	S ST("C")="COMPLETE",ST("D")="DRAFT",ST("A")="AWAITING SIGNATURE",ST("U")="UNCOSIGNED"
	I $G(DVBDLMT)=1 S ^TMP("DVBARPT",DUZ,DVBABCNT)="Patient Name,Author,Date/Time Created,Date/Time Signed,Status,Template"_$C(13),DVBABCNT=DVBABCNT+1
	F  S DVBABIEN=$O(^DVB(396.17,DVBABIEN)) Q:'DVBABIEN  D
	. S DVBTEMP=$G(^DVB(396.17,DVBABIEN,0)),DVBDTE=$P(DVBTEMP,"^",3)
	. I DVBTEMP]"",DVBDTE>DVBDSTRT,DVBDTE-1<DVBDBEND D
	.. S DVBNM=$P(^DPT(+DVBTEMP,0),"^",1),DVBAUT=$P(^VA(200,$P(DVBTEMP,"^",2),0),"^",1),Y=$P(DVBTEMP,"^",3)
	.. X ^DD("DD") S DVBDTE=Y,Y=$P(DVBTEMP,"^",5) X ^DD("DD")
	.. S DVBDTL=Y,DVBEXAMS="",DVBABIE2=0,DVBST=$P(^DVB(396.17,DVBABIEN,5),"^",2)
	.. S:$D(ST(DVBST)) DVBST=ST(DVBST)
	.. F  S DVBABIE2=$O(^DVB(396.17,DVBABIEN,1,DVBABIE2)) Q:'DVBABIE2  S DVBEXAMS=DVBEXAMS_"|"_$P(^DVB(396.17,DVBABIEN,1,DVBABIE2,0),"^",2)
	.. ;
	.. I DVBDLMT'=1 D
	... S DVBABCNT=DVBABCNT+1
	... S ^TMP("DVBARPT",DUZ,DVBABCNT)=DVBNM_"^"_DVBAUT_"^"_DVBDTE_"^"_DVBDTL_"^"_DVBST_"^"_DVBEXAMS_$C(13)
	.. ;
	.. I DVBDLMT=1 D
	... F X=1:1:$L(DVBEXAMS,"|") D
	.... S XEXAMS=$P(DVBEXAMS,"|",X)
	.... Q:XEXAMS=""
	.... I DVBDTL="JAN 1,1980" S DVBDTL="UNSIGNED"
	.... S ^TMP("DVBARPT",DUZ,DVBABCNT)=DVBNM_"^"_DVBAUT_"^"_DVBDTE_"^"_DVBDTL_"^"_DVBST_"^"_XEXAMS
	.... S DVBATMP=^TMP("DVBARPT",DUZ,DVBABCNT)
	.... F I=1:1:$L(DVBATMP,DVBADLMTR) I $P(DVBATMP,DVBADLMTR,I)["," S $P(DVBATMP,DVBADLMTR,I)=""""_$P(DVBATMP,DVBADLMTR,I)_""""
	.... S DVBATMP=$TR(DVBATMP,DVBADLMTR,",")
	.... S ^TMP("DVBARPT",DUZ,DVBABCNT)=DVBATMP
	.... S ^TMP("DVBARPT",DUZ,DVBABCNT)=^TMP("DVBARPT",DUZ,DVBABCNT)_$C(13)
	.... S DVBABCNT=DVBABCNT+1
	;
	S Y=$NA(^TMP("DVBARPT",DUZ))
	Q
