GMPL	; SLC/MKB/AJB -- Problem List Driver ;03/31/14  12:21
	;;2.0;Problem List;**3,11,28,42**;Aug 25, 1994;Build 46
EN	; -- main entry point for GMPL PROBLEM LIST
	S GMPLUSER=1
	D EN^VALM("GMPL PROBLEM LIST")
	Q
	;
DE	; -- main entry point for GMPL DATA ENTRY
	K GMPLUSER
	D EN^VALM("GMPL DATA ENTRY")
	Q
	;
ADD	; -- add a new problem
	S VALMBCK="",GMPCLIN="" K GMPREBLD
	I +$P(GMPDFN,U,4),'$$CKDEAD^GMPLX1($P(GMPDFN,U,4)) G ADDQ
	S:$E(GMPLVIEW("VIEW"))'="S" GMPCLIN=$$CLINIC^GMPLX1("") G:GMPCLIN="^" ADDQ
	S GMPLSLST=$P($G(^VA(200,DUZ,125)),U,2)
	I 'GMPLSLST,GMPCLIN,$D(^GMPL(125,"C",+GMPCLIN)) S GMPLSLST=$O(^(+GMPCLIN,0)) ; if user has no list but clinic does, use clinic list
	I GMPLSLST D  G ADD1
	. S $P(GMPLSLST,U,2)=$P($G(^GMPL(125,+GMPLSLST,0)),U)
	. D EN^VALM("GMPL LIST MENU")
	W @IOF D FULL^VALM1 F  D ADD^GMPL1 Q:$D(GMPQUIT)  S:$D(GMPSAVED) GMPREBLD=1 K DUOUT,DTOUT,GMPSAVED W !!!,">>>  Please enter another problem, or press <return> to exit."
	S VALMBCK="R"
ADD1	I $D(GMPREBLD) D
	. S VALMBCK="R",GMPRINT=1
	. S VALMBG=$S(GMPARAM("REV"):1,VALMCNT<10:1,1:VALMCNT-9)
	. D BUILD^GMPLMGR(.GMPLIST),HDR^GMPLMGR
ADDQ	D KILL^GMPLX S VALMSG=$$MSG^GMPLX S:'VALMCC VALMBCK="R"
	Q
	;
STATUS	; -- inactivate a problem
	S VALMBCK="" G:+$G(GMPCOUNT)'>0 STQ
	I GMPLVIEW("ACT")="I" W $C(7),!!,"Currently displayed problems are already inactive!",! G STQ
	S GMPLSEL=$$SEL^GMPLX("inactivate") G:GMPLSEL="^" STQ
	S GMPLNO=$L(GMPLSEL,",")
	F GMPI=1:1:GMPLNO S GMPLNUM=$P(GMPLSEL,",",GMPI) I GMPLNUM D  Q:$D(GMPQUIT)
	. S GMPIFN=$P($G(^TMP("GMPLIDX",$J,+GMPLNUM)),U,2) Q:GMPIFN'>0
	. I $P(^AUPNPROB(GMPIFN,0),U,12)="I" W !!,$$PROBTEXT^GMPLX(GMPIFN),!,"is already inactive!",! H 2 Q
	. I $P($G(^AUPNPROB(GMPIFN,1)),U,2)="H" W !!,$$PROBTEXT^GMPLX(GMPIFN),!,"has been removed from this patient's problem list!",! H 2 Q
	. L +^AUPNPROB(GMPIFN,0):1 I '$T W $C(7),!!,$$LOCKED^GMPLX,! H 2 Q
	. D STATUS^GMPL1 L -^AUPNPROB(GMPIFN,0)
	I $D(GMPSAVED) D
	. S VALMBCK="R",GMPRINT=1
	. D BUILD^GMPLMGR(.GMPLIST),HDR^GMPLMGR
STQ	D KILL^GMPLX S VALMSG=$$MSG^GMPLX S:'VALMCC VALMBCK="R"
	Q
	;
NOTES	; -- annotate a problem
	S VALMBCK="" G:+$G(GMPCOUNT)'>0 NTQ
	S GMPLNUM=$$SEL1^GMPLX("add comment(s) to") G:GMPLNUM="^" NTQ
	S GMPIFN=$P($G(^TMP("GMPLIDX",$J,+GMPLNUM)),U,2) G:GMPIFN'>0 NTQ
	I $P($G(^AUPNPROB(GMPIFN,1)),U,2)="H" W !!,$$PROBTEXT^GMPLX(GMPIFN),!,"has been removed from this patient's problem list!",! H 2 G NTQ
	L +^AUPNPROB(GMPIFN,0):1 I '$T W $C(7),!!,$$LOCKED^GMPLX,! H 2 G NTQ
	D NEWNOTE^GMPL1 I $D(GMPSAVED) D
	. S VALMBCK="R",GMPRINT=1
	. D BUILD^GMPLMGR(.GMPLIST)
	L -^AUPNPROB(GMPIFN,0)
