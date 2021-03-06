LRPXCHK	;SLC/STAFF - Lab PXRMINDX Index Validation ;3/30/04  12:01
	;;5.2;LAB SERVICE;**295,445**;Sep 27, 1994;Build 6
	;
PATS	; select patients for index check
	N DFN,ERR,REPAIR
	D CLEAN
	F  D GETPT^LRPXAPPU(.DFN,.ERR) Q:ERR  D
	. S ^TMP("LRLOG PATS",$J,DFN)=""
	D
	. I '$O(^TMP("LRLOG PATS",$J,0)) Q
	. D GETREP(.REPAIR,.ERR) I ERR Q
	. D CHECK(REPAIR)
	D CLEAN
	Q
	;
DATES	; check indexes for a date range of patient collections
	N CNT,DATE1,DATE2,DFN,LRDFN,LRIDT,OK,REPAIR,START,STOP,SUB
	D CLEAN
	D GETDATE^LRPXAPPU(.DATE1,.DATE2,.ERR) I ERR Q
	D GETREP(.REPAIR,.ERR) I ERR Q
	S STOP=$$LRIDT^LRPXAPIU(DATE1)
	S START=$$LRIDT^LRPXAPIU(DATE2)
	S CNT=0
	S LRDFN=0
	F  S LRDFN=$O(^LR(LRDFN)) Q:LRDFN<1  D
	. S OK=0
	. F SUB="CH","MI","CY","SP","EM" D  Q:OK
	.. S LRIDT=START
	.. F  S LRIDT=$O(^LR(LRDFN,SUB,LRIDT)) Q:LRIDT<1  Q:LRIDT>STOP  D  Q:OK
	... S DFN=$$DFN^LRPXAPIU(LRDFN)
	... I 'DFN Q
	... S ^TMP("LRLOG PATS",$J,DFN)=""
	... S OK=1,CNT=CNT+1
	W !,CNT," Patients to check"
	D CHECK(REPAIR)
	D CLEAN
	Q
	;
CHECK(REPAIR)	;
	N CNT,DFN
	S REPAIR=$G(REPAIR)
	S DFN=0
	F  S DFN=$O(^TMP("LRLOG PATS",$J,DFN)) Q:DFN<1  D
	. W !,"DFN: ",DFN," LRDFN: ",$$LRDFN^LRPXAPIU(DFN)
	. D CHKPAT(DFN)
	S CNT=0
	S DFN=0
	F  S DFN=$O(^TMP("LRLOG",$J,DFN)) Q:DFN<1  D
	. S CNT=CNT+1
	I 'CNT W !,"Indexes were valid" Q
	W !,CNT," Patients with invalid indexes"
	I REPAIR D REPAIR
	Q
	;
ALL	; check all patient indexes
	; this takes a very long time
	; to be used in small test accounts
	; START and STOP determine range of DFNs to check
	Q  ; for testing
	N DFN,ERR,REPAIR,START,STOP
	D CLEAN
	W !,"WARNING - checking ALL patients",!
	D GETREP(.REPAIR,.ERR) I ERR Q
	S START=1
	S STOP=10000000000000
	S DFN=START-.1
	F  S DFN=$O(^DPT(DFN)) Q:DFN<1  Q:DFN>STOP  D
	. W !,"DFN: ",DFN," LRDFN: ",$$LRDFN^LRPXAPIU(DFN)
	. D CHKPAT(DFN)
	I REPAIR D REPAIR
	D CLEAN
	Q
	;
