LRPX	;SLC/STAFF - Process lab indexes ;9/26/03  15:39
	;;5.2;LAB SERVICE;**295,445**;Sep 27, 1994;Build 6
	;
	;
CHKILL(LRDFN,LRIDT)	; from LROC
	; delete Chem xrefs in ^PXRMINDX(63
	N DAS,DATE,DFN,LRDN,OK,TEST
	I '$L($G(^LR(+$G(LRDFN),"CH",+$G(LRIDT),0))) Q
	D PATIENT(LRDFN,.DFN,.OK) I 'OK Q
	S DATE=9999999-LRIDT
	S LRDN=1
	F  S LRDN=$O(^LR(LRDFN,"CH",LRIDT,LRDN)) Q:LRDN<1  D
	. D TESTS(LRDFN,LRIDT,LRDN,.TEST)
	. S DAS=LRDFN_";CH;"_LRIDT_";"_LRDN
	. D KLAB(DFN,DATE,TEST,DAS)
	. ; D TIMESTMP^LRLOG(DFN,"CH",DATE,DUZ) *** future use ***
	Q
	;
CHSET(LRDFN,LRIDT)	; from LRVER3A
	; add Chem xrefs in ^PXRMINDX(63
	N DAS,DATE,DFN,LRDN,OK,TEST
	I '$P($G(^LR(+$G(LRDFN),"CH",+$G(LRIDT),0)),U,3) Q
	D PATIENT(LRDFN,.DFN,.OK) I 'OK Q
	S DATE=9999999-LRIDT
	S LRDN=1
	F  S LRDN=$O(^LR(LRDFN,"CH",LRIDT,LRDN)) Q:LRDN<1  D
	. D TESTS(LRDFN,LRIDT,LRDN,.TEST)
	. S DAS=LRDFN_";CH;"_LRIDT_";"_LRDN
	. D SLAB(DFN,DATE,TEST,DAS)
	. ; D TIMESTMP^LRLOG(DFN,"CH",DATE,DUZ) *** future use ***
	Q
	;
PATIENT(LRDFN,DFN,OK)	;
	N ZERO
	S OK=1
	I '$G(LRDFN) S OK=0 Q
	S ZERO=$G(^LR(LRDFN,0))
	I $P(ZERO,U,2)'=2 S OK=0 Q
	S DFN=+$P(ZERO,U,3)
	I LRDFN'=$$LRDFN^LRPXAPIU(DFN) S OK=0
	Q
	;
TESTS(LRDFN,LRIDT,LRDN,TEST)	;
	N DATA
	S DATA=^LR(LRDFN,"CH",LRIDT,LRDN)
	S TEST=+$P($P(DATA,U,3),"!",7)
	I 'TEST S TEST=+$O(^LAB(60,"C","CH;"_LRDN_";1",0))
	Q
	;
	; ------------- Lab Use Only ------------
	;
KLAB(DFN,DATE,ITEM,NODE)	; from LRPXRM
	; delete index for lab data.
	K ^PXRMINDX(63,"PI",DFN,ITEM,DATE,NODE) ; dbia 4114
	K ^PXRMINDX(63,"IP",ITEM,DFN,DATE,NODE) ; dbia 4114
	I ITEM=+ITEM Q
	K ^PXRMINDX(63,"PDI",DFN,DATE,ITEM,NODE) ; dbia 4114
	Q
	;
SLAB(DFN,DATE,ITEM,NODE)	; from LRPXRM, LRPXSXRA, LRPXSXRB, LRPXSXRL
	; set index for lab data.
	S ^PXRMINDX(63,"PI",DFN,ITEM,DATE,NODE)="" ; dbia 4114
	S ^PXRMINDX(63,"IP",ITEM,DFN,DATE,NODE)="" ; dbia 4114
	I ITEM=+ITEM Q
	S ^PXRMINDX(63,"PDI",DFN,DATE,ITEM,NODE)="" ; dbia 4114
	Q
	;
