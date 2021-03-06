LEXSC	;ISL/KER - Shortcuts Add/Delete ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(757.4)         N/A
	;    ^LEX(757.41)        N/A
	;               
	; External References
	;    $$UP^XLFSTR         ICR  10103
	;               
EN	N LEXCX,LEXCXN,LEXDICS,LEXEDIT,LEXRP,LEXE
CTX	S LEXRP="",LEXEDIT=1,LEXE=$$CNT^LEXDCXS,LEXCX=$$EN^LEXDCXS
	S LEXCXN=$P(LEXCX,"^",2),LEXCX=+LEXCX Q:LEXCX=0
	W !! W:LEXCX>0 "Edit shortcuts for:  ",$P($G(^LEX(757.41,LEXCX,0)),"^",1),!
	S:$L($G(^LEX(757.41,LEXCX,2))) LEXDICS=^LEX(757.41,LEXCX,2)
	F  D EDIT Q:LEXRP[U
	G:LEXRP[U&(LEXRP'["^^")&(+($G(LEXE))>1) CTX
	K LEXEDIT,LEXEND,LEXERM,LEXRP,LEXSC,LEXCX,LEX
	Q
EDIT	;
	S LEXSC=$$SC^LEXSC2 Q:LEXRP[U  S LEXSC=$$UP^XLFSTR(LEXSC)
	I '$L($G(LEXSC))!('$L($G(LEXCX))) S LEXRP=U Q
	I $D(^LEX(757.4,"ARA",LEXSC,LEXCX)) D FND Q
	D ADD^LEXSC3
	Q
FND	;
	N LEXDEL,LEXERM,LEXSTR S LEXERM=$O(^LEX(757.4,"ARA",LEXSC,LEXCX,0))
	S LEXERM=+LEXERM S:LEXERM>0 LEXERM=+($G(^LEX(757.4,LEXERM,0)))
	S LEXERM=$S(+LEXERM=0:"",1:$G(^LEX(757.01,LEXERM,0)))
	S LEXSTR=""""_LEXSC_""" already exist as a shortcut "
	S LEXSTR=LEXSTR_"(in the context of "_LEXCXN_")"
	S:LEXERM'="" LEXSTR=LEXSTR_" pointing to the term """_LEXERM_""""
	D WRT^LEXSC2(LEXSTR)
	S LEXDEL=$$DELOK^LEXSC2 I +LEXDEL>0 D DELS^LEXSC3
	I '$D(^LEX(757.4,"ARA",LEXSC,LEXCX)) D ADD^LEXSC3
	Q
