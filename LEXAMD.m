LEXAMD	;ISL/KER - Look-up Modifiers ;04/21/2014
	;;2.0;LEXICON UTILITY;**6,25,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXFND"       SACC 2.3.2.5.1
	;    ^TMP("LEXHIT"       SACC 2.3.2.5.1
	;    ^TMP("LEXSCH"       SACC 2.3.2.5.1
	;               
	; External References
	;    $$UP^XLFSTR         ICR  10104
	;               
	; LEXX     IEN file 757.01 of an expression w/Modifiers
	; LEXVDT   Date to screen against
	;
EN(LEXX,LEXVDT)	; Look-up Modifiers
	S LEXX=+($G(LEXX)) Q:+($G(^TMP("LEXSCH",$J,"MOD",0)))=0
	Q:+($G(LEXX))'>2  Q:'$D(^LEX(757.01,+($G(LEXX)),0))
	Q:+($P($G(^LEX(757.01,+LEXX,1)),"^",6))=0
	Q:'$D(^LEX(757.01,"APAR",LEXX))  N LEXXN D ARY
	Q
ARY	; Build Array of Modified Terms
	N LEXLVL,LEXO,LEXI,LEXN,LEXA,LEXT,LEXDSP,LEXDES,LEXL
	S LEXI=0,LEXXN=$G(^LEX(757.01,LEXX,0)),LEXA(0)=1
	S LEXA(1,LEXX)=LEXXN,LEXLVL=+($G(LEX("LVL"))) S:LEXLVL=0 LEXLVL=1
	F  S LEXI=$O(^LEX(757.01,"APAR",LEXX,LEXI)) Q:+LEXI=0  D
	. S LEXN=$G(^LEX(757.01,LEXI,1)) Q:LEXN=""  S LEXT=+($P(LEXN,"^",2)) Q:LEXT'=7
	. S LEXO=+($P(LEXN,"^",10)) S:LEXO'=0 LEXO=LEXO+1 S:LEXO=0 LEXO=99999 I $D(LEXA(LEXO)) F  Q:'$D(LEXA(LEXO))  S LEXO=LEXO+1
	. S LEXA(LEXO,LEXI)=$G(^LEX(757.01,LEXI,0)),LEXA(0)=+($G(LEXA(0)))+1
	; Quit if no Modified Terms Found
	Q:+($G(LEXA(0)))'>1  S (LEXO,LEXI)=0 D FND
	Q
FND	; Build List of Modifiers Found (LEXFND)
	K ^TMP("LEXSCH",$J,"EXM"),^TMP("LEXSCH",$J,"NAR"),^TMP("LEXSCH",$J,"SCH"),^TMP("LEXSCH",$J,"TOL"),^TMP("LEXSCH",$J,"NUM"),^TMP("LEXFND",$J)
	F  S LEXO=$O(LEXA(LEXO)) Q:+LEXO=0  D
	. S LEXI=0 F  S LEXI=$O(LEXA(LEXO,LEXI)) Q:+LEXI=0  D
	. . I LEXO=1 S LEXDES=$$DES(LEXI),LEXDSP=$$SO^LEXASO(LEXI,$G(LEXSHOW),1,$G(LEXVDT))
	. . I LEXO>1 S (LEXDES,LEXDSP)=""
	. . S LEXT=$G(LEXA(LEXO,LEXI)) Q:'$L(LEXT)
	. . S:$L(LEXDES) LEXT=LEXT_" "_LEXDES
	. . S:$L(LEXDSP) LEXT=LEXT_" "_LEXDSP
	. . S LEXN=-999999999+($G(LEXO))
	. . S ^TMP("LEXFND",$J,LEXN,LEXI)=LEXT
	. . S ^TMP("LEXSCH",$J,"NUM",0)=$G(^TMP("LEXSCH",$J,"NUM",0))+1
HIT	; Build HIT list
	I $D(^TMP("LEXFND",$J)) D  Q
	. K LEX,^TMP("LEXHIT",$J)
	. S LEX=+($G(LEXA(0)))
	. S LEX("LVL")=+($G(LEXLVL))+1
	. I +LEX>0 D
	. . N LEXMAT S LEXMAT=+LEX_" match"_$S(+LEX>1:"es",1:"")_" found for """_LEXXN_""""
	. . S:$$UP^XLFSTR($G(LEXSUG))["SUGGEST" LEXMAT=+LEX_" suggestion"_$S(+LEX>1:"s",1:"")_" found for """_LEXXN_""""
	. . S (^TMP("LEXSCH",$J,"MAT",0),LEX("MAT"))=LEXMAT D SCH,BEG,NAR N LEXSUG
	I '$D(^TMP("LEXFND",$J)) D NOM
	Q
SCH	; Search Conditions/Results
	K ^TMP("LEXSCH",$J,"EXM")
	S ^TMP("LEXSCH",$J,"NAR",0)=$$UP(LEXXN)
	S ^TMP("LEXSCH",$J,"SCH",0)=$$UP(LEXXN)
	S ^TMP("LEXSCH",$J,"TOL",0)=1
	S ^TMP("LEXSCH",$J,"NUM",0)=+($G(^TMP("LEXSCH",$J,"NUM",0)))
	Q
NOM	; No Modifiers
	K LEX,^TMP("LEXFND",$J),^TMP("LEXHIT",$J),^TMP("LEXSCH",$J,"EXM"),^TMP("LEXSCH",$J,"NAR"),^TMP("LEXSCH",$J,"SCH"),^TMP("LEXSCH",$J,"TOL")
	S ^TMP("LEXSCH",$J,"NUM",0)=0 S:$L($G(LEXXN)) ^TMP("LEXSCH",$J,"NAR",0)=$$UP(LEXXN) S:$L($G(LEXXN)) ^TMP("LEXSCH",$J,"SCH",0)=$$UP(LEXXN)
	Q
NAR	; Narrative
	S:+($G(^TMP("LEXSCH",$J,"UNR",0)))>0&($L($G(^TMP("LEXSCH",$J,"NAR",0)))) LEX("NAR")=$G(^TMP("LEXSCH",$J,"NAR",0))
	Q
DES(LEXX)	; Get description flag
	N LEXDES,LEXE,LEXM S LEXDES="",LEXE=+LEXX
	S LEXM=$P($G(^LEX(757.01,+($G(LEXX)),1)),"^",1),LEXM=+($G(^LEX(757,+($G(LEXM)),0))) S:$D(^LEX(757.01,LEXM,3)) LEXDES="*" S LEXX=$G(LEXDES) Q LEXX
BEG	; Begin List
	S:+($G(^TMP("LEXSCH",$J,"UNR",0)))>0&($L($G(^TMP("LEXSCH",$J,"NAR",0)))) LEX("NAR")=$G(^TMP("LEXSCH",$J,"NAR",0))
	Q:'$D(^TMP("LEXFND",$J))
	N LEXRL,LEXJ,LEXI,LEXA,LEXSTR,LEXDP,LEXLL
	S LEXRL=0,LEXLL=+($G(^TMP("LEXSCH",$J,"LEN",0)))
	S:+LEXLL=0 (LEXRL,LEXLL)=5 S LEXJ=0,LEXI=-9999999999
	; Hit List      ^TMP("LEXHIT",$J,#)
	F  S LEXI=$O(^TMP("LEXFND",$J,LEXI)) Q:+LEXI=0  D
	. S LEXA=0
	. F  S LEXA=$O(^TMP("LEXFND",$J,LEXI,LEXA)) Q:+LEXA=0!(LEXJ=LEXLL)  D  Q:+LEXA=0!(LEXJ=LEXLL)
	. . S LEXJ=LEXJ+1,LEXDP=^TMP("LEXFND",$J,LEXI,LEXA)
	. . S ^TMP("LEXHIT",$J,0)=LEXJ
	. . S ^TMP("LEXHIT",$J,LEXJ)=LEXA_"^"_LEXDP
	. . S:+($G(^TMP("LEXSCH",$J,"EXM",0)))=+LEXA ^TMP("LEXSCH",$J,"EXM",2)=LEXJ_"^"_$G(^LEX(757.01,+LEXA,0))
	. . S:+($G(^TMP("LEXSCH",$J,"EXC",0)))=+LEXA ^TMP("LEXSCH",$J,"EXC",2)=LEXJ_"^"_$G(^LEX(757.01,+LEXA,0))
	. . K ^TMP("LEXFND",$J,LEXI,LEXA)
	; List          LEX("LIST")
	I $D(^TMP("LEXSCH",$J,"NUM",0)) S LEX=+($G(^TMP("LEXSCH",$J,"NUM",0)))
	I LEXLL>0 D
	. N LEXI,LEXJ S (LEXJ,LEXI)=0
	. F  S LEXJ=$O(^TMP("LEXHIT",$J,LEXJ)) Q:+LEXJ=0!(+LEXI=LEXLL)  D  Q:+LEXI=LEXLL
	. . S LEXI=LEXI+1,LEX("LIST",LEXI)=^TMP("LEXHIT",$J,LEXJ)
	. . S LEX("LIST",0)=LEXI_"^"_LEXI
	. . S (LEX("MAX"),^TMP("LEXSCH",$J,"LST",0))=LEXI
	S ^TMP("LEXSCH",$J,"TOL",0)=0 S:$D(LEX("LIST",1)) ^TMP("LEXSCH",$J,"TOL",0)=1
	S LEX=+($G(^TMP("LEXSCH",$J,"NUM",0)))
	S:^TMP("LEXSCH",$J,"TOL",0)=1&(+($G(LEX))>0) LEX("MAT")=+LEX_" match"_$S(+LEX>1:"es",1:"")_" found"
	S:+($G(LEX("MAX")))>0 LEX("MIN")=1
	I $L($G(^TMP("LEXSCH",$J,"EXM",2))) S LEX("EXM")=^TMP("LEXSCH",$J,"EXM",2)
	I $L($G(^TMP("LEXSCH",$J,"EXC",2))) S LEX("EXC")=^TMP("LEXSCH",$J,"EXC",2)
	S:+($G(^TMP("LEXSCH",$J,"UNR",0)))>0&($L($G(^TMP("LEXSCH",$J,"NAR",0)))) LEX("NAR")=$G(^TMP("LEXSCH",$J,"NAR",0))
	Q:'$D(^TMP("LEXFND",$J))  K:+($G(LEXRL))>0 LEXLL
	Q
UP(X)	Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
CLR	K X,Y,LEXLL,LEXSHOW,LEX,^TMP("LEXSCH"),^TMP("LEXHIT"),^TMP("LEXFND") Q
