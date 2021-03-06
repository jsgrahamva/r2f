LEXDDT2	;ISL/KER - Display Defaults - Concatenate Text ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    None
	;               
	; External References
	;    None
	;               
CONCAT	; Concatenation of Data Elements
	N LEXTI,LEXTL,LEXTP
PHRASE	; Get Phrase and Parse into Words
	I $D(LEX(LEXT,"H")) S LEXTP=LEX(LEXT,"H"),LEXTI=0 D WORD
	F LEXTI=1:1:LEX(LEXT,0) D
	. S LEXTP=LEX(LEXT,LEXTI)
	. S:LEXTP["/" LEXTP=$P(LEXTP,"/",1)_" or "_$P(LEXTP,"/",2),LEXTP=$$TRIM(LEXTP)
	. I LEXTI=LEX(LEXT,0),LEX(LEXT,0)>1 D
	. . S LEXTP="and "_LEXTP_"."
	. . S:$E(LEXTSTR,$L(LEXTSTR))["," LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1))
	. I LEXTI=LEX(LEXT,0),LEX(LEXT,0)'>1 D
	. . S LEXTP=LEXTP_"."
	. . S:$E(LEXTSTR,$L(LEXTSTR))["," LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1))
	. D WORD I $L(LEXTSTR)>LEXSTLN D SET S LEXTSTR=""
	I $D(LEX(LEXT,"T")) D
	. F  Q:$E(LEXTSTR,$L(LEXTSTR))'?1P  S LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1)) Q:$E(LEXTSTR,$L(LEXTSTR))'?1P 
	. S LEXTP=LEX(LEXT,"T"),LEXTI=0 D WORD
	S LEXTSTR=$$TRIM(LEXTSTR)
	Q
WORD	; Concatenate Word
	N LEXTW,LEXTD F LEXTD=1:1:$L(LEXTP," ") D
	. S LEXTW=$P(LEXTP," ",LEXTD),LEXTW=$$TRIM(LEXTW)
	. I LEXTD=$L(LEXTP," "),LEXTI>0 S LEXTW=LEXTW_","
	. I ($L(LEXTSTR)+$L(LEXTW)+1)'>LEXSTLN D  Q
	. . S LEXTSTR=LEXTSTR_" "_LEXTW
	. I ($L(LEXTSTR)+$L(LEXTW)+1)>LEXSTLN D
	. . D SET S LEXTSTR=LEXTW
	Q
EOC	; End of Concatenation
	F  Q:$E(LEXTSTR,$L(LEXTSTR))'=","  S LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1)) Q:$E(LEXTSTR,$L(LEXTSTR))'=","
	D SET
	Q
SET	; Set Array Node
	S LEXTCTR=LEXTCTR+1 S LEX(LEXTCTR)=$$TRIM(LEXTSTR),LEX(0)=LEXTCTR
	Q
TRIM(X)	; Remove Spaces
	F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1)) Q:$E(X,$L(X))'=" "
	F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X)) Q:$E(X,1)'=" "
	Q X
