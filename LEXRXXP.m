LEXRXXP	;ISL/KER - Re-Index Parse ;04/21/2014
	;;2.0;LEXICON UTILITY;**81,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(               SACC 1.3
	;    ^LEX(757,           SACC 1.3
	;    ^LEX(757.01,        SACC 1.3 
	;    ^LEX(757.05,        SACC 1.3 
	;    ^TMP("LEXTKN")      SACC 2.3.2.5.1
	;    ^UTILITY($J         ICR  10011
	;               
	; External References
	;    ^DIWP               ICR  10011
	;    $$UP^XLFSTR         ICR  10104
	;               
	Q
AWRD(X,LEX1,LEXI)	;   Get Words
	N LEXEX,LEXE,LEXT,LEXMC,LEXMCE,LEXW K LEX1 S LEX1(0)=0 S LEXEX=+($G(X)) Q:+LEXEX'>0!('$D(^LEX(757.01,+LEXEX,0)))
	S LEXMC=+($G(^LEX(757.01,+LEXEX,1))),LEXMCE=$$MCE(LEXEX) Q:'$D(^LEX(757,+LEXMC,0))  Q:'$D(^LEX(757.01,+LEXMCE,0))
	S LEXE=0 F  S LEXE=$O(^LEX(757.01,"AMC",LEXMC,LEXE)) Q:+LEXE'>0  D
	. N LEX2,LEXT S LEXT=$P($G(^LEX(757.01,+LEXE,0)),"^",1)
	. D WORDS(LEXT,.LEX2) S LEXT="" F  S LEXT=$O(LEX2(LEXT)) Q:'$L(LEXT)  D
	. . S LEX1("W",LEXT,LEXMCE,LEXE)=""
	S LEX1(0)="Word^Major Concept Expression IEN^Expression IEN"
	Q
WORDS(X,LEXA)	;
	K LEXA N LEXIDX,LEXI1,LEXI2,LEX1,LEXW S X=$$UP^XLFSTR(X) S:+($G(LEXI))>0 LEXIDX="" K ^TMP("LEXTKN",$J) D PTX^LEXTOKN
	I $D(^TMP("LEXTKN",$J,0)),^TMP("LEXTKN",$J,0)>0 S LEXI1=0 F  S LEXI1=$O(^TMP("LEXTKN",$J,LEXI1)) Q:+LEXI1'>0  D
	. S LEXI2="" F LEXI2=$O(^TMP("LEXTKN",$J,LEXI1,LEXI2)) Q:'$L(LEXI2)  S LEXA(LEXI2)=""
	K ^TMP("LEXTKN",$J)
	Q 
SUP(X,LEX1,LEXI)	;   Get Supplemental Words
	N LEXEX,LEXE,LEXT,LEXMC,LEXMCE,LEXW K LEX1 S LEX1(0)=0 S LEXEX=+($G(X)) Q:+LEXEX'>0!('$D(^LEX(757.01,+LEXEX,0)))
	S LEXMC=+($G(^LEX(757.01,+LEXEX,1))),LEXMCE=$$MCE(LEXEX) Q:'$D(^LEX(757,+LEXMC,0))  Q:'$D(^LEX(757.01,+LEXMCE,0))
	S LEXE=0 F  S LEXE=$O(^LEX(757.01,LEXEX,5,LEXE)) Q:+LEXE'>0  D
	. N LEX2,LEXT S LEXT=$P($G(^LEX(757.01,LEXEX,5,+LEXE,0)),"^",1)
	. S:$L(LEXT) LEX1("S",LEXT,LEXEX,LEXMCE,+LEXE)=""
	S LEX1(0)="Word^Expression IEN^Major Concept Expression IEN"
	Q
LINK(X,LEX1)	;   Get Linked Words
	K LEX1 N LEXE,LEXEX,LEXMC,LEXMCE,LEXW,LEXTK,LEXB,LEXC,LEXI,LEXIEN S LEXEX=$G(X) Q:'$D(^LEX(757.01,+LEXEX,0))
	S LEXMC=+($P($G(^LEX(757.01,+LEXEX,1)),"^",1)) Q:'$D(^LEX(757,+LEXMC,0))  S LEXMCE=$$MCE(LEXEX) Q:'$D(^LEX(757.01,+LEXMCE,0))
	;       Physical
	D AWRD(LEXEX,.LEXW,0) S LEXE=0 F  S LEXE=$O(^LEX(757.01,LEXEX,5,LEXE)) Q:+LEXE'>0  D
	. N LEXT S LEXT=$P($G(^LEX(757.01,LEXEX,5,+LEXE,0)),"^",1) S:$L(LEXT) LEXW("W",LEXT,LEXEX,LEXMCE,+LEXE)=""
	S LEXB=$E($$UP^XLFSTR($P($G(^LEX(757.01,+LEXEX,0)),"^",1)),1,63)
	S LEXI=0 S:$L(LEXB) LEXI=$O(^LEX(757.05,"C",LEXB,0))
	S:+LEXI>0&($L(LEXB)) LEXW("W",LEXB,LEXEX,LEXMCE)=LEXI
	S LEXTK="" F  S LEXTK=$O(LEXW("W",LEXTK)) Q:'$L(LEXTK)  D
	. N LEXI,LEXIEN,LEXPH S LEXPH=$$UP^XLFSTR($E(LEXTK,1,40)),LEXIEN=+($G(LEXW("W",LEXTK,LEXEX,LEXMCE)))
	. S LEXI=0 F  S LEXI=$O(^LEX(757.05,"B",LEXPH,LEXI)) Q:+LEXI'>0  D
	. . N LEXT S LEXT="" S:+LEXI>0 LEXT=$P($G(^LEX(757.05,+LEXI,0)),"^",3)
	. . S:$L(LEXPH)&(+LEXI>0) LEX1("TXT",LEXPH)=LEXI,LEX1("IEN",+LEXI,LEXPH)=LEXT
	. . I $D(^LEX(757.05,+LEXI,1,"B",+LEXEX)),$L(LEXT) D
	. . . S LEX1(LEXT,LEXPH,LEXEX,"LINKED")=LEXI_"^"_$G(^LEX(757.05,+LEXI,0))
	. . . K:$L(LEXT) LEX1("IEN"),LEX1("TXT")
	. I LEXIEN>0 S LEXT=$P($G(^LEX(757.05,+LEXIEN,0)),"^",3) S:$L(LEXT) LEX1("TXT",$$UP^XLFSTR(LEXTK))=LEXIEN,LEX1("IEN",+LEXIEN,$$UP^XLFSTR(LEXTK))=LEXT
	;       Replacement
	S LEXI=0 F  S LEXI=$O(LEX1("IEN",LEXI)) Q:+LEXI'>0  D
	. N LEXPH S LEXPH="" F  S LEXPH=$O(LEX1("IEN",LEXI,LEXPH)) Q:'$L(LEXPH)  D
	. . N LEXT S LEXT=$G(LEX1("IEN",LEXI,LEXPH)) D:LEXT="R"
	. . . N LEXA,LEXB S X=LEXPH N LEXIDX D PTX^LEXTOKN
	. . . I $D(^TMP("LEXTKN",$J,0)),^TMP("LEXTKN",$J,0)>0 S LEXA=0 F  S LEXA=$O(^TMP("LEXTKN",$J,LEXA)) Q:+LEXA'>0  D
	. . . . N LEXB S LEXB="" F  S LEXB=$O(^TMP("LEXTKN",$J,LEXA,LEXB)) Q:'$L(LEXB)  D
	. . . . . N LEXMCE S LEXMCE=$$MCE(LEXEX)
	. . . . . S LEX1("IEN",LEXI,LEXPH,"W",LEXB)="",LEX1(LEXT,LEXB,LEXMCE,"LINKED")=LEXI_"^"_$G(^LEX(757.05,+LEXI,0))
	. . K:$L(LEXT) LEX1("IEN"),LEX1("TXT")
	Q
PR(LEX,X)	; Parse Array LEX in X Length Strings (default 79)
	N DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,LEXI,LEXLEN,LEXC K ^UTILITY($J,"W") Q:'$D(LEX)
	S LEXLEN=+($G(X)) S:+LEXLEN'>0 LEXLEN=79 S LEXC=+($G(LEX)) S:+($G(LEXC))'>0 LEXC=$O(LEX(" "),-1) Q:+LEXC'>0
	S DIWL=1,DIWF="C"_+LEXLEN S LEXI=0 F  S LEXI=$O(LEX(LEXI)) Q:+LEXI=0  S X=$G(LEX(LEXI)) D ^DIWP
	K LEX S (LEXC,LEXI)=0 F  S LEXI=$O(^UTILITY($J,"W",1,LEXI)) Q:+LEXI=0  D
	. S LEX(LEXI)=$$TM($G(^UTILITY($J,"W",1,LEXI,0))," "),LEXC=LEXC+1
	S:$L(LEXC) LEX=LEXC K ^UTILITY($J,"W")
	Q
MCE(X)	; Major Concept Expression
	S X=+($G(^LEX(757,+($G(^LEX(757.01,+($G(X)),1))),0)))
	Q X
TM(X,Y)	; Trim Character Y - Default " "
	S X=$G(X) Q:X="" X  S Y=$G(Y) S:'$L(Y) Y=" "
	F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
	F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
	Q X