CHKPAT(DFN)	; from LRLOG
	; find bad nodes, 
	; store as ^TMP("LRLOG",$J,DFN,DATE,ITEM,INDEX)=NODE
	; only when ^TMP("LRLOG PATS",$J) is present
	; if ^TMP("LRLOG PATS",$J) is not present, write to screen
	N ITEM,LRDFN
	K ^TMP("LRPXCHK",$J)
	S LRDFN=$$LRDFN^LRPXAPIU(DFN)
	I 'LRDFN Q
	M ^TMP("LRPXCHK",$J,"LR",LRDFN)=^LR(LRDFN)
	M ^TMP("LRPXCHK",$J,"PI",DFN)=^PXRMINDX(63,"PI",DFN)
	M ^TMP("LRPXCHK",$J,"PDI",DFN)=^PXRMINDX(63,"PDI",DFN)
	S ITEM=""
	F  S ITEM=$O(^PXRMINDX(63,"IP",ITEM)) Q:ITEM=""  D
	. I $D(^PXRMINDX(63,"IP",ITEM,DFN)) D
	. M ^TMP("LRPXCHK",$J,"IP",ITEM,DFN)=^PXRMINDX(63,"IP",ITEM,DFN)
	D INTEG(DFN)
	D CHKLR(DFN)
	D CHKPI(DFN,LRDFN)
	K ^TMP("LRPXCHK",$J)
	Q
	;
INTEG(DFN)	; make sure "PI", "IP", and "PDI" are consistent
	N DATE,ITEM,NODE
	S DATE=0
	F  S DATE=$O(^TMP("LRPXCHK",$J,"PDI",DFN,DATE)) Q:DATE<1  D
	. S ITEM="A"
	. F  S ITEM=$O(^TMP("LRPXCHK",$J,"PDI",DFN,DATE,ITEM)) Q:ITEM=""  D
	.. S NODE=""
	.. F  S NODE=$O(^TMP("LRPXCHK",$J,"PDI",DFN,DATE,ITEM,NODE)) Q:NODE=""  D
	... I '$D(^TMP("LRPXCHK",$J,"PI",DFN,ITEM,DATE,NODE)) D
	.... D BAD("PDI-PI",DFN,ITEM,DATE,NODE)
	... I '$D(^TMP("LRPXCHK",$J,"IP",ITEM,DFN,DATE,NODE)) D
	.... D BAD("PDI-IP",DFN,ITEM,DATE,NODE)
	S ITEM=""
	F  S ITEM=$O(^TMP("LRPXCHK",$J,"PI",DFN,ITEM)) Q:ITEM=""  D
	. S DATE=0
	. F  S DATE=$O(^TMP("LRPXCHK",$J,"PI",DFN,ITEM,DATE)) Q:DATE<1  D
	.. S NODE=""
	.. F  S NODE=$O(^TMP("LRPXCHK",$J,"PI",DFN,ITEM,DATE,NODE)) Q:NODE=""  D
	... I '$D(^TMP("LRPXCHK",$J,"IP",ITEM,DFN,DATE,NODE)) D
	.... D BAD("PI-IP",DFN,ITEM,DATE,NODE)
	... I 'ITEM,'$D(^TMP("LRPXCHK",$J,"PDI",DFN,DATE,ITEM,NODE)) D
	.... D BAD("PI-PDI",DFN,ITEM,DATE,NODE)
	S ITEM=""
	F  S ITEM=$O(^TMP("LRPXCHK",$J,"IP",ITEM)) Q:ITEM=""  D
	. S DATE=0
	. F  S DATE=$O(^TMP("LRPXCHK",$J,"IP",ITEM,DFN,DATE)) Q:DATE<1  D
	.. S NODE=""
	.. F  S NODE=$O(^TMP("LRPXCHK",$J,"IP",ITEM,DFN,DATE,NODE)) Q:NODE=""  D
	... I '$D(^TMP("LRPXCHK",$J,"PI",DFN,ITEM,DATE,NODE)) D
	.... D BAD("IP-PI",DFN,ITEM,DATE,NODE)
	... I 'ITEM,'$D(^TMP("LRPXCHK",$J,"PDI",DFN,DATE,ITEM,NODE)) D
	.... D BAD("IP-PDI",DFN,ITEM,DATE,NODE)
	Q
	;
