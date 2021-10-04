LEX10CX4	;ISL/KER - ICD-10 Cross-Over - Ask ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^UTILITY($J         ICR  10011
	;               
	; External References
	;    ^DIC                ICR  10006
	;    ^DIR                ICR  10026
	;    ^DIWP               ICR  10011
	;    $$UP^XLFSTR         ICR  10104
	;               
	; Local Variables NEWed or KILLed Elsewhere
	;     LEX0FND,LEX0REV,LEX0SEL NEWed in LEX10CX
	;               
ASK(LEXA,LEXB)	;   Ask for Selection
	N LEXSRCO,LEXSRTX,LEXSRNM,LEXANS,LEXFND,LEXI,LEXIND,LEXLEN,LEXT
	S Y=-1,LEXFND=+($G(LEXB(0))) Q:LEXFND'>0  S LEX0FND=1
	S LEXSRCO=$G(LEXA("SOURCE","SOE"))
	S LEXSRTX=$$UP^XLFSTR($G(LEXA("SOURCE","EXP")))
	S LEXSRNM=$G(LEXA("SOURCE","SRC"))
	W ! I $L($G(LEXSRTX)),$L($G(LEXSRCO)) D
	. W !," ",LEXSRNM," ",LEXSRCO
	. N LEXIND,LEXLEN,LEXT,LEXI S LEXIND=18,LEXT(1)=LEXSRTX
	. D PAR(.LEXT,50) W ?22," ",$G(LEXT(1))
	. S LEXI=1 F  S LEXI=$O(LEXT(LEXI)) Q:+LEXI'>0  D
	. . N LEXTX2 S LEXTX2=$$TM($G(LEXT(LEXI))) Q:'$L(LEXTX2)
	. . W !,?23,LEXTX2
	S:+LEXFND=1 LEXANS=$$ONE S:+LEXFND>1 LEXANS=$$MUL
	I LEXANS>0 D  S:+($G(X))'>0 X="" S:+($G(Y))'>0 Y=-1 Q
	. S X="",Y=-1 D X(.LEXA),Y(LEXANS,.LEXB)
	. Q:+($G(X))>0&(+($G(Y))>0)  S X="",Y=-1
	I LEXANS'>0 K X,Y,LEXB S X="",Y=-1
	Q
ONE(X)	;     One Entry Found - Needs LEXB
	N LEXIEN,LEXLN,LEXSO,LEXTEXT N DIR
	N LEXTXT,Y S LEXTEXT=$G(LEXB(1)),LEXIEN=+LEXTEXT
	S LEXSO=$P(LEXTEXT,U,2),LEXTEXT=$P(LEXTEXT,U,3)
	S LEXTXT(1)=LEXSO_"   "_LEXTEXT D PAR(.LEXTXT,64)
	S DIR("A",1)=" One ICD-10 suggestion found",DIR("A",2)=" "
	S DIR("A",3)="     "_$G(LEXTXT(1)),LEXLN=3
	I $L($G(LEXTXT(2))) S LEXLN=LEXLN+1 D
	. S DIR("A",LEXLN)="                     "_$G(LEXTXT(2))
	S LEXLN=LEXLN+1,DIR("A",LEXLN)=" ",LEXLN=LEXLN+1
	S DIR("A")="   OK?  ",DIR("B")="Yes",DIR(0)="YAO" W !
	D ^DIR S LEX0REV=1 S:+Y>0 LEX0SEL=1 Q:+Y>0 1
	Q:X["^^"!($D(DTOUT)) "^^" Q:X["^" "^"
	Q -1
MUL(X)	;     Multiple Entries Found - Needs LEXB
	N LEXENT,LEXIEN,LEXIT,LEXITEM,LEXLEN,LEXMAX,LEXMAT,LEXN,LEXSEL
	N LEXSO,LEXTEXT,LEXTOT,Y S LEXLEN=+($G(LEXN))
	S:+LEXLEN'>4 LEXLEN=5  N LEXN
	S (LEXMAX,LEXENT,LEXSEL,LEXIT)=0
	S U="^",LEXTOT=$G(LEXB(0))
	S LEXSEL=0 G:+LEXTOT=0 MULQ
	S LEXMAT=LEXTOT_" ICD-10 suggestion"_$S(+LEXTOT>1:"s",1:"")_" found"
	W:+LEXTOT>0 !!," ",LEXMAT
	F LEXENT=1:1:LEXTOT Q:LEXIT  D  Q:LEXIT
	. I ((LEXSEL>0)&(LEXSEL<LEXENT+1)) S LEXIT=1 Q
	. N LEXITEM,LEXIEN,LEXTEXT,LEXSO
	. S LEXITEM=$G(LEXB(LEXENT))
	. S LEXIEN=+LEXITEM,LEXSO=$P(LEXITEM,U,3)
	. S LEXTEXT=$P(LEXITEM,U,2) Q:+LEXIEN'>0
	. Q:'$L(LEXSO)  Q:'$L(LEXTEXT)
	. S LEXMAX=LEXENT W:LEXENT#LEXLEN=1 ! D MULW
	. S:LEXMAX=LEXTOT LEX0REV=1
	. W:LEXENT#LEXLEN=0 !
	. S:LEXENT#LEXLEN=0 LEXSEL=$$MULS(LEXMAX,LEXENT)
	. S:LEXSEL["^" LEXIT=1
	I LEXENT#LEXLEN'=0,+LEXSEL=0 D
	. W ! S LEXSEL=$$MULS(LEXMAX,LEXENT)
	. S:LEXSEL["^" LEXIT=1
	G MULQ
	Q X
MULW	;       Write Multiple - Needs LEXENT,LEXIEN,LEXSO,LEXTXT
	Q:+($G(LEXENT))'>0  Q:+($G(LEXIEN))'>0
	Q:'$L($G(LEXTEXT))  Q:'$L($G(LEXSO))
	N LEXI,LEXIND,LEXTAB,LEXTXT,LEXTX2
	S LEXTAB=8,LEXIND=18
	W !,$J(LEXENT,5),".",?LEXTAB,LEXSO
	S LEXTXT(1)=LEXTEXT D PAR(.LEXTXT,54)
	W ?LEXIND,$G(LEXTXT(1))
	S LEXI=1 F  S LEXI=$O(LEXTXT(LEXI)) Q:+LEXI'>0  D
	. N LEXTX2 S LEXTX2=$$TM($G(LEXTXT(LEXI))) Q:'$L(LEXTX2)
	. W !,?LEXIND,LEXTX2
	Q
MULS(X,Y)	;       Select Multiple - Needs LEXB, Uses LEXIT,LEXTOT
	N DIR,DIRB,LEXHLP,LEXLAST,LEXMAX
	N LEXNEXT,LEXRAN,LEXS,LEXENT,Y Q:+($G(LEXIT))>0 "^^"
	S LEXS=$G(X),LEXENT=$G(Y) N X
	S LEXMAX=+($G(LEXS)),LEXLAST=+($G(LEXENT))
	Q:LEXMAX=0 -1  S LEXRAN=" Select 1-"_LEXMAX_":  "
	S LEXNEXT=$O(LEXB(+LEXLAST)) I +LEXNEXT>0 D
	. S DIR("A")=" Press <RETURN> for more, "
	. S DIR("A")=DIR("A")_"'^' to exit, or"_LEXRAN
	S:+LEXNEXT'>0 DIR("A")=LEXRAN
	S LEXHLP="    Answer must be from 1 to "_LEXMAX
	S LEXHLP=LEXHLP_", or <Return> to continue"
	S DIR("PRE")="S:X[""?"" X=""??"""
	S (DIR("?"),DIR("??"))="^D MULSH^ICDEXLK2"
	S DIR(0)="NAO^1:"_LEXMAX_":0" D ^DIR
	S:X["^"&(LEXENT=+($G(LEXTOT))) (X,Y)="^^^"
	S:X["^^"!($D(DTOUT)) LEXIT=1,X="^^"
	I X["^^"!(+($G(LEXIT))>0) Q "^^"
	S LEXS=+Y S:$D(DTOUT)!(X[U) LEXS=U
	K DIR N LEXIT,LEXTOT
	S:+LEXS>0&($D(LEXB(+LEXS))) LEX0SEL=1
	Q LEXS
MULSH	;       Select Multiple Help
	I $L($G(LEXHLP)) W !,$G(LEXHLP) Q
	Q
MULQ	;       Quit Multiple
	Q:+LEXSEL'>0 -1  S X=+LEXSEL
	Q X
	; 
	; Miscellaneous
PAR(LEXC,LEXL)	;   Parse Array
	N %,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,LEXIEN,I,X,Z
	K ^UTILITY($J,"W") Q:'$D(LEXC)  S LEXL=+($G(LEXL))
	S:+LEXL'>0 LEXL=79 S DIWL=1,DIWF="C"_+LEXL S LEXIEN=0
	F  S LEXIEN=$O(LEXC(LEXIEN)) Q:+LEXIEN=0  D
	. S X=$G(LEXC(LEXIEN)) D ^DIWP
	K LEXC S LEXIEN=0
	F  S LEXIEN=$O(^UTILITY($J,"W",1,LEXIEN)) Q:+LEXIEN=0  D
	. S LEXC(LEXIEN)=$$TM($G(^UTILITY($J,"W",1,LEXIEN,0))," ")
	K ^UTILITY($J,"W")
	Q
TM(X,Y)	;   Trim Y
	S Y=$G(Y) S:'$L(Y) Y=" "
	F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
	F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
	Q X
X(LEXA)	;   Set X
	N LEXEXP,LEXCOD,LEXNOM,LEXIEN K X S X=""
	S LEXEXP=$G(LEXA("SOURCE","EXP")) Q:'$L(LEXEXP)
	S LEXCOD=$G(LEXA("SOURCE","SOE")) Q:'$L(LEXCOD)
	S LEXNOM=$G(LEXA("SOURCE","SRC")) Q:'$L(LEXNOM)
	S LEXIEN=+($G(LEXA("SOURCE","Y"))) Q:'$L(LEXIEN)
	Q:+LEXIEN'>0  S X=LEXIEN_"^"_LEXEXP_"^"_LEXCOD_"^"_LEXNOM
	Q
Y(LEX,LEXB)	;   Set Y
	N LEXEXP,LEXCOD,LEXNOM,LEXIEN,LEXDAT
	N LEXDAT,LEXEIEN,LEXEX,LEXICDD,LEXSO,LEXSTA,LEXTD
	K Y S Y=-1 S LEX=+($G(LEX)),LEXDAT=$G(LEXB(+LEX))
	S LEXEXP=$P(LEXDAT,"^",2) Q:'$L(LEXEXP)
	S LEXCOD=$P(LEXDAT,"^",3) Q:'$L(LEXCOD)
	S LEXNOM="ICD-10-CM"
	S LEXIEN=+($P(LEXDAT,"^",1)) Q:'$L(LEXIEN)
	Q:+LEXIEN'>0  S Y=LEXIEN_"^"_LEXEXP_"^"_LEXCOD_"^"_LEXNOM
	Q
SAB(X)	;   Select Coding System
	N DIC,DIROUT,DIRUT,DTOUT,DUOUT,LEXB,Y
	S DIC="^LEX(757.03,",DIC(0)="AEQM"
	S DIC("A")=" Select a Coding System:  "
	S LEXB=$P($G(^LEX(757.03,1,0)),"^",2) S:$L(LEXB) DIC("B")=LEXB
	S DIC("W")="N LEX1,LEX2 S LEX1=$P($G(^LEX(757.03,+Y,0)),U,2),"
	S DIC("W")=DIC("W")_"LEX2=$P($G(^LEX(757.03,+Y,0)),U,3) "
	S DIC("W")=DIC("W")_"S:$L(LEX2,"","")>2 LEX2=$P(LEX2,"","",1,"
	S DIC("W")=DIC("W")_"($L(LEX2,"","")-1)) W "" "",LEX1"
	S DIC("W")=DIC("W")_"_$J("" "",(12-$L(LEX1)))_""  ""_LEX2"
	S DIC("S")="I $E($P($G(^LEX(757.03,+Y,0)),""^"",1),1,3)'=""10D"""
	S DIC("W")="W ""   "",$P($G(^LEX(757.03,+Y,0)),U,2)"
	K X D ^DIC Q:X["^"!($D(DTOUT))!($D(DUOUT)) "^"
	S LEXB=$E($P($G(^LEX(757.03,+Y,0)),"^",1),1,3) Q:$L(LEXB)'=3 "^"
	Q:'$D(^LEX(757.03,"ASAB",LEXB)) "^"  S X=LEXB
	Q X
