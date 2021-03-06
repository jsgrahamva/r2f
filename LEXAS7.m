LEXAS7	;ISL/KER - Look-up Check Input (LC,TC) ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;
LC(LEXX)	; Leading characters
	;
	; LEXX    Return string
	; LEXL    Letter
	; LEXG    Group of letters
	; LEXI    Incremental counter
	; LEXT    Temporary tolken
	; LEXOK   Flag - found tolken
	; LEXS    Swap character
	; LEXA    Add character
	;
	N LEXT
	S LEXT=$$LCS(LEXX) I LEXT'=LEXX,$D(^LEX(757.01,"ASL",LEXT)) S LEXX=LEXT Q LEXT
	I $L(LEXT)'>5 Q LEXX
	S LEXT=$$LCR(LEXX) I $D(^LEX(757.01,"AWRD",LEXT)) S LEXX=LEXT Q LEXX
	I $L(LEXT)'>4 Q LEXX
	S LEXT=$$LCR(LEXX) I $D(^LEX(757.01,"AWRD",LEXT)) S LEXX=LEXT Q LEXX
	Q LEXX
	;
LCS(LEXX)	; Swap
	N LEXI,LEXF,LEXL,LEXG,LEXOK,LEXS,LEXA S LEXOK=0
	S LEXF=$$FIRST(LEXX),LEXS=$$SECOND(LEXX)
	I $D(^LEX(757.01,"ASL",LEXS)) S LEXX=LEXS Q LEXX
	I $D(^LEX(757.01,"ASL",LEXF)) S LEXX=LEXF Q LEXX
	S LEXF=$$FIRST(LEXS)
	I $D(^LEX(757.01,"ASL",LEXF)) S LEXX=LEXF Q LEXX
	Q LEXX
LCR(LEXX)	; Remove/Shift
	N LEXT
	S LEXX=$E(LEXX,2,$L(LEXX))
	S LEXT=$$SHIFT^LEXAS3(LEXX)
	I $D(^LEX(757.01,"ASL",LEXT)) S LEXX=LEXT Q LEXX
	Q LEXX
SECOND(LEXX)	; Second letter (Swap)
	N LEXL,LEXG,LEXOK,LEXI,LEXA,LEXS
	S LEXL=$E(LEXX,2),LEXG=$$GRP(LEXL),LEXOK=0
	F LEXI=1:1:$L(LEXG)  D  Q:LEXOK
	. S LEXS=$E(LEXX,1)_$E(LEXG,LEXI)_$E(LEXX,3,$L(LEXX))
	. I $D(^LEX(757.01,"ASL",LEXS)) S LEXX=LEXS,LEXOK=1 Q
	. S LEXS=$$TP^LEXAS6(LEXS)
	. I $D(^LEX(757.01,"ASL",LEXS)),$L(LEXS)=$L(LEXX) S LEXX=LEXS,LEXOK=1 Q
	. S LEXS=$$ONE^LEXAS2(LEXS) Q:LEXS=""
	. I $D(^LEX(757.01,"ASL",LEXS)),$L(LEXS)=$L(LEXX) S LEXX=LEXS,LEXOK=1 Q
	Q:LEXOK LEXX
	; Second letter (Add)
	S LEXOK=0 F LEXI=65:1:90 D  Q:LEXOK
	. S LEXA=$E(LEXX,1)_$C(LEXI)_$E(LEXX,2,$L(LEXX))
	. I $D(^LEX(757.01,"ASL",LEXA)) S LEXX=LEXA,LEXOK=1 Q
	Q LEXX
	;
FIRST(LEXX)	; First letter (Swap)
	N LEXL,LEXG,LEXOK,LEXI,LEXA,LEXS
	S LEXL=$E(LEXX,1),LEXG=$$GRP(LEXL),LEXOK=0
	F LEXI=1:1:$L(LEXG)  D  Q:LEXOK
	. S LEXS=$E(LEXG,LEXI)_$E(LEXX,2,$L(LEXX))
	. I $D(^LEX(757.01,"ASL",LEXS)) S LEXX=LEXS,LEXOK=1 Q
	. S LEXS=$$LF(LEXS)
	. I $D(^LEX(757.01,"ASL",LEXS)) S LEXX=LEXS,LEXOK=1 Q
	Q:LEXOK LEXX
	;
	; First letter (Add)
	S LEXOK=0 F LEXI=65:1:90 D  Q:LEXOK
	. S LEXA=$C(LEXI)_LEXX
	. I $D(^LEX(757.01,"ASL",LEXA)) S LEXX=LEXA,LEXOK=1 Q
	Q LEXX