CHKLR(DFN)	; go thru "PI" to make sure ^LR is consistent
	N DATE,ITEM,NODE
	S ITEM=""
	F  S ITEM=$O(^TMP("LRPXCHK",$J,"PI",DFN,ITEM)) Q:ITEM=""  D
	. S DATE=0
	. F  S DATE=$O(^TMP("LRPXCHK",$J,"PI",DFN,ITEM,DATE)) Q:DATE<1  D
	.. S NODE=""
	.. F  S NODE=$O(^TMP("LRPXCHK",$J,"PI",DFN,ITEM,DATE,NODE)) Q:NODE=""  D
	... I '$$REFVAL(NODE) D BAD("LR",DFN,ITEM,DATE,NODE) Q
	Q
	;
CHKPI(DFN,LRDFN)	; go thru ^LR to make sure "PI" is consistent
	N DATE,ITEM,LRIDT,LRDN,NODE,ZERO
	S LRIDT=0
	F  S LRIDT=$O(^TMP("LRPXCHK",$J,"LR",LRDFN,"CH",LRIDT)) Q:LRIDT<1  D
	. S ZERO=$G(^TMP("LRPXCHK",$J,"LR",LRDFN,"CH",LRIDT,0))
	. S DATE=+ZERO I 'DATE Q
	. I '$P(ZERO,U,3) Q
	. S LRDN=1
	. F  S LRDN=$O(^TMP("LRPXCHK",$J,"LR",LRDFN,"CH",LRIDT,LRDN)) Q:LRDN<1  D
	.. S ITEM=$$TEST^LRPXAPIU(LRDN)
	.. I 'ITEM Q
	.. S NODE=LRDFN_";CH;"_LRIDT_";"_LRDN
	.. I '$D(^PXRMINDX(63,"PI",DFN,ITEM,DATE,NODE)) D BAD("CH",DFN,ITEM,DATE,NODE)
	D MI^LRPXCHKM(DFN,LRDFN)
	D AP^LRPXCHKA(DFN,LRDFN)
	Q
	;
TMPCHK(DFN,DATE,ITEM,NODE)	;
	I '$D(^PXRMINDX(63,"PI",DFN,ITEM,DATE,NODE)) D BAD(NODE,DFN,ITEM,DATE,NODE)
	Q
	;
BAD(INDEX,DFN,ITEM,DATE,NODE)	; write error to screen, collect in global
	W !,?5,INDEX," ",DFN," ",ITEM," ",DATE," ",NODE
	S ^TMP("LRLOG",$J,DFN,DATE,ITEM,INDEX)=NODE
	Q
	;
CLEAN	; clear tmp globals
	; "LRLOG" collects invalid nodes, "LRLOG PATS" are patients checked
	K ^TMP("LRLOG",$J)
	K ^TMP("LRLOG PATS",$J)
	Q
	;
REFVAL(REF)	; $$(reference location in ^LR) -> if ref exists 1, else 0
	N SUB
	I REF'[";" Q ""
	S SUB=$P(REF,";",2)
	S SUB=""""_SUB_""""
	S $P(REF,";",2)=SUB
	S REF=$TR(REF,";",",")
	S REF="^LR("_REF_")"
	I $D(@REF) Q 1
	Q 0
	;
