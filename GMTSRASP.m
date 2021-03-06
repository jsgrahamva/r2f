GMTSRASP	; SLC/JER,KER - Selected Radiology ; 01/06/2003
	;;2.7;Health Summary;**28,37,58,88**;Oct 20, 1995;Build 23
	;
MAIN	; Controls branching
	Q:+($G(DFN))=0  Q:+($G(DFN))'=+($$RP(+($G(DFN))))
	; VM/RJT - PATCH TIU*1*227 - newed variable GMTSPC
	N GMTSI,GMW,MAX,GMTSTEST,GMDATA,GMTSPC
	S MAX=$S(+$G(GMTSNDM)>0:GMTSNDM,1:999)
	I '$O(GMTSEG(GMTSEGN,71,0)) Q
	S GMTSI=0 F  S GMTSI=$O(GMTSEG(GMTSEGN,71,GMTSI)) Q:GMTSI'>0  D
	. S GMTSTEST=GMTSEG(GMTSEGN,71,GMTSI)
	. D MAINSEL^GMTSRAE(1,GMTSTEST),LOOP:$D(^TMP("RAE",$J))
	K ^TMP("RAE",$J)
	Q
LOOP	; Loops through ^TMP("RAE",$J,
	N GMW,GMTSIDT,GMTSPN,GMLN
	S GMTSIDT=0 F  S GMTSIDT=$O(^TMP("RAE",$J,GMTSIDT)) Q:GMTSIDT'>0  D  Q:$D(GMTSQIT)
	. S GMTSPN=0 F  S GMTSPN=$O(^(GMTSIDT,GMTSPN)) Q:GMTSPN'>0  D WRT Q:$D(GMTSQIT)
	Q
WRT	; Writes component data
	Q:$D(GMTSQIT)  N X,GMTSEDT S GMDATA=1,X=+^TMP("RAE",$J,GMTSIDT,GMTSPN,0) D REGDT4^GMTSU S GMTSEDT=X
	D HD S GMTSPC=+($G(GMTSCP))+1 Q:$D(GMTSQIT)  D HD Q:$D(GMTSQIT)
	D CKP^GMTSUP Q:$D(GMTSQIT)  W GMTSEDT D PRO,CMD,IMP Q
	Q
PRO	; Procedure
	N GMTSPRO,GMTSTA,GMTSEXS,GMTSCN,GMTSCPT,GMTSI
	S GMTSPRO=$P(^TMP("RAE",$J,GMTSIDT,GMTSPN,0),"^",2),GMTSTA=$P(^(0),"^",4)
	S GMTSTA=$S(GMTSTA="RELEASED/NOT VERIFIED":"REL/NOT VER",GMTSTA="PROBLEM DRAFT":"PROB DRAFT",1:GMTSTA)
	S GMTSCPT=$P(^(0),"^",7),GMTSEXS=$P(^(0),"^",3),GMTSCN=$P(^(0),"^",9)
	S:'$L(GMTSTA)&(GMTSEXS="CANCELLED") GMTSTA=GMTSEXS
	S:'$L(GMTSTA) GMTSTA="PENDING" S GMTSTA=$$EN2^GMTSUMX(GMTSTA)
	I $L(GMTSPRO)>35 S GMTSPRO=$$WRAP^GMTSORC(GMTSPRO,31)
	D CKP^GMTSUP Q:$D(GMTSQIT)  W ?12,$P(GMTSPRO,"|"),?46,GMTSCPT,?52,$E(GMTSTA,1,17),?64,GMTSCN,!
	F GMTSI=2:1:$L(GMTSPRO,"|") D CKP^GMTSUP Q:$D(GMTSQIT)  W:$P(GMTSPRO,"|",GMTSI)]"" ?23,$P(GMTSPRO,"|",GMTSI),!
	Q
CMD	; CPT Modifiers
	;
	; Quit - CPT Modifiers will not be used with 
	;        Radiology Impression (RI) and Radiology
	;        Impression Selected (SRI) at this time
	Q
	N GMTSCPTM
	S GMTSCPTM=+($$CPT^GMTSU(+($G(GMTSEGN)))) S:$G(GMPXCMOD)="N" GMTSCPTM=0
	Q:'GMTSCPTM
	N GMTSC,GMTSCM,GMTSCT,GMTSI S GMTSC=0 F  S GMTSC=$O(^TMP("RAE",$J,GMTSIDT,GMTSPN,"CM",GMTSC)) Q:+GMTSC=0  D
	. S GMTSCM=$P($G(^TMP("RAE",$J,GMTSIDT,GMTSPN,"CM",GMTSC)),"^",1)
	. Q:'$L(GMTSCM)  S GMTSCT=$P($G(^TMP("RAE",$J,GMTSIDT,GMTSPN,"CM",GMTSC)),"^",3) Q:'$L(GMTSCT)
	. S GMTSCT=GMTSCT_" (CPT Mod "_GMTSCM_")" S:$L(GMTSCT)>35 GMTSCT=$$WRAP^GMTSORC(GMTSCT,62) D CKP^GMTSUP Q:$D(GMTSQIT)  W ?14,$P(GMTSCT,"|"),!
	. F GMTSI=2:1:$L(GMTSCT,"|") D CKP^GMTSUP Q:$D(GMTSQIT)  W:$P(GMTSCT,"|",GMTSI)]"" ?16,$P(GMTSCT,"|",GMTSI),!
	Q
IMP	; Impression
	Q:$D(GMTSQIT)  N GMTSI,GMTST,DIWF,DIWL,DIWR
	S GMTST=12 Q:'$D(^TMP("RAE",$J,GMTSIDT,GMTSPN,"I"))  K ^UTILITY($J,"W")
	S DIWF="C"_(78-GMTST),DIWL=0,DIWR=0,GMTSI=0
	F  S GMTSI=$O(^TMP("RAE",$J,GMTSIDT,GMTSPN,"I",GMTSI)) Q:+GMTSI=0  D  Q:$D(GMTSQIT)
	. S X=$G(^TMP("RAE",$J,GMTSIDT,GMTSPN,"I",GMTSI))
	. ; DBIA 10011 call ^DIWP
	. D ^DIWP
	S GMTSI=0 F  S GMTSI=$O(^UTILITY($J,"W",0,GMTSI)) Q:+GMTSI=0  D  Q:$D(GMTSQIT)
	. D CKP^GMTSUP Q:$D(GMTSQIT)  W ?GMTST,$G(^UTILITY($J,"W",0,GMTSI,0)),!
	K ^UTILITY($J,"W")
	Q
HD	; Header/Page Check
	Q:$D(GMTSQIT)  D CKP^GMTSUP Q:$D(GMTSQIT)  Q:+($G(GMTSNPG))=0&(+($G(GMTSPC))>0)
	W "Date",?12,"Procedure",?46,"CPT",?52,"Status",?64,"Case #",!
	Q
RP(X)	; Radiology Patient
	N Y S X=+($G(X))
	; DBIA 2056 call $$GET1^DIQ
	S Y=$$GET1^DIQ(70,X,.01,"I") S X=Y Q X