NTQ	D KILL^GMPLX S VALMSG=$$MSG^GMPLX S:'VALMCC VALMBCK="R"
	Q
	;
EDIT	; -- edit allowable fields of a problem
	S VALMBCK="" G:+$G(GMPCOUNT)'>0 EDQ
	S GMPLNUM=$$SEL1^GMPLX("edit") G:GMPLNUM="^" EDQ
	S GMPIFN=$P($G(^TMP("GMPLIDX",$J,+GMPLNUM)),U,2) G:GMPIFN'>0 EDQ
	; Code Set Versioning (CSV)
	; I '$$CODESTS^GMPLX(GMPIFN,DT) W !!,$$PROBTEXT^GMPLX(GMPIFN),!,"has an inactive ICD code.",! H 3 G EDQ
	I $P($G(^AUPNPROB(GMPIFN,1)),U,2)="H" W !!,$$PROBTEXT^GMPLX(GMPIFN),!,"has been removed from this patient's problem list!",! H 2 G EDQ
	L +^AUPNPROB(GMPIFN,0):1 I '$T W $C(7),!!,$$LOCKED^GMPLX,! H 2 G EDQ
	D EN^VALM("GMPL EDIT PROBLEM")
	I $D(GMPSAVED) D BUILD^GMPLMGR(.GMPLIST),HDR^GMPLMGR S GMPRINT=1
	S VALMBCK="R" L -^AUPNPROB(GMPIFN,0)
EDQ	D KILL^GMPLX S VALMSG=$$MSG^GMPLX S:'VALMCC VALMBCK="R"
	Q
	;
DELETE	; -- delete a problem
	S VALMBCK="" G:+$G(GMPCOUNT)'>0 DELQ
	S GMPLSEL=$$SEL^GMPLX("remove from the list") G:GMPLSEL="^" DELQ
	S GMPLNO=$L(GMPLSEL,",") G:'$$SUREDEL^GMPLEDT2(GMPLNO-1) DELQ
	F GMPI=1:1:GMPLNO S GMPLNUM=$P(GMPLSEL,",",GMPI) I GMPLNUM D  Q:$D(GMPQUIT)
	. S GMPIFN=$P($G(^TMP("GMPLIDX",$J,+GMPLNUM)),U,2) Q:GMPIFN'>0
	. I $P($G(^AUPNPROB(GMPIFN,1)),U,2)="H" W !!,$$PROBTEXT^GMPLX(GMPIFN),!,"has already been removed from this patient's problem list!",! H 2 Q
	. L +^AUPNPROB(GMPIFN,0):1 I '$T W $C(7),!!,$$LOCKED^GMPLX,! H 2 Q
	. D DELETE^GMPL1 L -^AUPNPROB(GMPIFN,0)
	I $D(GMPSAVED) D
	. S VALMBCK="R",GMPRINT=1 D BUILD^GMPLMGR(.GMPLIST),HDR^GMPLMGR
DELQ	D KILL^GMPLX S VALMSG=$$MSG^GMPLX S:'VALMCC VALMBCK="R"
	Q
	;
VERIFY	; -- verify a problem
	S VALMBCK="" Q:+$G(GMPCOUNT)'>0
	W !!,"Select the problem(s) you wish to verify as correct."
	S GMPLSEL=$$SEL^GMPLX("mark as verified") G:GMPLSEL="^" VERQ
	S GMPLNO=$L(GMPLSEL,",")
	F GMPI=1:1:GMPLNO S GMPLNUM=$P(GMPLSEL,",",GMPI) I GMPLNUM D
	. S GMPIFN=$P($G(^TMP("GMPLIDX",$J,GMPLNUM)),U,2)
	. D:GMPIFN VERIFY^GMPL1
	I $D(GMPSAVED) D BUILD^GMPLMGR(.GMPLIST) S VALMBCK="R"
VERQ	D KILL^GMPLX S VALMSG=$$MSG^GMPLX S:'VALMCC VALMBCK="R"
	Q
	;
EXPAND	; -- detailed display of a problem
	S VALMBCK="" Q:+$G(GMPCOUNT)'>0
	S GMPLSEL=$$SEL^GMPLX("view") G:GMPLSEL="^" EXPQ
	S GMPLNO=$L(GMPLSEL,",")-1,GMPI=0
	D EN^VALM("GMPL DETAILED DISPLAY")
	S VALMBCK="R"
EXPQ	D KILL^GMPLX S VALMSG=$$MSG^GMPLX S:'VALMCC VALMBCK="R"
	Q