REPAIR	; correct invalid indexes
	; kill off bad indexes
	; reset all indexes at date of bad index
	N DATE,DFN,DOD,INDEX,ITEM,NODE,REPAIR K REPAIR
	S DFN=0
	F  S DFN=$O(^TMP("LRLOG",$J,DFN)) Q:DFN<1  D
	. S LRDFN=$$LRDFN^LRPXAPIU(DFN)
	. S DOD=$$DOD^LRPXAPIU(DFN)
	. S DATE=0
	. F  S DATE=$O(^TMP("LRLOG",$J,DFN,DATE)) Q:DATE<1  D
	.. S LRIDT=$$LRIDT^LRPXAPIU(DATE)
	.. K REPAIR
	.. S ITEM=""
	.. F  S ITEM=$O(^TMP("LRLOG",$J,DFN,DATE,ITEM)) Q:ITEM=""  D
	... S INDEX=""
	... F  S INDEX=$O(^TMP("LRLOG",$J,DFN,DATE,ITEM,INDEX)) Q:INDEX=""  D
	.... S NODE=^TMP("LRLOG",$J,DFN,DATE,ITEM,INDEX)
	.... I '$L(NODE) Q
	.... S REPAIR($P(NODE,";",2))=""
	.... D KLAB^LRPX(DFN,DATE,ITEM,NODE)
	.. S SUB=""
	.. F  S SUB=$O(REPAIR(SUB)) Q:SUB=""  D
	... I SUB="CH" D CH(DFN,LRDFN,DATE,LRIDT) Q
	... I SUB="MI" D MICRO(DFN,LRDFN,DATE,LRIDT) Q
	... D AP(DFN,LRDFN,DATE,LRIDT,SUB)
	.. I DATE=DOD D AU(DFN,LRDFN,DATE) Q
	Q
	;
CH(DFN,LRDFN,DATE,LRIDT)	;
	N DAT,LRDN,NODE,TEMP,TEST
	I '$$VERIFIED^LRPXAPI(LRDFN,LRIDT) Q
	S DAT=LRDFN_";CH;"_LRIDT
	S LRDN=1
	F  S LRDN=$O(^LR(LRDFN,"CH",LRIDT,LRDN)) Q:LRDN<1  D
	. S NODE=DAT_";"_LRDN
	. S TEMP=^LR(LRDFN,"CH",LRIDT,LRDN)
	. S TEST=+$P($P(TEMP,U,3),"!",7)
	. I 'TEST S TEST=$$TEST^LRPXAPIU(LRDN)
	. I 'TEST Q
	. D SLAB^LRPX(DFN,DATE,TEST,NODE)
	Q
	;
MICRO(DFN,LRDFN,DATE,LRIDT)	;
	K ^TMP("LRPX",$J)
	M ^TMP("LRPX",$J,"AR")=^LR(LRDFN,"MI",LRIDT)
	M ^TMP("LRPX",$J,"B")=^PXRMINDX(63,"PDI",DFN,DATE)
	D MICRO^LRPXRM(DFN,LRDFN,DATE,LRIDT)
	K ^TMP("LRPX",$J)
	Q
	;
AP(DFN,LRDFN,DATE,LRIDT,SUB)	;
	K ^TMP("LRPX",$J)
	M ^TMP("LRPX",$J,"AR")=^LR(LRDFN,SUB,LRIDT)
	M ^TMP("LRPX",$J,"B")=^PXRMINDX(63,"PDI",DFN,DATE)
	D AP^LRPXRM(DFN,LRDFN,DATE,LRIDT,SUB)
	K ^TMP("LRPX",$J)
	Q
	;
AU(DFN,LRDFN,DATE)	;
	I '+$G(^LR(LRDFN,"AU")) Q
	I '($P(^LR(LRDFN,"AU"),U,3)&($P(^("AU"),U,15))) Q
	K ^TMP("LRPX",$J)
	M ^TMP("LRPX",$J,"AR","AY")=^LR(LRDFN,"AY")
	M ^TMP("LRPX",$J,"AR",80)=^LR(LRDFN,80)
	M ^TMP("LRPX",$J,"AR",33)=^LR(LRDFN,33)
	M ^TMP("LRPX",$J,"B")=^PXRMINDX(63,"PDI",DFN,DATE)
	D AUTOPSY^LRPXRM(LRDFN)
	K ^TMP("LRPX",$J)
	Q
	;
GETREP(REPAIR,ERR)	;
	; asks to repair indexes
	N DIR,DIRUT,DTOUT,X,Y K DIR
	S ERR=0,REPAIR=""
	S DIR(0)="YAO"
	S DIR("A")="Repair invalid indexes? "
	S DIR("B")="YES"
	D ^DIR K DIR
	I Y[U!$D(DTOUT) S ERR=1 Q
	S REPAIR=Y
	W !
	Q
	;
