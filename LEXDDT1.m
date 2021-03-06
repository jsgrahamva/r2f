LEXDDT1	;ISL/KER - Display Defaults - Translate String ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    None
	;               
	; External References
	;    None
	;               
EN	; String Type
	K LEX,LEXTSTR I '$D(LEXSTLN) S LEXSTLN=56
	I $L($G(LEXDICS)),'$L($G(LEXSHOW)),'$L($G(LEXSUB)) D DICS G EXIT
	I '$L($G(LEXDICS)),'$L($G(LEXSUB)),$L($G(LEXSHOW)) D SHOW G EXIT
	I $L($G(LEXSUB)),'$L($G(LEXSHOW)) D SUB
	G EXIT
	Q
DICS	;        Filter String              LEXDICS
	N LEXTRTN S LEXTRTN=""
	I LEXDICS="I 1" S LEX(0)=1,LEX=LEXDICS,LEX(1)="Unfiltered" Q
	S:LEXDICS["$$SC^" LEXTRTN="SC^LEXDDTF"
	S:LEXDICS["$$SO^" LEXTRTN="SO^LEXDDTF"
	Q:$G(LEXTRTN)=""
	D @LEXTRTN
	Q
SUB	;        Sub-Set String             LEXSUB
	K LEX S LEX=LEXSUB D ^LEXDDTV
	Q
SHOW	;        Display Codes String       LEXSHOW
	K LEX S LEX=LEXSHOW D ^LEXDDTD
	Q
CON	;        Shortcut Context            LEXCTX
	K LEX S LEX=LEXCTX D ^LEXDDTC
	Q
	; Values
VV	;        Vocabulary Value
	Q:'$L($G(LEXSUB))  K LEX S:'$D(LEXSTLN) LEXSTLN=56
	S LEX(0)=1,LEX(1)="Value:  "_LEXSUB
	Q
FV	;        Filter Value
	Q:'$L($G(LEXDICS))  K LEX  S:'$D(LEXSTLN) LEXSTLN=56
	N LEXTSTR,LEXTCTR S LEXTCTR=0,LEXTSTR="Value:  "_LEXDICS
	F  Q:$L(LEXTSTR)'>LEXSTLN  D CONV
	I $L(LEXTSTR) S LEXTCTR=LEXTCTR+1 S LEX(LEXTCTR)=LEXTSTR,LEX(0)=LEXTCTR
	Q
DV	;        Display Value
	Q:'$L($G(LEXSHOW))  K LEX  S:'$D(LEXSTLN) LEXSTLN=56
	N LEXTSTR,LEXTCTR S LEXTCTR=0,LEXTSTR="Value:  "_LEXSHOW
	F  Q:$L(LEXTSTR)'>LEXSTLN  D CONV
	I $L(LEXTSTR) S LEXTCTR=LEXTCTR+1 S LEX(LEXTCTR)=LEXTSTR,LEX(0)=LEXTCTR
	Q
CV	;        Vocabulary Value
	Q:'$L($G(LEXCTX))  K LEX S:'$D(LEXSTLN) LEXSTLN=56
	S LEX(0)=1,LEX(1)="Value:  "_LEXCTX
	Q
CONV	;        Concatenate VALUE
	N LEXTPSN S LEXTPSN=LEXSTLN
	F LEXTPSN=LEXSTLN:-1:1 Q:$E(LEXTSTR,LEXTPSN)="/"!($E(LEXTSTR,LEXTPSN)=";")
	I $E(LEXTSTR,LEXTPSN)="/" D
	. S LEXTCTR=LEXTCTR+1 S LEX(LEXTCTR)=$E(LEXTSTR,1,LEXTPSN),LEX(0)=LEXTCTR
	. S LEXTSTR=$E(LEXTSTR,(LEXTPSN+1),$L(LEXTSTR))
	Q
EXIT	; Kill all but the array LEX and the Default Variable
	K LEXSTLN
	Q
