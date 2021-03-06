LEXDDTF	;ISL/KER - Display Defaults - Filter ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    None
	;               
	; External References
	;    None
	;               
SC	; Filter by Semantic Classifications
	; Required LEXDICS in the format I $$SC^LEXU...
	N LEXTC,LEXTCTR,LEXTI,LEXTIC,LEXTIE,LEXTSTR
	Q:'$L($G(LEXDICS))  Q:LEXDICS'["$$SC^LEXU"
	S LEX=$TR($P($P(LEXDICS,"Y,",2),")",1),"""","")
	S LEXTCTR=0,LEX("I")=$P(LEX,";",1)
	S LEX("E")=$P(LEX,";",2),LEX("L")=$P(LEX,";",3)
	S LEX("I","H")="Include expressions which relate to",LEXTCTR=0
	N LEXTIC,LEXTIE,LEXTI F LEXTI=1:1:$L(LEX("I"),"/") D
	. S LEXTIC=$P(LEX("I"),"/",LEXTI) Q:LEXTIC="UNK"
	. S LEXTCTR=LEXTCTR+1,LEX("I",LEXTCTR)=$$SN(LEXTIC)
	S LEX("I",0)=LEXTCTR
	S LEX("E","H")="Exclude expressions which relate to",LEXTCTR=0
	F LEXTI=1:1:$L(LEX("E"),"/") D
	. S LEXTIC=$P(LEX("E"),"/",LEXTI) Q:LEXTIC="UNK"
	. S LEXTCTR=LEXTCTR+1,LEX("E",LEXTCTR)=$$SN(LEXTIC)
	S LEX("E",0)=LEXTCTR
	S LEX("L","H")="Also include expressions which are linked to"
	S LEX("L","T")="coding system",LEXTCTR=0
	F LEXTI=1:1:$L(LEX("L"),"/") D
	. S LEXTIC=$P(LEX("L"),"/",LEXTI) Q:LEXTIC="UND"  S LEXTCTR=LEXTCTR+1,LEX("L",LEXTCTR)=$$CN(LEXTIC)
	S:LEXTCTR>1 LEX("L","T")=LEX("L","T")_"s"
	S LEX("L","T")=LEX("L","T")_"."
	S LEX("L",0)=LEXTCTR
	S:'$D(LEXSTLN) LEXSTLN=56 K LEX("T") S LEXTCTR=0 N LEXT,LEXTSTR
	D:$G(LEX("I",0)) INC
	D:$G(LEX("E",0)) EXC
	D:$G(LEX("L",0)) LNK
	D EOC^LEXDDT2
	Q
SO	; Filter by Sources
	; Required LEXDICS in the format I $$SO^LEXU...
	N LEXTC,LEXTCTR,LEXTI,LEXTIC,LEXTIE,LEXTSTR
	Q:'$L($G(LEXDICS))  Q:LEXDICS'["$$SO^LEXU"
	S LEX=$TR($P($P(LEXDICS,"Y,",2),")",1),"""","")
	S LEXTCTR=0,LEX("L")=LEX
	S LEX("L","H")="Include expressions which are linked to"
	S LEX("L","T")="coding system",LEXTCTR=0
	F LEXTI=1:1:$L(LEX("L"),"/") D
	. S LEXTIC=$P(LEX("L"),"/",LEXTI) Q:LEXTIC="UND"  S LEXTCTR=LEXTCTR+1,LEX("L",LEXTCTR)=$$CN(LEXTIC)
	S:LEXTCTR>1 LEX("L","T")=LEX("L","T")_"s"
	S LEX("L","T")=LEX("L","T")_"."
	S LEX("L",0)=LEXTCTR
	S:'$D(LEXSTLN) LEXSTLN=56 K LEX("T") S LEXTCTR=0 N LEXT,LEXTSTR
	S LEXTSTR="" D:$G(LEX("L",0)) LNK
	D EOC^LEXDDT2
	Q
INC	; Inclusion Data Elements
	S LEXTSTR="",LEXT="I",LEXTCTR=0 D CONCAT^LEXDDT2 K LEX("I")
	Q
EXC	; Exclusion Data Elements
	S LEXT="E",LEXTCTR=+($G(LEX(0)))
	I $D(LEXTSTR) D
	. S:$E(LEXTSTR,$L(LEXTSTR))["," LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1))
	. I $L(LEXTSTR)'>(LEXSTLN+2) S LEXTSTR=LEXTSTR_" " Q
	. D SET^LEXDDT2
	. S LEXTSTR=""
	D CONCAT^LEXDDT2  K LEX("E")
	Q
LNK	; Linked Sources Data Elements
	S LEXT="L",LEXTCTR=+($G(LEX(0)))
	I $D(LEXTSTR) D
	. S:$E(LEXTSTR,$L(LEXTSTR))["," LEXTSTR=$E(LEXTSTR,1,($L(LEXTSTR)-1))
	. I $L(LEXTSTR)'>(LEXSTLN+2) S LEXTSTR=LEXTSTR_"  " Q
	. D SET^LEXDDT2
	. S LEXTSTR=""
	D CONCAT^LEXDDT2  K LEX("L")
	Q
SN(LEXSTR)	; Get Semantic Data Element Name
	N LEXTEMP S LEXTEMP=LEXSTR I LEXTEMP?3U D
	. S LEXSTR=$O(^LEX(757.11,"B",LEXTEMP,0)) S:+LEXSTR=0 LEXSTR=""
	. S:+LEXSTR>0 LEXSTR=$P($G(^LEX(757.11,+LEXSTR,0)),"^",2)
	I LEXTEMP?1N.N D
	. S LEXSTR=+LEXTEMP
	. S LEXSTR=$S($D(^LEX(757.12,LEXSTR,0)):$P($G(^LEX(757.12,LEXSTR,0)),"^",2),1:"")
	Q LEXSTR
CN(LEXSTR)	; Get Classification System Data Element Name
	N LEXTEMP,LEXTC S LEXTC=LEXSTR,LEXTEMP=$E(LEXSTR,1,2)_$C($A($E(LEXSTR,3))-1)_"~"
	S LEXSTR=""
	F  S LEXTEMP=$O(^LEX(757.03,"B",LEXTEMP)) Q:LEXTEMP=""!(LEXSTR'="")  D  Q:LEXTEMP=""!(LEXSTR'="")
	. I LEXTEMP[LEXTC S LEXSTR=$O(^LEX(757.03,"B",LEXTEMP,0))
	S LEXSTR=+LEXSTR S:LEXSTR=0 LEXSTR=""
	I +LEXSTR>0,$D(^LEX(757.03,+LEXSTR)) S LEXSTR=$P($G(^LEX(757.03,+LEXSTR,0)),"^",2)
	Q LEXSTR