LF(LEXX)	;
	Q:$L($G(LEXX))'>7 LEXX
	N LEXN,LEXC,LEXT,LEXF,LEXO,LEXOK
	S (LEXN,LEXC)=$E(LEXX,1,4) Q:'$D(^LEX(757.01,"ASL",LEXN)) LEXX
	S LEXT=$P(LEXX,LEXN,2) Q:$L(LEXT)<4 LEXX
	S LEXOK=0,LEXO=$$SCH^LEXAS6(LEXN)
	S LEXT=$E(LEXT,($L(LEXT)-6),$L(LEXT))
	F  S LEXO=$O(^LEX(757.01,"AWRD",LEXO)) Q:LEXO=""!(LEXO'[LEXC)!(LEXOK)  D
	. S LEXF=$E(LEXO,($L(LEXO)-($L(LEXT)-1)),$L(LEXO))
	. I LEXF=LEXT S LEXT=LEXO,LEXOK=1
	I LEXOK S LEXX=LEXT
	Q LEXX
TC(LEXX)	; Trailing character
	Q:$L(LEXX)<6 LEXX
	N LEXC,LEXT,LEXLC,LEXO,LEXOK,LEXCL
	S LEXCL=$L(LEXX),LEXC=$$TRIM^LEXAS6(LEXX),LEXC=$E(LEXC,1,($L(LEXC)-1))
	S LEXLC=$E(LEXX,$L(LEXX)),LEXO=$$SCH^LEXAS6(LEXC),LEXOK=0,LEXT=""
	;
	F  S LEXO=$O(^LEX(757.01,"AWRD",LEXO)) Q:LEXO=""!(LEXO'[LEXC)!(LEXOK)  D
	. Q:$E(LEXO,$L(LEXO))'=LEXLC
	. ; Exact
	. I $E(LEXO,LEXCL)=LEXLC S LEXT=LEXO,LEXOK=1 Q
	. ; 1 Less
	. I $E(LEXO,(LEXCL-1))=LEXLC S LEXT=LEXO,LEXOK=1 Q
	I LEXT'="",LEXOK S LEXX=LEXT
	Q LEXX
	;
GRP(LEXX)	; Letter groups (off the home row QWERTY)
	N LEXG S LEXG=LEXX
	S:LEXX="A" LEXG="QZOWSX" S:LEXX="B" LEXG="VGHNF"
	S:LEXX="C" LEXG="XDVFS" S:LEXX="D" LEXG="ECXRFSWV"
	S:LEXX="E" LEXG="RWIDFS" S:LEXX="F" LEXG="GBVDRCET"
	S:LEXX="G" LEXG="FBTVRHYN" S:LEXX="H" LEXG="JGNYBUMT"
	S:LEXX="I" LEXG="UOYEKJL" S:LEXX="J" LEXG="HNKUMYI"
	S:LEXX="K" LEXG="IJLMOU" S:LEXX="L" LEXG="OKPI"
	S:LEXX="M" LEXG="NJKH" S:LEXX="N" LEXG="MBJH"
	S:LEXX="O" LEXG="LIPAK" S:LEXX="P" LEXG="OL"
	S:LEXX="Q" LEXG="AWS" S:LEXX="R" LEXG="TEGFD"
	S:LEXX="S" LEXG="XWADZE" S:LEXX="T" LEXG="RGFYH"
	S:LEXX="U" LEXG="YHIJK" S:LEXX="V" LEXG="CBFDG"
	S:LEXX="W" LEXG="QESAD" S:LEXX="X" LEXG="ZSACD"
	S:LEXX="Y" LEXG="UHIJGT" S:LEXX="Z" LEXG="ASX"
	S:LEXG'=LEXX LEXX=LEXG
	Q LEXX
	Q
