LEXDDTC	;ISL/KER - Display Defaults - Shortcut Context ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(757.41)        N/A
	;               
	; External References
	;    None
	;               
CON	; Shortcut Context
	; Required LEXCTX
	N LEXTCTR,LEXTD,LEXTI,LEXTIC,LEXTL,LEXTN,LEXTSTR,LEXT,LEXTV
	K LEX Q:'$L($G(LEXCTX))  S LEXCTX=+LEXCTX
	Q:LEXCTX'>0  Q:'$D(^LEX(757.41,LEXCTX))
	S LEX=LEXCTX S:'$D(LEXSTLN) LEXSTLN=56
	S LEXTI=0,(LEXTIC,LEXTN,LEXTV,LEXTD)="" D INT
	K:LEXSTLN=56 LEXSTLN Q
INT	; Interpret string
	; LEXCTX
	S LEXTIC=1
	S LEXTN=LEXTN_$P($G(^LEX(757.41,+LEXCTX,0)),"^",1)
	S LEXTN=LEXTN_" shortcut set"
	;     Build temporary phrase
	S LEX("V",1)="Use the "_LEXTN
	;     Process phrase 
	S LEX("V",0)=1,LEXT="V",LEXTCTR=0,LEXTSTR=""
	D CONCAT^LEXDDT2 K LEX("V")
	I $E(LEXTSTR,$L(LEXTSTR))?1P S LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1))
	I $E(LEXTSTR,$L(LEXTSTR))?1P S LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1))
	D EOC^LEXDDT2
	Q
